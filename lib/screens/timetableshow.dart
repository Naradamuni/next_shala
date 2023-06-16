import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WeekdaysScreen extends StatelessWidget {
  final List<String> weekdays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ];

  WeekdaysScreen({super.key});

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
      body: ListView.builder(
        itemCount: weekdays.length,
        itemBuilder: (BuildContext context, int index) {
          return WeekdayTile(
            weekday: weekdays[index],
            color: getColor(index),
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

  const WeekdayTile({
    super.key,
    required this.weekday,
    required this.color,
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
                    : Padding(
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
                                const Padding(padding: EdgeInsets.only(top: 3)),
                                Text("Period1",
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
                                const Padding(padding: EdgeInsets.only(top: 3)),
                                Text("9:15-10:00 am",
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
                                const Padding(padding: EdgeInsets.only(top: 3)),
                                Text("English",
                                    style: GoogleFonts.montserrat(
                                        color: Colors.black,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 15)),
                              ],
                            )
                          ],
                        ),
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
