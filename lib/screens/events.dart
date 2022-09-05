import 'package:base_http/base_http.dart';
import 'package:flutter/material.dart';
import 'package:next_shala/components/carousel.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  bool isLoading = true;
  late dynamic eventsData;
  String? error;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => loadData());
  }

  loadData() async {
    final response = await networkClient.post(
      '/login.svc/geteventdetails',
    );
    if (response.data['event_data_detailsResult']['Status'] == 'Success') {
      setState(() {
        isLoading = false;
        eventsData = response.data['event_data_detailsResult']['EventInfo'];
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
              info(title: "Date", desc: eventsData[index]['EventDate']),
              info(title: "Name", desc: eventsData[index]['EventName']),

              /// Image
              if (eventsData[index]['EventImages'] != null &&
                  eventsData[index]['EventImages'].isNotEmpty)
                ImageCarousel(
                  images: eventsData[index]['EventImages'],
                  onClick: (int i) {},
                ),
              // if (eventsData[index]['EventImages'].isNotEmpty)
              //   Image.network(eventsData[index]['EventImages'].first),
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

  // DataRow buildAttendenceInfo(int index) {
  //   return DataRow(cells: [
  //     DataCell(
  //       Text((index + 1).toString()),
  //     ),
  //     DataCell(
  //       Text(eventsData[index]['EventDate']),
  //     ),
  //     DataCell(
  //       Text(eventsData[index]['EventName']),
  //     ),
  //     DataCell(
  //       Text(eventsData[index]['EventDesc']),
  //     ),
  //     DataCell(
  //       eventsData[index]['EventImages'].isEmpty
  //           ? Container()
  //           : Image.network(eventsData[index]['EventImages'].first),
  //     ),
  //   ]);
  // }

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
              : SingleChildScrollView(
                  child: Column(
                    children: List.generate(
                        eventsData.length, (index) => buildEventCard(index)),
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