import 'package:base_http/base_http.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:next_shala/components/carousel.dart';
import 'package:next_shala/config/routing_arg.dart';
import 'package:next_shala/screens/image_full_view.dart';
import 'package:next_shala/utils/transparent_screen_overlay.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  bool isLoading = true;
  List eventsData = [];
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
        .post('/login.svc/geteventdetails', data: {"stud_id": args.studentId});
    if (response.data['event_data_detailsResult']['Status'] == 'Success') {
      setState(() {
        isLoading = false;
        eventsData = response.data['event_data_detailsResult']['SectionInfo'][0]
            ['EventInfo'];
      });
    } else {
      setState(() {
        isLoading = false;
        error = response.data['event_data_detailsResult']['Message'];
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
              title: Text(eventsData[index]['EventDate'],
                  style: GoogleFonts.montserrat(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 15)),
              subtitle: Text(eventsData[index]['EventName'],
                  style: GoogleFonts.montserrat(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 15)),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(eventsData[index]['EventDesc'],
                  style: GoogleFonts.montserrat(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 16)),
            ),
            const SizedBox(height: 10),

            /// Image
            if (eventsData[index]['EventImages'] != null &&
                eventsData[index]['EventImages'].isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ImageCarousel(
                  images: eventsData[index]['EventImages'],
                  objectKey: "EventImage",
                  onClick: (int i) {
                    Navigator.push(
                        context,
                        TransparentFullScreenOverlay(
                            bgColor: Colors.black.withOpacity(0.98),
                            child: PhotoViewerPage(
                              images: eventsData[index]['EventImages'],
                              objectKey: "EventImage",
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
        title: Text("Events",
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
                      child: Text(error!,
                          style: GoogleFonts.montserrat(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16))),
                )
              : eventsData.isEmpty
                  ? Center(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        child: Text("No Data found",
                            style: GoogleFonts.montserrat(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                                fontSize: 16)),
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: List.generate(eventsData.length,
                            (index) => buildEventCard(index)),
                      ),
                    ),
    );
  }
}
