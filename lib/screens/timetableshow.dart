import 'package:base_http/base_http.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:next_shala/config/routing_arg.dart';

class WeekdaysScreen extends StatefulWidget {
  const WeekdaysScreen({
    Key? key,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() => _WeekdaysScreenState();
}

class _WeekdaysScreenState extends State<WeekdaysScreen> {
  bool isLoading = true;
  List timetableData = [];
  String? error;
  static const List<String> weekdays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => loadData());
  }

  loadData() async {
    PageRoutingArguments args =
        ModalRoute.of(context)!.settings.arguments as PageRoutingArguments;

    final response = await networkClient.post('/login.svc/getdaytimetable',
        data: {"section_id": args.sectionId});
    if (response.data['time_table_day_wiseResult']['Status'] == 'Success') {
      setState(() {
        isLoading = false;
        timetableData =
            response.data['time_table_day_wiseResult']['TimeTableDayWise'];
      });
    } else {
      setState(() {
        isLoading = false;
        error = response.data['event_data_detailsResult']['Message'];
      });
    }
    // timetableData = [
    //   {
    //     "Day": "Friday",
    //     "SectionId": "90",
    //     "SectionName": "1Extra Class",
    //     "time_Table_Day_Wise_Details": [
    //       {
    //         "AcademicId": null,
    //         "ClassId": "1",
    //         "ClassName": "1st std",
    //         "CourseId": "1",
    //         "CourseName": "Primary",
    //         "Period": "11:20AM to 11:30AM",
    //         "StaffId": "135",
    //         "StaffName": "RIMS",
    //         "SubjectId": "17",
    //         "SubjectName": "MUSIC",
    //         "TimeTableId": "9853"
    //       },
    //       {
    //         "AcademicId": null,
    //         "ClassId": "1",
    //         "ClassName": "1st std",
    //         "CourseId": "1",
    //         "CourseName": "Primary",
    //         "Period": "11:20AM to 11:30AM",
    //         "StaffId": "135",
    //         "StaffName": "RIMS",
    //         "SubjectId": "17",
    //         "SubjectName": "MUSIC",
    //         "TimeTableId": "9853"
    //       },
    //       {
    //         "AcademicId": null,
    //         "ClassId": "1",
    //         "ClassName": "1st std",
    //         "CourseId": "1",
    //         "CourseName": "Primary",
    //         "Period": "11:20AM to 11:30AM",
    //         "StaffId": "135",
    //         "StaffName": "RIMS",
    //         "SubjectId": "17",
    //         "SubjectName": "MUSIC",
    //         "TimeTableId": "9853"
    //       },
    //       {
    //         "AcademicId": null,
    //         "ClassId": "1",
    //         "ClassName": "1st std",
    //         "CourseId": "1",
    //         "CourseName": "Primary",
    //         "Period": "11:20AM to 11:30AM",
    //         "StaffId": "135",
    //         "StaffName": "RIMS",
    //         "SubjectId": "17",
    //         "SubjectName": "MUSIC",
    //         "TimeTableId": "9853"
    //       }
    //     ]
    //   },
    //   {
    //     "Day": "Monday",
    //     "SectionId": "90",
    //     "SectionName": "1Extra Class",
    //     "time_Table_Day_Wise_Details": [
    //       {
    //         "AcademicId": null,
    //         "ClassId": "1",
    //         "ClassName": "1st std",
    //         "CourseId": "1",
    //         "CourseName": "Primary",
    //         "Period": "11:20AM to 11:30AM",
    //         "StaffId": "135",
    //         "StaffName": "RIMS",
    //         "SubjectId": "17",
    //         "SubjectName": "MUSIC",
    //         "TimeTableId": "9853"
    //       },
    //       {
    //         "AcademicId": null,
    //         "ClassId": "1",
    //         "ClassName": "1st std",
    //         "CourseId": "1",
    //         "CourseName": "Primary",
    //         "Period": "11:20AM to 11:30AM",
    //         "StaffId": "135",
    //         "StaffName": "RIMS",
    //         "SubjectId": "17",
    //         "SubjectName": "MUSIC",
    //         "TimeTableId": "9853"
    //       },
    //       {
    //         "AcademicId": null,
    //         "ClassId": "1",
    //         "ClassName": "1st std",
    //         "CourseId": "1",
    //         "CourseName": "Primary",
    //         "Period": "11:20AM to 11:30AM",
    //         "StaffId": "135",
    //         "StaffName": "RIMS",
    //         "SubjectId": "17",
    //         "SubjectName": "MUSIC",
    //         "TimeTableId": "9853"
    //       },
    //       {
    //         "AcademicId": null,
    //         "ClassId": "1",
    //         "ClassName": "1st std",
    //         "CourseId": "1",
    //         "CourseName": "Primary",
    //         "Period": "11:20AM to 11:30AM",
    //         "StaffId": "135",
    //         "StaffName": "RIMS",
    //         "SubjectId": "17",
    //         "SubjectName": "MUSIC",
    //         "TimeTableId": "9853"
    //       }
    //     ]
    //   },
    //   {
    //     "Day": "Saturday",
    //     "SectionId": "90",
    //     "SectionName": "1Extra Class",
    //     "time_Table_Day_Wise_Details": [
    //       {
    //         "AcademicId": null,
    //         "ClassId": "1",
    //         "ClassName": "1st std",
    //         "CourseId": "1",
    //         "CourseName": "Primary",
    //         "Period": "11:20AM to 11:30AM",
    //         "StaffId": "135",
    //         "StaffName": "RIMS",
    //         "SubjectId": "17",
    //         "SubjectName": "MUSIC",
    //         "TimeTableId": "9853"
    //       }
    //     ]
    //   },
    //   {
    //     "Day": "Thursday",
    //     "SectionId": "90",
    //     "SectionName": "1Extra Class",
    //     "time_Table_Day_Wise_Details": [
    //       {
    //         "AcademicId": null,
    //         "ClassId": "1",
    //         "ClassName": "1st std",
    //         "CourseId": "1",
    //         "CourseName": "Primary",
    //         "Period": "11:20AM to 11:30AM",
    //         "StaffId": "135",
    //         "StaffName": "RIMS",
    //         "SubjectId": "17",
    //         "SubjectName": "MUSIC",
    //         "TimeTableId": "9853"
    //       },
    //       {
    //         "AcademicId": null,
    //         "ClassId": "1",
    //         "ClassName": "1st std",
    //         "CourseId": "1",
    //         "CourseName": "Primary",
    //         "Period": "11:20AM to 11:30AM",
    //         "StaffId": "135",
    //         "StaffName": "RIMS",
    //         "SubjectId": "17",
    //         "SubjectName": "MUSIC",
    //         "TimeTableId": "9853"
    //       },
    //       {
    //         "AcademicId": null,
    //         "ClassId": "1",
    //         "ClassName": "1st std",
    //         "CourseId": "1",
    //         "CourseName": "Primary",
    //         "Period": "11:20AM to 11:30AM",
    //         "StaffId": "135",
    //         "StaffName": "RIMS",
    //         "SubjectId": "17",
    //         "SubjectName": "MUSIC",
    //         "TimeTableId": "9853"
    //       },
    //       {
    //         "AcademicId": null,
    //         "ClassId": "1",
    //         "ClassName": "1st std",
    //         "CourseId": "1",
    //         "CourseName": "Primary",
    //         "Period": "11:20AM to 11:30AM",
    //         "StaffId": "135",
    //         "StaffName": "RIMS",
    //         "SubjectId": "17",
    //         "SubjectName": "MUSIC",
    //         "TimeTableId": "9853"
    //       }
    //     ]
    //   },
    //   {
    //     "Day": "Tuesday",
    //     "SectionId": "90",
    //     "SectionName": "1Extra Class",
    //     "time_Table_Day_Wise_Details": [
    //       {
    //         "AcademicId": null,
    //         "ClassId": "1",
    //         "ClassName": "1st std",
    //         "CourseId": "1",
    //         "CourseName": "Primary",
    //         "Period": "11:20AM to 11:30AM",
    //         "StaffId": "135",
    //         "StaffName": "RIMS",
    //         "SubjectId": "17",
    //         "SubjectName": "MUSIC",
    //         "TimeTableId": "9853"
    //       },
    //       {
    //         "AcademicId": null,
    //         "ClassId": "1",
    //         "ClassName": "1st std",
    //         "CourseId": "1",
    //         "CourseName": "Primary",
    //         "Period": "11:20AM to 11:30AM",
    //         "StaffId": "135",
    //         "StaffName": "RIMS",
    //         "SubjectId": "17",
    //         "SubjectName": "MUSIC",
    //         "TimeTableId": "9853"
    //       },
    //       {
    //         "AcademicId": null,
    //         "ClassId": "1",
    //         "ClassName": "1st std",
    //         "CourseId": "1",
    //         "CourseName": "Primary",
    //         "Period": "11:20AM to 11:30AM",
    //         "StaffId": "135",
    //         "StaffName": "RIMS",
    //         "SubjectId": "17",
    //         "SubjectName": "MUSIC",
    //         "TimeTableId": "9853"
    //       },
    //       {
    //         "AcademicId": null,
    //         "ClassId": "1",
    //         "ClassName": "1st std",
    //         "CourseId": "1",
    //         "CourseName": "Primary",
    //         "Period": "11:20AM to 11:30AM",
    //         "StaffId": "135",
    //         "StaffName": "RIMS",
    //         "SubjectId": "17",
    //         "SubjectName": "MUSIC",
    //         "TimeTableId": "9853"
    //       }
    //     ]
    //   },
    //   {
    //     "Day": "Wednesday",
    //     "SectionId": "90",
    //     "SectionName": "1Extra Class",
    //     "time_Table_Day_Wise_Details": [
    //       {
    //         "AcademicId": null,
    //         "ClassId": "1",
    //         "ClassName": "1st std",
    //         "CourseId": "1",
    //         "CourseName": "Primary",
    //         "Period": "11:20AM to 11:30AM",
    //         "StaffId": "135",
    //         "StaffName": "RIMS",
    //         "SubjectId": "17",
    //         "SubjectName": "MUSIC",
    //         "TimeTableId": "9853"
    //       },
    //       {
    //         "AcademicId": null,
    //         "ClassId": "1",
    //         "ClassName": "1st std",
    //         "CourseId": "1",
    //         "CourseName": "Primary",
    //         "Period": "11:20AM to 11:30AM",
    //         "StaffId": "135",
    //         "StaffName": "RIMS",
    //         "SubjectId": "17",
    //         "SubjectName": "MUSIC",
    //         "TimeTableId": "9853"
    //       },
    //       {
    //         "AcademicId": null,
    //         "ClassId": "1",
    //         "ClassName": "1st std",
    //         "CourseId": "1",
    //         "CourseName": "Primary",
    //         "Period": "11:20AM to 11:30AM",
    //         "StaffId": "135",
    //         "StaffName": "RIMS",
    //         "SubjectId": "17",
    //         "SubjectName": "MUSIC",
    //         "TimeTableId": "9853"
    //       },
    //       {
    //         "AcademicId": null,
    //         "ClassId": "1",
    //         "ClassName": "1st std",
    //         "CourseId": "1",
    //         "CourseName": "Primary",
    //         "Period": "11:20AM to 11:30AM",
    //         "StaffId": "135",
    //         "StaffName": "RIMS",
    //         "SubjectId": "17",
    //         "SubjectName": "MUSIC",
    //         "TimeTableId": "9853"
    //       }
    //     ]
    //   }
    // ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        automaticallyImplyLeading: true,
        title: Text("Time Table",
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
      body: timetableData.isEmpty
          ? Container()
          : ListView.builder(
              itemCount: weekdays.length,
              itemBuilder: (BuildContext context, int index) {
                return WeekdayTile(
                  weekday: weekdays[index],
                  color: getColor(index),
                  timetable: timetableData.firstWhere((element) =>
                      element['Day'] ==
                      weekdays[index])['time_Table_Day_Wise_Details'],
                );
              },
            ),
    );
  }

  Color getColor(int index) {
    List<Color> colors = [
      Colors.red.shade200,
      Colors.orange.shade300,
      Colors.yellow.shade400,
      Colors.green.shade400,
      Colors.blue.shade400,
      Colors.indigo.shade300,
      Colors.purple.shade200,
    ];
    return colors[index % colors.length];
  }
}

class WeekdayTile extends StatefulWidget {
  final String weekday;
  final Color color;
  final List timetable;

  const WeekdayTile({
    super.key,
    required this.weekday,
    required this.color,
    required this.timetable,
  });

  @override
  _WeekdayTileState createState() => _WeekdayTileState();
}

class _WeekdayTileState extends State<WeekdayTile> {
  bool isExpanded = false;
  int selectedIndex = -1;
  int? index;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: widget.color,
      child: InkWell(
          onTap: toggleExpanded,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.black12,
                      child: Text(
                        widget.weekday.substring(0, 1),
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(right: 20)),
                    Expanded(
                      child: Text(widget.weekday,
                          style: GoogleFonts.montserrat(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 20)),
                    ),
                    Icon(
                      isExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: Colors.black,
                    ),
                  ],
                ),
                isExpanded == false
                    ? Container()
                    : Column(
                        children: List.generate(
                            widget.timetable.length,
                            (index) => Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    children: [
                                      Column(
                                        children: [
                                          Text("Period",
                                              style: GoogleFonts.montserrat(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15)),
                                          const Padding(
                                              padding: EdgeInsets.only(top: 3)),
                                          Text(
                                              widget.timetable[index]
                                                  ['PeriodId'],
                                              style: GoogleFonts.montserrat(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 15)),
                                        ],
                                      ),
                                      const Spacer(),
                                      Column(
                                        children: [
                                          Text("Time",
                                              style: GoogleFonts.montserrat(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15)),
                                          const Padding(
                                              padding: EdgeInsets.only(top: 3)),
                                          Text(
                                              widget.timetable[index]['Period'],
                                              style: GoogleFonts.montserrat(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 15)),
                                        ],
                                      ),
                                      const Spacer(),
                                      Column(
                                        children: [
                                          Text("Subject",
                                              style: GoogleFonts.montserrat(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15)),
                                          const Padding(
                                              padding: EdgeInsets.only(top: 3)),
                                          Text(
                                              widget.timetable[index]
                                                  ['SubjectName'],
                                              style: GoogleFonts.montserrat(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 15)),
                                        ],
                                      )
                                    ],
                                  ),
                                )).toList(),
                      )
              ],
            ),
          )),
    );
  }

  void toggleExpanded() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }
}
