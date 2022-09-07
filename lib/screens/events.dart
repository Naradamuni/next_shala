import 'package:base_http/base_http.dart';
import 'package:flutter/material.dart';
import 'package:next_shala/components/carousel.dart';
import 'package:next_shala/config/routing_arg.dart';

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
                  desc: eventsData[index]['EventDate'].split(" ")[0]),
              info(title: "Name", desc: eventsData[index]['EventName']),

              /// Image
              if (eventsData[index]['EventImages'] != null &&
                  eventsData[index]['EventImages'].isNotEmpty)
                ImageCarousel(
                  images: eventsData[index]['EventImages'],
                  onClick: (int i) {},
                ),

              info(
                  title: "Details",
                  desc: eventsData[index]['EventDesc'],
                  descColor: Colors.blue),
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
        title: const Text('Events'),
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
              : eventsData.isEmpty
                  ? Center(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        child: const Text("No Data found"),
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: List.generate(eventsData.length,
                            (index) => buildEventCard(index)),
                      ),
                      // scrollDirection: Axis.vertical,
                      // child: SingleChildScrollView(
                      //     scrollDirection: Axis.horizontal,
                      //     child: Container(
                      //       margin: const EdgeInsets.only(top: 10),
                      //       child: (eventsData == null)
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
                      //                           eventsData.length,
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
