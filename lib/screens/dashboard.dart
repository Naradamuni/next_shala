import 'package:authentication_repository/authentication_repository.dart';
import 'package:base_http/base_http.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:next_shala/config/routing_arg.dart';
import 'package:next_shala/modules/authentication/bloc/authentication_bloc.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late String studentId;
  bool isLoading = true;
  var dashboardData;
  String? error;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => getData());
  }

  getData() async {
    PageRoutingArguments args =
        ModalRoute.of(context)!.settings.arguments as PageRoutingArguments;

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

  Drawer drawer(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          const SizedBox(
            height: 40,
          ),
          ListTile(
            leading: Container(
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.orange.withOpacity(0.9)),
                child: const Icon(
                  Icons.dashboard,
                  color: Colors.white,
                )),
            title: Text('Dashboard',
                style: GoogleFonts.montserrat(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 16)),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: Colors.black,
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          const Divider(
            color: Colors.black,
          ),
          ListTile(
            leading: Container(
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.blue.withOpacity(0.9)),
                child: const Icon(Icons.person, color: Colors.white)),
            title: Text('View Profile',
                style: GoogleFonts.montserrat(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 16)),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: Colors.black,
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/profile',
                  arguments: PageRoutingArguments(studentId: studentId));
            },
          ),
          const Divider(
            color: Colors.black,
          ),
          ListTile(
            leading: Container(
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.deepPurple.withOpacity(0.9)),
                child: const Icon(Icons.app_registration, color: Colors.white)),
            title: Text('Attendnece',
                style: GoogleFonts.montserrat(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 16)),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: Colors.black,
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/attendence',
                  arguments: PageRoutingArguments(studentId: studentId));
            },
          ),
          const Divider(
            color: Colors.black,
          ),
          ListTile(
            leading: Container(
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.green.withOpacity(0.9)),
                child: const Icon(Icons.article, color: Colors.white)),
            title: Text('Home Work',
                style: GoogleFonts.montserrat(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 16)),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: Colors.black,
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/home_work',
                  arguments: PageRoutingArguments(studentId: studentId));
            },
          ),
          const Divider(
            color: Colors.black,
          ),
          ListTile(
            leading: Container(
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.purpleAccent.withOpacity(0.9)),
                child: const Icon(Icons.event_note, color: Colors.white)),
            title: Text('View Events',
                style: GoogleFonts.montserrat(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 16)),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: Colors.black,
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/events',
                  arguments: PageRoutingArguments(studentId: studentId));
            },
          ),
          const Divider(
            color: Colors.black,
          ),
          ListTile(
            leading: Container(
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.tealAccent.withOpacity(0.9)),
                child: const Icon(
                  Icons.schedule,
                  color: Colors.white,
                )),
            title: Text('Time table',
                style: GoogleFonts.montserrat(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 16)),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: Colors.black,
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/time_table',
                  arguments: PageRoutingArguments(studentId: studentId));
            },
          ),
          const Divider(
            color: Colors.black,
          ),
          ListTile(
            leading: Container(
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20), color: Colors.red),
                child: const Icon(Icons.logout, color: Colors.white)),
            title: Text('Logout',
                style: GoogleFonts.montserrat(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 16)),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: Colors.black,
            ),
            onTap: () {
              Navigator.pop(context);
              context
                  .read<AuthenticationBloc>()
                  .add(AuthenticationLogoutRequested());
            },
          ),
        ],
      ),
    );
  }

  Widget view(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.9),
      appBar: AppBar(
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
      ),
      body: Align(
          alignment: Alignment.center,
          child: (isLoading)
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.only(left: 10),
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
                                    Color(0Xff3C4CAD),
                                    Color(0Xff4ADEDE),
                                  ]),
                            ),
                            alignment: Alignment.center,
                            child: Text("Go to Students List",
                                style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 28,
                                ))),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/messages',
                              arguments:
                                  PageRoutingArguments(studentId: studentId));
                        },
                        child: Container(
                          height: 160,
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.blue.withOpacity(0.5),
                                  offset: const Offset(0, 15),
                                  blurRadius: 3,
                                  spreadRadius: -10)
                            ],
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15)),
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              stops: [0.0, 1.0],
                              colors: [
                                Color(0Xff00AEEF),
                                Color(0Xff2377B8),
                              ],
                            ),
                          ),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                    height: 55,
                                    width: 55,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(40),
                                        color: Colors.lightBlue[900]),
                                    child: const Icon(
                                      Icons.sms,
                                      color: Colors.white,
                                      size: 25,
                                    )),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("SMS",
                                        style: GoogleFonts.montserrat(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 25)),
                                    Text(dashboardData['SmsCount'],
                                        style: GoogleFonts.montserrat(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18))
                                  ],
                                )
                              ]),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20),
                      child: Container(
                        height: 160,
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: Colors.blue.withOpacity(0.5),
                                offset: const Offset(0, 15),
                                blurRadius: 3,
                                spreadRadius: -10)
                          ],
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15)),
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            stops: [0.0, 1.0],
                            colors: [
                              Color(0xFFFFE080),
                              Color(0xFFCB5F00),
                            ],
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                                height: 55,
                                width: 55,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(40),
                                    color: Colors.yellow[900]),
                                child: const Icon(
                                  Icons.mail,
                                  color: Colors.white,
                                  size: 25,
                                )),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Notice",
                                    style: GoogleFonts.montserrat(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 25)),
                                Text("0",
                                    style: GoogleFonts.montserrat(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18))
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/events',
                            arguments:
                                PageRoutingArguments(studentId: studentId));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20),
                        child: Container(
                          height: 160,
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.blue.withOpacity(0.5),
                                  offset: const Offset(0, 15),
                                  blurRadius: 3,
                                  spreadRadius: -10)
                            ],
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15)),
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              stops: [0.0, 1.0],
                              colors: [Color(0xff00b09b), Color(0xff96c93d)],
                            ),
                          ),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                    height: 55,
                                    width: 55,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(40),
                                        color: Colors.green[900]),
                                    child: const Icon(
                                      Icons.sms,
                                      color: Colors.white,
                                      size: 25,
                                    )),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Events",
                                        style: GoogleFonts.montserrat(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 25)),
                                    Text(dashboardData['EventCount'],
                                        style: GoogleFonts.montserrat(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18))
                                  ],
                                )
                              ]),
                        ),
                      ),
                    ),
                  ],
                )),
    );
  }

  @override
  Widget build(BuildContext context) {
    PageRoutingArguments args =
        ModalRoute.of(context)!.settings.arguments as PageRoutingArguments;
    studentId = args.studentId;
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
      if (state.status != AuthenticationStatus.authenticated) {
        WidgetsBinding.instance.addPostFrameCallback(
            (_) => Navigator.pushReplacementNamed(context, '/app'));
      }
      return view(context);
    });
  }
}
