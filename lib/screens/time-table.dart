import 'package:base_http/base_http.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    return SizedBox(
      width: double.infinity,
      child: Card(
        margin: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: index % 2 == 0
                      ? Colors.cyan
                      : Colors.blue.withOpacity(0.9),
                ),
                child: Center(
                  child: Text((index + 1).toString(),
                      style: GoogleFonts.montserrat(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 12)),
                ),
              ),
              title: Text(
                  DateFormat('dd MMM yyyy')
                      .format(dateFormat.parse(data[index]['Date'])),
                  style: GoogleFonts.montserrat(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 15)),
              subtitle: Text(data[index]['Name'],
                  style: GoogleFonts.montserrat(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 15)),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(data[index]['Description'],
                  style: GoogleFonts.montserrat(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 16)),
            ),
            const SizedBox(height: 10),
            if (data[index]['TimeTableImages'] != null &&
                data[index]['TimeTableImages'].isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ImageCarousel(
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
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        automaticallyImplyLeading: true,
        title: Text("Time Table Portion",
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
                    ),
    );
  }
}
