import 'dart:io';
import 'dart:ui';

import 'package:base_http/base_http.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:next_shala/config/routing_arg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:android_path_provider/android_path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:open_file/open_file.dart';

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
  var dateFormat = DateFormat('M/D/yyyy hh:mm:ss a');
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => getData());
    _permissionReady = false;

    _prepare();
  }

  Future<void> _prepare() async {
    _permissionReady = await _checkPermission();

    if (_permissionReady) {
      await _prepareSaveDir();
    }
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
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 12.0),
        child: Card(
            elevation: 4,
            color: Colors.transparent,
            child: Center(
              child: Container(
                height: 150,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0XffFF9966),
                      Color(0XffFF5E62),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                          "Home Work : ${homeWorks[index]['HomeWorkData'][0]['HomeWorkTittle']}",
                          style: GoogleFonts.montserrat(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          )),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                            "${"Date :"}"
                            " ${homeWorks[index]['HomeWorkData'][0]['HomeWorkDate']}",
                            style: GoogleFonts.montserrat(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 16)),
                      ),
                      leading: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                        ),
                        child: Center(
                          child: Text((index + 1).toString(),
                              style: GoogleFonts.montserrat(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12)),
                        ),
                      ),
                    ),
                    homeWorks[index]['HomeWorkData'][0]['HomeWorkFile'] != null
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 70.0),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Text(
                                  "Download File",
                                  style: GoogleFonts.montserrat(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Container(),
                    homeWorks[index]['HomeWorkData'][0]['HomeWorkFile'] != null
                        ? Container(
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.transparent),
                                shadowColor: MaterialStateProperty.all(
                                    Colors.transparent),
                              ),
                              onPressed: () async {
                                var imageId =
                                    await ImageDownloader.downloadImage(
                                        homeWorks[index]['HomeWorkData'][0]
                                            ['HomeWorkFile']);
                                if (imageId == null) {
                                  return;
                                }

                                var path =
                                    await ImageDownloader.findPath(imageId);
                                await OpenFile.open(path).catchError((onError) {
                                  print(onError);
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  top: 5,
                                  bottom: 5,
                                ),
                                child: Text('Click here to download',
                                    style: GoogleFonts.montserrat(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16)),
                              ),
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
            )),
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
        error = response.data['homework_detailsResult']['Message'];
        isLoading = false;
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        automaticallyImplyLeading: true,
        title: Text("Home Work",
            style: GoogleFonts.montserrat(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 24)),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Colors.blue,
                  blurRadius: 5,
                  spreadRadius: 0,
                  offset: Offset(2, 2)),
            ],
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  Color(0Xff00AEEF),
                  Color(0Xff2377B8),
                ]),
          ),
        ),
        centerTitle: true,
      ),
      body: (isLoading)
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : homeWorks.isEmpty
              ? Center(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: Text("No Data found",
                        style: GoogleFonts.montserrat(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                  ),
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
