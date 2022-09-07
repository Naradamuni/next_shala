import 'dart:io';
import 'dart:ui';

import 'package:base_http/base_http.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:next_shala/config/routing_arg.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:android_path_provider/android_path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeWorkPage extends StatefulWidget {
  const HomeWorkPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeWorkPageState();
}

class _HomeWorkPageState extends State<HomeWorkPage> {
  List homeWorks = [];
  bool isLoading = true;
  String? error;
  late bool _permissionReady;
  late String _localPath;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => getData());
    FlutterDownloader.registerCallback(downloadCallback, step: 1);
    _permissionReady = false;

    _prepare();
  }

  Future<void> _prepare() async {
    _permissionReady = await _checkPermission();

    if (_permissionReady) {
      await _prepareSaveDir();
    }
  }

  @pragma('vm:entry-point')
  static void downloadCallback(
    String id,
    DownloadTaskStatus status,
    int progress,
  ) {
    print(
      'Callback on background isolate: '
      'task ($id) is in status ($status) and process ($progress)',
    );

    IsolateNameServer.lookupPortByName('downloader_send_port')
        ?.send([id, status, progress]);
  }

  @override
  void dispose() {
    _unbindBackgroundIsolate();
    super.dispose();
  }

  void showSnackbar(BuildContext context, String message) {
    SnackBar snackBar = SnackBar(
      content: Text(message),
    );
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(snackBar);
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  initDownload() async {
    _permissionReady = await _checkPermission();

    if (_permissionReady) {
      await _prepareSaveDir();
    }
  }

  Future<bool> _checkPermission() async {
    if (Platform.isIOS) {
      return true;
    }

    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;
    if (Platform.isAndroid && androidInfo.version.sdkInt <= 28) {
      final status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        final result = await Permission.storage.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  Future<String?> _findLocalPath() async {
    String? externalStorageDirPath;
    if (Platform.isAndroid) {
      try {
        externalStorageDirPath = await AndroidPathProvider.downloadsPath;
      } catch (e) {
        final directory = await getExternalStorageDirectory();
        externalStorageDirPath = directory?.path;
      }
    } else if (Platform.isIOS) {
      externalStorageDirPath =
          (await getApplicationDocumentsDirectory()).absolute.path;
    }
    return externalStorageDirPath;
  }

  Future<void> _prepareSaveDir() async {
    _localPath = (await _findLocalPath())!;
    final savedDir = Directory(_localPath);
    final hasExisted = savedDir.existsSync();
    if (!hasExisted) {
      await savedDir.create();
    }
  }

  Widget info(
      {required String title,
      required String desc,
      Color descColor = Colors.black}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.black54),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          desc,
          style: TextStyle(color: descColor, fontSize: 16),
        ),
      ],
    );
  }

  Widget buildStudentInfoCard(int index) {
    return Container(
      width: double.infinity,
      child: Card(
        margin: const EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Wrap(
            spacing: 30,
            runSpacing: 20,
            children: [
              info(title: "Sl. No", desc: (index + 1).toString()),
              info(
                title: "Date",
                desc: homeWorks[index]['HomeWorkData'][0]['HomeWorkDate']
                    .split(" ")[0],
              ),
              info(
                  title: "Home Work",
                  desc: homeWorks[index]['HomeWorkData'][0]['HomeWorkTittle']),
              if (homeWorks[index]['HomeWorkData'][0]['HomeWorkFile'] != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Download File",
                      style: TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                        onTap: () async {
                          var result = await GallerySaver.saveImage(
                                  homeWorks[index]['HomeWorkData'][0]
                                      ['HomeWorkFile'])
                              .then((value) {
                            print(value);
                          }).catchError((onError) {
                            print(onError);
                          });
                          int pathindex = homeWorks[index]['HomeWorkData'][0]
                                  ['HomeWorkFile']
                              .lastIndexOf('/');

                          String path = _localPath +
                              homeWorks[index]['HomeWorkData'][0]
                                      ['HomeWorkFile']
                                  .substring(pathindex);
                          print(result);
                          // final taskId = await FlutterDownloader.enqueue(
                          //   url:
                          //       '${homeWorks[index]['HomeWorkData'][0]['HomeWorkFile']}',

                          //   savedDir: _localPath,
                          //   saveInPublicStorage: true,
                          //   showNotification:
                          //       true, // show download progress in status bar (for Android)
                          //   openFileFromNotification:
                          //       true, // click on notification to open downloaded file (for Android)
                          // ).catchError((onError) {
                          //   print(onError);
                          // });
                          // if(taskId != null){
                          await OpenFile.open(path).catchError((onError) {
                            print(onError);
                          });
                        },
                        child: const Text(
                          "Click here to download",
                          style: TextStyle(color: Colors.blue, fontSize: 16),
                        )),
                  ],
                )
              // GestureDetector(
              //   onTap: () async {
              //     final taskId = await FlutterDownloader.enqueue(
              //       url:
              //           '${homeWorks[index]['HomeWorkData'][0]['HomeWorkFile']}',

              //       savedDir: _localPath,
              //       saveInPublicStorage: true,
              //       showNotification:
              //           true, // show download progress in status bar (for Android)
              //       openFileFromNotification:
              //           true, // click on notification to open downloaded file (for Android)
              //     ).catchError((onError) {
              //       print(onError);
              //     });
              //     print(taskId);
              //   },
              //   child: info(
              //       title: "Download File",
              //       desc: "Click here to download",
              //       descColor: Colors.blue),
              // )
            ],
          ),
        ),
      ),
    );
  }

  getData() async {
    PageRoutingArguments args =
        ModalRoute.of(context)!.settings.arguments as PageRoutingArguments;

    final response = await networkClient
        .post('/login.svc/gethomework', data: {"stud_id": args.studentId});
    if (response.data['homework_detailsResult']['Status'] == 'Success') {
      setState(() {
        homeWorks = response.data['homework_detailsResult']['HomeWork'];
        isLoading = false;
      });
    } else {
      setState(() {
        error = response.data['attendance_detailsResult']['Message'];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text("Home Work"),
        centerTitle: true,
      ),
      body: (isLoading)
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: List.generate(homeWorks.length,
                    (index) => buildStudentInfoCard(index)).toList(),
              ),
            ),
    );
  }
}
