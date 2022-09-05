import 'package:base_http/base_http.dart';
import 'package:flutter/material.dart';
import 'package:next_shala/config/routing_arg.dart';

class AttendencePage extends StatefulWidget {
  const AttendencePage({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AttendencePageState();
}

class _AttendencePageState extends State<AttendencePage> {
  bool isLoading = true;
  late dynamic attendeceData;
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
        .post('/login.svc/getattendance', data: {"stud_id": args.studentId});
    if (response.data['attendance_detailsResult']['Status'] == 'Success') {
      setState(() {
        isLoading = false;
        attendeceData =
            response.data['attendance_detailsResult']['AttendanceDetails'];
      });
    } else {
      setState(() {
        isLoading = false;
        error = response.data['attendance_detailsResult']['Message'];
      });
    }
  }

  DataRow buildAttendenceInfo(int index) {
    return DataRow(cells: [
      DataCell(
        Text((index + 1).toString()),
      ),
      DataCell(
        Text(attendeceData[index]['AttendanceDate']),
      ),
      DataCell(
        Text(attendeceData[index]['AttendanceStatus']),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Attendence'),
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
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: (attendeceData == null)
                        ? const Text("No data found")
                        : Column(
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Academic Year: ${attendeceData[0]['AcademicYear']}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              DataTable(
                                columns: const [
                                  DataColumn(label: Text("Sl")),
                                  DataColumn(label: Text("Date")),
                                  DataColumn(label: Text("Status"))
                                ],
                                rows: List.generate(attendeceData.length,
                                        (index) => buildAttendenceInfo(index))
                                    .toList(),
                              ),
                            ],
                          ),
                  ),
                ),
    );
  }
}
