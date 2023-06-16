import 'package:base_http/base_http.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  List attendeceData = [];
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white.withOpacity(0.9),
        appBar: AppBar(
          toolbarHeight: 60,
          automaticallyImplyLeading: true,
          title: Text("Attendence",
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
            : attendeceData.isEmpty
                ? SingleChildScrollView(
                    child: Center(
                      child: Container(
                          padding: const EdgeInsets.only(
                              top: 10, left: 10, right: 10),
                          child: const Text("No data found")),
                    ),
                  )
                : Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Row(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                    "Academic Year: ${attendeceData[0]['AcademicYear']}",
                                    style: GoogleFonts.montserrat(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20)),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8),
                          child: Table(
                            children: [
                              TableRow(
                                decoration: BoxDecoration(
                                  color: Colors.blueGrey[200],
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8)),
                                ),
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8.0, bottom: 8, left: 15),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('Sl.',
                                              style: GoogleFonts.montserrat(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 20)),
                                        ]),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8.0, bottom: 8),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('Date',
                                              style: GoogleFonts.montserrat(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 20))
                                        ]),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 8.0,
                                      bottom: 8,
                                    ),
                                    child: Column(children: [
                                      Text('Status',
                                          style: GoogleFonts.montserrat(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 20))
                                    ]),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height,
                            child: ListView.builder(
                                itemCount: attendeceData.length,
                                physics: const ScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, right: 8.0, top: 12.0),
                                    child: Card(
                                        elevation: 4,
                                        color: index % 2 == 0
                                            ? Colors.indigo[50]
                                            : Colors.indigo[100],
                                        child: Center(
                                          child: Container(
                                            height: 60,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            child: ListTile(
                                              title: Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                    attendeceData[index]
                                                        ['AttendanceDate'],
                                                    style:
                                                        GoogleFonts.montserrat(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 16,
                                                    )),
                                              ),
                                              leading: Container(
                                                width: 36,
                                                height: 36,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  color: Colors.white,
                                                ),
                                                child: Center(
                                                  child: Text(
                                                      (index + 1).toString(),
                                                      style: GoogleFonts
                                                          .montserrat(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 12)),
                                                ),
                                              ),
                                              trailing: Container(
                                                height: 30,
                                                width: 80,
                                                decoration: BoxDecoration(
                                                  color: attendeceData[index][
                                                              'AttendanceStatus'] ==
                                                          'Absent'
                                                      ? Colors.red[400]
                                                      : Colors.green,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    top: 5,
                                                    bottom: 5,
                                                  ),
                                                  child: Text(
                                                      attendeceData[index]
                                                          ['AttendanceStatus'],
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: GoogleFonts
                                                          .montserrat(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 16)),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )),
                                  );
                                }),
                          ),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}
