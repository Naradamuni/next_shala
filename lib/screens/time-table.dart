import 'package:base_http/base_http.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:next_shala/components/carousel.dart';
import 'package:next_shala/config/routing_arg.dart';
import 'package:next_shala/screens/image_full_view.dart';
import 'package:next_shala/utils/transparent_screen_overlay.dart';

class TimeTablePage extends StatefulWidget {
  const TimeTablePage({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TimeTablePageState();
}

class _TimeTablePageState extends State<TimeTablePage> {
  var dateFormat = DateFormat('M/D/yyyy hh:mm:ss a');
  bool isLoading = true;
  List data = [];
  String? error;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => loadData());
  }

  loadData() async {
    PageRoutingArguments args =
        ModalRoute.of(context)!.settings.arguments as PageRoutingArguments;

    final response = await networkClient
        .post('/login.svc/gettimetable', data: {"stud_id": args.studentId});
    if (response.data['time_table_detailsResult']['Status'] == 'Success') {
      setState(() {
        isLoading = false;
        data = response.data['time_table_detailsResult']['SectionInfo'][0]
            ['TimeTableInfo'];
      });
    } else {
      setState(() {
        isLoading = false;
        error = response.data['time_table_detailsResult']['Message'];
      });
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

  Widget buildEventCard(int index) {
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
              if (data[index]['Date'].isNotEmpty)
                info(
                    title: "Date",
                    desc: DateFormat('dd MMM yyyy')
                        .format(dateFormat.parse(data[index]['Date']))),
              info(title: "Name", desc: data[index]['Name']),

              /// Image
              if (data[index]['TimeTableImages'] != null &&
                  data[index]['TimeTableImages'].isNotEmpty)
                ImageCarousel(
                  images: data[index]['TimeTableImages'],
                  objectKey: "ImageFile",
                  onClick: (int i) {
                    Navigator.push(
                        context,
                        TransparentFullScreenOverlay(
                            bgColor: Colors.black.withOpacity(0.98),
                            child: PhotoViewerPage(
                              images: data[index]['TimeTableImages'],
                              objectKey: "ImageFile",
                              currentImageIndex: i,
                            )));
                  },
                ),
              info(title: "Description", desc: data[index]['Description']),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Time table'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : error != null
              ? Center(
                  child: Container(
                      padding:
                          const EdgeInsets.only(top: 100, left: 10, right: 10),
                      child: Text(error!)),
                )
              : data.isEmpty
                  ? Center(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        child: const Text("No Data found"),
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: List.generate(
                            data.length, (index) => buildEventCard(index)),
                      ),
                      // scrollDirection: Axis.vertical,
                      // child: SingleChildScrollView(
                      //     scrollDirection: Axis.horizontal,
                      //     child: Container(
                      //       margin: const EdgeInsets.only(top: 10),
                      //       child: (data == null)
                      //           ? const Text("No data found")
                      //           : Column(
                      //               children: [
                      //                 const SizedBox(
                      //                   height: 20,
                      //                 ),
                      //                 DataTable(
                      //                   columns: const [
                      //                     DataColumn(label: Text("Sl")),
                      //                     DataColumn(label: Text("Date")),
                      //                     DataColumn(label: Text("Name")),
                      //                     DataColumn(label: Text("Description")),
                      //                     DataColumn(label: Text("Image")),
                      //                   ],
                      //                   rows: List.generate(
                      //                           data.length,
                      //                           (index) =>
                      //                               buildAttendenceInfo(index))
                      //                       .toList(),
                      //                 ),
                      //               ],
                      //             ),
                      //     )),
                    ),
    );
  }
}
