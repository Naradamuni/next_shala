import 'package:base_http/base_http.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:next_shala/config/routing_arg.dart';
import 'package:next_shala/modules/authentication/bloc/authentication_bloc.dart';
import 'dart:math' as math;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List students = [];
  bool isFirstLoad = true;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
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
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
      if (students.isEmpty && isFirstLoad) {
        getData(state.user.studId);
      }
      return SafeArea(
          child: Scaffold(
        backgroundColor: Colors.white.withOpacity(0.9),
        appBar: AppBar(
          toolbarHeight: 60,
          automaticallyImplyLeading: false,
          title: Text("Students List",
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
            : ListView.builder(
                itemCount: students.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding:
                        const EdgeInsets.only(left: 8.0, right: 8.0, top: 12.0),
                    child: Card(
                        elevation: 4,
                        color: Colors.transparent,
                        child: Center(
                          child: Container(
                            height: 80,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0XffFF9966),
                                  Color(0XffFF5E62),
                                  // Colors.yellow.shade300,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: ListTile(
                              title: Text(students[index]['StudentName'],
                                  style: GoogleFonts.montserrat(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  )),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                    "${"Id :"}"
                                    " ${students[index]['StudentId']}",
                                    style: GoogleFonts.montserrat(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16)),
                              ),
                              leading: Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white,
                                ),
                                child: Center(
                                  child: Text((index + 1).toString(),
                                      style: GoogleFonts.montserrat(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12)),
                                ),
                              ),
                              trailing: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.transparent),
                                    shadowColor: MaterialStateProperty.all(
                                        Colors.transparent),
                                  ),
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/ProfileApp',
                                        arguments: PageRoutingArguments(
                                            studentId: students[index]
                                                ['StudentId'],
                                            fName: students[index]
                                                ['StudentName']));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      top: 5,
                                      bottom: 5,
                                    ),
                                    child: Text('VIEW',
                                        style: GoogleFonts.montserrat(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )),
                  );
                }),
      ));
    });
  }
}
