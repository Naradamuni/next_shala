import 'package:base_http/base_http.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:next_shala/config/routing_arg.dart';

class Lesson extends StatefulWidget {
  const Lesson({super.key});

  @override
  _LessonState createState() => _LessonState();
}

class _LessonState extends State<Lesson> {
  String? selectedMonth; // Selected month
  // late PageRoutingArguments args;

  List<MonthData> months = [
    MonthData(name: 'January', initial: 'J', id: "1", color: Colors.blue),
    MonthData(name: 'February', initial: 'F', id: "2", color: Colors.red),
    MonthData(name: 'March', initial: 'M', id: "3", color: Colors.green),
    MonthData(name: 'April', initial: 'A', id: "4", color: Colors.brown),
    MonthData(name: 'May', initial: 'M', id: "5", color: Colors.purple),
    MonthData(name: 'June', initial: 'J', id: "6", color: Colors.teal),
    MonthData(name: 'July', initial: 'J', id: "7", color: Colors.indigo),
    MonthData(name: 'August', initial: 'A', id: "8", color: Colors.blueGrey),
    MonthData(
        name: 'September', initial: 'S', id: "9", color: Colors.deepPurple),
    MonthData(
        name: 'October', initial: 'O', id: "10", color: Colors.deepOrange),
    MonthData(name: 'November', initial: 'N', id: "11", color: Colors.brown),
    MonthData(name: 'December', initial: 'D', id: "12", color: Colors.indigo),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        automaticallyImplyLeading: true,
        title: Text("Lesson Plans",
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
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0, left: 20, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.blue, // Border color
                  width: 1.0, // Border width
                ),
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.cyan[100],
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  hint: const Text(
                    'Select a Month',
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                  ), // Default hint text
                  value: selectedMonth,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedMonth = newValue;
                    });
                  },
                  items: [
                    ...months.map<DropdownMenuItem<String>>((MonthData month) {
                      return DropdownMenuItem<String>(
                        value: month.name,
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: month.color,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  month.initial,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              month.name,
                              style: TextStyle(
                                  color: month.color,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
            const Spacer(),
            // const SizedBox(width: 30),
            ElevatedButton(
              onPressed: selectedMonth == null
                  ? null
                  : () {
                      PageRoutingArguments args = ModalRoute.of(context)!
                          .settings
                          .arguments as PageRoutingArguments;
                      Navigator.pushNamed(context, '/lesson_details',
                          arguments: LessonPageRoutingArguments(
                              studentId: args.studentId,
                              month: months
                                  .firstWhere((element) =>
                                      element.name == selectedMonth)
                                  .id));
                      // loadData();
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //       builder: (context) => OtherPage(
                      //             selectedMonth: selectedMonth!,
                      //             studentId: (ModalRoute.of(context)!
                      //                             .settings
                      //                             .arguments
                      //                         as PageRoutingArguments)
                      //                     .studentId ??
                      //                 '',
                      //           )),
                      // );
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedMonth == null
                    ? Colors.cyan[100]
                    : Colors.indigo, // Set the background color
                foregroundColor:
                    selectedMonth == null ? Colors.white : Colors.blue,
                padding: const EdgeInsets.symmetric(
                    horizontal: 25, vertical: 10), // Set the text color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: selectedMonth == null
                      ? const BorderSide(color: Colors.blue, width: 1)
                      : BorderSide(
                          color: Colors.indigo,
                          width: 1), // Button border radius
                ), // Optional: Set the elevation
              ),
              child: Text(
                'Submit',
                style: TextStyle(
                    color: selectedMonth == null ? Colors.blue : Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
              ),
            ),
            // ElevatedButton(
            //   onPressed: selectedMonth == null
            //       ? null
            //       : () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => OtherPage(selectedMonth!)),
            //     );
            //   },
            //   // onPressed: selectedMonth != null
            //   //     ? () {
            //   //   // Navigate to other page here
            //   //   Navigator.push(
            //   //     context,
            //   //     MaterialPageRoute(builder: (context) => OtherPage(selectedMonth!)),
            //   //   );
            //   // }
            //   //     : null, // Disable button if no month is selected
            //   child: const Text(
            //     'Submit',
            //     style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold,fontSize: 14),
            //   ),
            //   // style: ElevatedButton.styleFrom(
            //   //   backgroundColor: Colors.blue, // Set the background color
            //   //   foregroundColor: Colors.white, // Set the text color
            //   //   elevation: 5, // Optional: Set the elevation
            //   // ),
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: Colors.blue, // Set the background color
            //     foregroundColor: Colors.white,
            //     // backgroundColor: selectedMonth == null ? Colors.red : Colors.purple, // Background color
            //     padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16), // Button padding
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(8),
            //       side: const BorderSide(color: Colors.lightBlueAccent, width: 1),// Button border radius
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

class MonthData {
  final String name;
  final String initial;
  final Color color;
  final String id;

  MonthData(
      {required this.name,
      required this.initial,
      required this.id,
      required this.color});
}

class OtherPage extends StatefulWidget {
  const OtherPage({Key? key}) : super(key: key);

  @override
  _OtherPageState createState() => _OtherPageState();
}

class _OtherPageState extends State<OtherPage> {
  bool isLoading = true;
  List data = [];
  String? error;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => loadData());
  }

  // OtherPage(this.selectedMonth, this.studentId, {super.key});
  loadData() async {
    LessonPageRoutingArguments args = ModalRoute.of(context)!.settings.arguments
        as LessonPageRoutingArguments;
    final response = await networkClient.post(
        '/login.svc/getlessonplanchapters',
        data: {"student_id": args.studentId, "month": args.month});
    if (response.data['lesson_plan_chapter_wiseResult']['Status'] ==
        'Success') {
      setState(() {
        isLoading = false;
        data = response.data['lesson_plan_chapter_wiseResult']
            ['LessonPlanSubjectInfo'];
      });
    } else {
      setState(() {
        isLoading = false;
        error = response.data['lesson_plan_chapter_wiseResult']['Message'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        automaticallyImplyLeading: true,
        title: Text("Lesson Plans",
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
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView(
                      children: data
                          .map(
                            (l) =>
                                // const [
                                Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                elevation: 1,
                                child: ExpansionTile(
                                  title: Text(
                                    l['SubjectName'],
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  children:
                                      (l['LessonPlanChaptersInfo'] as List)
                                          .map<Widget>((c) {
                                    return ListTile(
                                      visualDensity: const VisualDensity(
                                        horizontal: 1,
                                        vertical: -4,
                                      ),
                                      title: Text(
                                        c['ChapterName'],
                                        style: const TextStyle(
                                          color: Colors.deepOrange,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          )
                          .toList()
                      // Card(elevation: 2,
                      //   child: ExpansionTile(
                      //     title: Text(
                      //       'Hindi',
                      //       style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold), // Text color
                      //     ),
                      //     children: <Widget>[
                      //       ListTile(
                      //         title: Text(
                      //           'chapter 1',
                      //           style: TextStyle(color: Colors.green,fontWeight: FontWeight.w500), // Text color
                      //         ),
                      //         leading: CircleAvatar( maxRadius: 12,
                      //           backgroundColor: Colors.orange, // Background color of the CircleAvatar
                      //           child: Text(
                      //             '1',
                      //             style: TextStyle(color: Colors.white), // Text color
                      //           ),
                      //         ),
                      //       ),
                      //       ListTile(
                      //         title: Text(
                      //           'chapter 2',
                      //           style: TextStyle(color: Colors.green,fontWeight: FontWeight.w500), // Text color
                      //         ),
                      //         leading: CircleAvatar( maxRadius: 12,
                      //           backgroundColor: Colors.orange, // Background color of the CircleAvatar
                      //           child: Text(
                      //             '2',
                      //             style: TextStyle(color: Colors.white), // Text color
                      //           ),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // Card(elevation: 2,
                      //   child: ExpansionTile(
                      //     title: Text(
                      //       'Kannada',
                      //       style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold), // Text color
                      //     ),
                      //     children: <Widget>[
                      //       ListTile(
                      //         title: Text(
                      //           'chapter 1',
                      //           style: TextStyle(color: Colors.green,fontWeight: FontWeight.w500), // Text color
                      //         ),
                      //         leading: CircleAvatar( maxRadius: 12,
                      //           backgroundColor: Colors.orange, // Background color of the CircleAvatar
                      //           child: Text(
                      //             '1',
                      //             style: TextStyle(color: Colors.white), // Text color
                      //           ),
                      //         ),
                      //       ),
                      //       ListTile(
                      //         title: Text(
                      //           'chapter 2',
                      //           style: TextStyle(color: Colors.green,fontWeight: FontWeight.w500), // Text color
                      //         ),
                      //         leading: CircleAvatar( maxRadius: 12,
                      //           backgroundColor: Colors.orange, // Background color of the CircleAvatar
                      //           child: Text(
                      //             '2',
                      //             style: TextStyle(color: Colors.white), // Text color
                      //           ),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // Card(elevation: 2,
                      //   child: ExpansionTile(
                      //     title: Text(
                      //       'Sanskrit',
                      //       style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold), // Text color
                      //     ),
                      //     children: <Widget>[
                      //       ListTile(
                      //         title: Text(
                      //           'chapter 1',
                      //           style: TextStyle(color: Colors.green,fontWeight: FontWeight.w500), // Text color
                      //         ),
                      //         leading: CircleAvatar( maxRadius: 12,
                      //           backgroundColor: Colors.orange, // Background color of the CircleAvatar
                      //           child: Text(
                      //             '1',
                      //             style: TextStyle(color: Colors.white), // Text color
                      //           ),
                      //         ),
                      //       ),
                      //       ListTile(
                      //         title: Text(
                      //           'chapter 2',
                      //           style: TextStyle(color: Colors.green,fontWeight: FontWeight.w500), // Text color
                      //         ),
                      //         leading: CircleAvatar( maxRadius: 12,
                      //           backgroundColor: Colors.orange, // Background color of the CircleAvatar
                      //           child: Text(
                      //             '2',
                      //             style: TextStyle(color: Colors.white), // Text color
                      //           ),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // Card(elevation: 2,
                      //   child: ExpansionTile(
                      //     title: Text(
                      //       'Maths',
                      //       style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold), // Text color
                      //     ),
                      //     children: <Widget>[
                      //       ListTile(
                      //         title: Text(
                      //           'chapter 1',
                      //           style: TextStyle(color: Colors.green,fontWeight: FontWeight.w500), // Text color
                      //         ),
                      //         leading: CircleAvatar( maxRadius: 12,
                      //           backgroundColor: Colors.orange, // Background color of the CircleAvatar
                      //           child: Text(
                      //             '1',
                      //             style: TextStyle(color: Colors.white), // Text color
                      //           ),
                      //         ),
                      //       ),
                      //       ListTile(
                      //         title: Text(
                      //           'chapter 2',
                      //           style: TextStyle(color: Colors.green,fontWeight: FontWeight.w500), // Text color
                      //         ),
                      //         leading: CircleAvatar( maxRadius: 12,
                      //           backgroundColor: Colors.orange, // Background color of the CircleAvatar
                      //           child: Text(
                      //             '2',
                      //             style: TextStyle(color: Colors.white), // Text color
                      //           ),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // Card(elevation: 2,
                      //   child: ExpansionTile(
                      //     title: Text(
                      //       'Science',
                      //       style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold), // Text color
                      //     ),
                      //     children: <Widget>[
                      //       ListTile(
                      //         title: Text(
                      //           'chapter 1',
                      //           style: TextStyle(color: Colors.green,fontWeight: FontWeight.w500), // Text color
                      //         ),
                      //         leading: CircleAvatar( maxRadius: 12,
                      //           backgroundColor: Colors.orange, // Background color of the CircleAvatar
                      //           child: Text(
                      //             '1',
                      //             style: TextStyle(color: Colors.white), // Text color
                      //           ),
                      //         ),
                      //       ),
                      //       ListTile(
                      //         title: Text(
                      //           'chapter 2',
                      //           style: TextStyle(color: Colors.green,fontWeight: FontWeight.w500), // Text color
                      //         ),
                      //         leading: CircleAvatar( maxRadius: 12,
                      //           backgroundColor: Colors.orange, // Background color of the CircleAvatar
                      //           child: Text(
                      //             '2',
                      //             style: TextStyle(color: Colors.white), // Text color
                      //           ),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // Card(elevation: 1,
                      //   child: ExpansionTile(
                      //     title: Text(
                      //       'Social Science',
                      //       style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold), // Text color
                      //     ),
                      //     children: <Widget>[
                      //       ListTile(
                      //         title: Text(
                      //           'chapter 1',
                      //           style: TextStyle(color: Colors.green,fontWeight: FontWeight.w500), // Text color
                      //         ),
                      //         leading: CircleAvatar( maxRadius: 12,
                      //           backgroundColor: Colors.orange, // Background color of the CircleAvatar
                      //           child: Text(
                      //             '1',
                      //             style: TextStyle(color: Colors.white), // Text color
                      //           ),
                      //         ),
                      //       ),
                      //       ListTile(
                      //         title: Text(
                      //           '2. chapter 2',
                      //           style: TextStyle(color: Colors.green,fontWeight: FontWeight.w500), // Text color
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // ],
                      ),
                ),
              ],
            ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: Lesson(),
  ));
}
