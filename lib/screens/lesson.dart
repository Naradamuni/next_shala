import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Lesson extends StatefulWidget {
  const Lesson({super.key});

  @override
  _LessonState createState() => _LessonState();
}

class _LessonState extends State<Lesson> {
  String? selectedMonth; // Selected month

  List<MonthData> months = [
    MonthData(name: 'January', initial: 'J', color: Colors.blue),
    MonthData(name: 'February', initial: 'F', color: Colors.red),
    MonthData(name: 'March', initial: 'M', color: Colors.green),
    MonthData(name: 'April', initial: 'A', color: Colors.brown),
    MonthData(name: 'May', initial: 'M', color: Colors.purple),
    MonthData(name: 'June', initial: 'J', color: Colors.teal),
    MonthData(name: 'July', initial: 'J', color: Colors.indigo),
    MonthData(name: 'August', initial: 'A', color: Colors.blueGrey),
    MonthData(name: 'September', initial: 'S', color: Colors.deepPurple),
    MonthData(name: 'October', initial: 'O', color: Colors.deepOrange),
    MonthData(name: 'November', initial: 'N', color: Colors.brown),
    MonthData(name: 'December', initial: 'D', color: Colors.indigo),
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
        padding: const EdgeInsets.only(top: 20.0,left: 20,right: 20),
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
                    style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
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
                              style: TextStyle(color: month.color,fontWeight: FontWeight.bold),
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OtherPage(selectedMonth!)),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedMonth == null ? Colors.cyan[100]: Colors.indigo, // Set the background color
                foregroundColor: selectedMonth == null ? Colors.white :  Colors.blue,
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10), // Set the text color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: selectedMonth == null ? const BorderSide(color: Colors.blue, width: 1): BorderSide(color: Colors.indigo, width: 1),// Button border radius
                ),// Optional: Set the elevation
              ),
              child:  Text(
                'Submit',
                style: TextStyle(color: selectedMonth == null ?Colors.blue : Colors.white,fontWeight: FontWeight.bold,fontSize: 14),
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

  MonthData({required this.name, required this.initial, required this.color});
}

class OtherPage extends StatelessWidget {
  final String selectedMonth;

  OtherPage(this.selectedMonth);


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
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children:  const [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 1,
                    child: ExpansionTile(
                      title: Text(
                        'English',
                        style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold), // Text color
                      ),
                      children: <Widget>[
                        ListTile(
                          visualDensity: VisualDensity(horizontal: 1, vertical: -4), // Compact the ListTile
                          title: Text(
                            '1. Chapter1',
                            style: TextStyle(color: Colors.deepOrange,fontWeight: FontWeight.w500), // Text color
                          ),
                        ),
                        ListTile(
                          visualDensity: VisualDensity(horizontal: 1, vertical: -3), // Compact the ListTile
                          title: Text(
                            '2. Chapter2',
                            style: TextStyle(color: Colors.deepOrange,fontWeight: FontWeight.w500), // Text color
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
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
              ],
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
