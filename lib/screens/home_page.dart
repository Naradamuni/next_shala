import 'package:base_http/base_http.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:next_shala/config/routing_arg.dart';
import 'package:next_shala/modules/authentication/bloc/authentication_bloc.dart';

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

  DataRow buildStudentInfo(int index) {
    return DataRow(cells: [
      DataCell(
        Text((index + 1).toString()),
      ),
      DataCell(
        Text(students[index]['StudentId']),
      ),
      DataCell(
        Text(students[index]['StudentName']),
      ),
      DataCell(
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/dashboard',
                arguments: PageRoutingArguments(
                    studentId: students[index]['StudentId']));
          },
          child: const Text("View"),
        ),
      ),
    ]);
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
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text("Students List"),
            centerTitle: true,
          ),
          body: isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : error != null
                  ? Center(
                      child: Text(error!),
                    )
                  : Column(
                      children: [
                        if (students.isNotEmpty)
                          DataTable(
                            horizontalMargin: 10,
                            columns: const [
                              DataColumn(
                                  label: Text(
                                'Sl.no',
                              )),
                              DataColumn(label: Text('ID')),
                              DataColumn(label: Text('Name')),
                              DataColumn(label: Text(''))
                            ],
                            rows: List.generate(students.length,
                                (index) => buildStudentInfo(index)).toList(),
                          )
                      ],
                    ),
        );
      },
    );
  }
}
