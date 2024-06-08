import 'package:base_http/base_http.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:next_shala/config/routing_arg.dart';
import 'package:next_shala/modules/authentication/bloc/authentication_bloc.dart';

import 'login_screen.dart';

class ProfileApp extends StatefulWidget {
  const ProfileApp({Key? key}) : super(key: key);

  @override
  State<ProfileApp> createState() => _ProfileAppState();
}

class _ProfileAppState extends State<ProfileApp> {
  late String studentId;
  String? sectionID;
  bool isLoading = true;
  var dashboardData;
  String? error;
  bool isFirstLoad = true;
  bool loader = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => getDatas());
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        loader = false;
      });
    });
  }

  List students = [];
  String? studentName;

  getDatas() async {
    PageRoutingArguments args =
        ModalRoute.of(context)!.settings.arguments as PageRoutingArguments;
    studentId = args.studentId;
    studentName = args.fName;
    sectionID = args.sectionId;
    final response = await networkClient.post('/login.svc/getdashboardcount',
        data: {"stud_id": args.studentId});

    if (response.data['dashboard_count_detailsResult']['Status'] == 'Success') {
      setState(() {
        dashboardData =
            response.data['dashboard_count_detailsResult']['CountInfo'][0];
        isLoading = false;
      });
    } else {
      setState(() {
        error = response.data['dashboard_count_detailsResult']['Message'];
        isLoading = false;
      });
    }
  }

  getData(String id) async {
    if (id == '') {
      PageRoutingArguments args =
          ModalRoute.of(context)!.settings.arguments as PageRoutingArguments;
      id = args.studentId;
    }
    final response = await networkClient
        .post('/login.svc/getstudentdt', data: {"std_id": id});
    if (response.data['get_student_detailsResult']['Status'] == 'Success') {
      if (mounted) {
        setState(() {
          students =
              response.data['get_student_detailsResult']['StudentDetails'];
          isFirstLoad = false;
          isLoading = false;
        });
      }
    } else {
      setState(() {
        error = "Unable to get Student details";
        isLoading = false;
        isFirstLoad = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
      if (students.isEmpty && isFirstLoad) {
        getData(state.user.studId);
      }
      return SafeArea(
        child: Scaffold(
          body: Align(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: loader == true
                  ? const CircularProgressIndicator()
                  : Column(
                      children: [
                        Container(
                            color: Colors.transparent,
                            height: 300,
                            child: Stack(
                              children: [
                                Container(
                                  height: 300,
                                  decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                        Colors.deepOrange,
                                        Colors.pinkAccent
                                      ])),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 28.0),
                                  child: SizedBox(
                                    width: double.infinity,
                                    height: 280.0,
                                    child: Center(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const CircleAvatar(
                                            backgroundImage: NetworkImage(
                                              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTGSbLQoAX28XAYOFFl58zWzIg6azsPvglN8Q&usqp=CAU",
                                            ),
                                            radius: 80.0,
                                          ),
                                          const SizedBox(
                                            height: 10.0,
                                          ),
                                          studentName == null
                                              ? Container()
                                              : Text(
                                                  studentName.toString(),
                                                  style: const TextStyle(
                                                    fontSize: 22.0,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                          const SizedBox(
                                            height: 10.0,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 1.25,
                          child: Column(
                            children: [
                              Card(
                                child: ListTile(
                                  leading: Container(
                                      height: 35,
                                      width: 35,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.deepPurpleAccent
                                              .withOpacity(0.9)),
                                      child: const Icon(
                                        Icons.list,
                                        color: Colors.white,
                                      )),
                                  title: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text('Go to Students List',
                                        style: GoogleFonts.montserrat(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16)),
                                  ),
                                  trailing: const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 14,
                                    color: Colors.black,
                                  ),
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                              Card(
                                child: ListTile(
                                  leading: Container(
                                      height: 35,
                                      width: 35,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color:
                                              Colors.orange.withOpacity(0.9)),
                                      child: const Icon(
                                        Icons.sms,
                                        color: Colors.white,
                                        size: 25,
                                      )),
                                  title: Row(
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text('SMS',
                                            style: GoogleFonts.montserrat(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16)),
                                      ),
                                      const Spacer(),
                                      Text(dashboardData['SmsCount'] ?? "0",
                                          style: GoogleFonts.montserrat(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18))
                                    ],
                                  ),
                                  trailing: const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 14,
                                    color: Colors.black,
                                  ),
                                  onTap: () {
                                    Navigator.pushNamed(context, '/messages',
                                        arguments: PageRoutingArguments(
                                            studentId: studentId));
                                  },
                                ),
                              ),
                              Card(
                                child: ListTile(
                                  leading: Container(
                                      height: 35,
                                      width: 35,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.blue.withOpacity(0.9)),
                                      child: const Icon(Icons.person,
                                          color: Colors.white)),
                                  title: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text('View Profile',
                                        style: GoogleFonts.montserrat(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16)),
                                  ),
                                  trailing: const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 14,
                                    color: Colors.black,
                                  ),
                                  onTap: () {
                                    Navigator.pushNamed(context, '/profile',
                                        arguments: PageRoutingArguments(
                                            studentId: studentId));
                                  },
                                ),
                              ),
                              Card(
                                child: ListTile(
                                  leading: Container(
                                      height: 35,
                                      width: 35,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.deepPurple
                                              .withOpacity(0.9)),
                                      child: const Icon(Icons.app_registration,
                                          color: Colors.white)),
                                  title: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text('Attendance',
                                        style: GoogleFonts.montserrat(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16)),
                                  ),
                                  trailing: const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 14,
                                    color: Colors.black,
                                  ),
                                  onTap: () {
                                    Navigator.pushNamed(context, '/attendence',
                                        arguments: PageRoutingArguments(
                                            studentId: studentId));
                                  },
                                ),
                              ),
                              Card(
                                child: ListTile(
                                  leading: Container(
                                      height: 35,
                                      width: 35,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(20),
                                          color: Colors.deepPurple
                                              .withOpacity(0.9)),
                                      child: const Icon(Icons.menu_book,
                                          color: Colors.white)),
                                  title: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text('Lesson Plans',
                                        style: GoogleFonts.montserrat(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16)),
                                  ),
                                  trailing: const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 14,
                                    color: Colors.black,
                                  ),
                                  onTap: () {
                                    Navigator.pushNamed(context, '/lesson',
                                        arguments: PageRoutingArguments(
                                            studentId: studentId));
                                  },
                                ),
                              ),
                              Card(
                                child: ListTile(
                                  leading: Container(
                                      height: 35,
                                      width: 35,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.green.withOpacity(0.9)),
                                      child: const Icon(Icons.article,
                                          color: Colors.white)),
                                  title: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text('Home Work',
                                        style: GoogleFonts.montserrat(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16)),
                                  ),
                                  trailing: const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 14,
                                    color: Colors.black,
                                  ),
                                  onTap: () {
                                    Navigator.pushNamed(context, '/home_work',
                                        arguments: PageRoutingArguments(
                                            studentId: studentId));
                                  },
                                ),
                              ),
                              Card(
                                child: ListTile(
                                  leading: Container(
                                      height: 35,
                                      width: 35,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.purpleAccent
                                              .withOpacity(0.9)),
                                      child: const Icon(Icons.event_note,
                                          color: Colors.white)),
                                  title: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text('View Events',
                                        style: GoogleFonts.montserrat(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16)),
                                  ),
                                  trailing: const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 14,
                                    color: Colors.black,
                                  ),
                                  onTap: () {
                                    Navigator.pushNamed(context, '/events',
                                        arguments: PageRoutingArguments(
                                            studentId: studentId));
                                  },
                                ),
                              ),
                              // Card(
                              //   child: ListTile(
                              //     leading: Container(
                              //         height: 35,
                              //         width: 35,
                              //         decoration: BoxDecoration(
                              //             borderRadius:
                              //                 BorderRadius.circular(20),
                              //             color: Colors.lightGreen
                              //                 .withOpacity(0.9)),
                              //         child: const Icon(
                              //           Icons.schedule,
                              //           color: Colors.white,
                              //         )),
                              //     title: Align(
                              //       alignment: Alignment.centerLeft,
                              //       child: Text('Time table portion',
                              //           style: GoogleFonts.montserrat(
                              //               color: Colors.black,
                              //               fontWeight: FontWeight.w500,
                              //               fontSize: 16)),
                              //     ),
                              //     trailing: const Icon(
                              //       Icons.arrow_forward_ios,
                              //       size: 14,
                              //       color: Colors.black,
                              //     ),
                              //     onTap: () {
                              //       Navigator.pushNamed(context, '/time_table',
                              //           arguments: PageRoutingArguments(
                              //               studentId: studentId));
                              //     },
                              //   ),
                              // ),
                              Card(
                                child: ListTile(
                                  leading: Container(
                                      height: 35,
                                      width: 35,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.pinkAccent
                                              .withOpacity(0.9)),
                                      child: const Icon(
                                        Icons.view_timeline,
                                        color: Colors.white,
                                      )),
                                  title: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text('Time table',
                                        style: GoogleFonts.montserrat(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16)),
                                  ),
                                  trailing: const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 14,
                                    color: Colors.black,
                                  ),
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, '/time_table_week',
                                        arguments: PageRoutingArguments(
                                          studentId: studentId,
                                          sectionId: sectionID,
                                        ));
                                  },
                                ),
                              ),
                              Card(
                                child: ListTile(
                                  leading: Container(
                                      height: 35,
                                      width: 35,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.red),
                                      child: const Icon(Icons.logout,
                                          color: Colors.white)),
                                  title: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text('Logout',
                                        style: GoogleFonts.montserrat(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16)),
                                  ),
                                  trailing: const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 14,
                                    color: Colors.black,
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginScreen()),
                                    );
                                    context
                                        .read<AuthenticationBloc>()
                                        .add(AuthenticationLogoutRequested());
                                  },
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
            ),
          ),
        ),
      );
    });
  }
}
