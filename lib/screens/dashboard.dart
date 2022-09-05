import 'package:authentication_repository/authentication_repository.dart';
import 'package:base_http/base_http.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
            title: const Text('Dashboard'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('View Profile'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/profile',
                  arguments: PageRoutingArguments(studentId: studentId));
            },
          ),
          ListTile(
            title: const Text('Attendenece'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/attendence',
                  arguments: PageRoutingArguments(studentId: studentId));
            },
          ),
          ListTile(
            title: const Text('Home Work'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/home_work',
                  arguments: PageRoutingArguments(studentId: studentId));
            },
          ),
          ListTile(
            title: const Text('View Events'),
            onTap: () {
              Navigator.pop(context);
              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            title: const Text('Logout'),
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
      appBar: AppBar(),
      drawer: drawer(context),
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
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                          padding: const EdgeInsets.only(left: 20),
                          alignment: Alignment.centerLeft,
                          child: const Text("Go to Students list",
                              style: TextStyle(
                                fontSize: 16,
                                decorationStyle: TextDecorationStyle.double,
                                decoration: TextDecoration.underline,
                              ))),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/messages',
                            arguments:
                                PageRoutingArguments(studentId: studentId));
                      },
                      child: Card(
                        color: Colors.blueAccent,
                        child: SizedBox(
                          width: 250,
                          height: 100,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                const Icon(
                                  Icons.mail,
                                  color: Colors.white,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "SMS",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(dashboardData['SmsCount'],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white))
                                  ],
                                )
                              ]),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Card(
                      color: const Color(0xFFFDD835),
                      child: SizedBox(
                          width: 250,
                          height: 100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Icon(
                                Icons.mail,
                                color: Colors.white,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text("Notice",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                  Text("0",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold))
                                ],
                              )
                            ],
                          )),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/events',
                              arguments:
                                  PageRoutingArguments(studentId: studentId));
                        },
                        child: Card(
                          color: const Color(0xFFFF5721),
                          child: SizedBox(
                              width: 250,
                              height: 100,
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    const Icon(
                                      Icons.menu,
                                      color: Colors.white,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text("Events",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold)),
                                        Text(dashboardData['EventCount'],
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold))
                                      ],
                                    )
                                  ])),
                        )),
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
      },
    );
  }
}
