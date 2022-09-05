import 'package:base_http/base_http.dart';
import 'package:flutter/material.dart';
import 'package:next_shala/components/base_text_filed.dart';
import 'package:next_shala/components/titled_input_field.dart';
import 'package:next_shala/config/routing_arg.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isLoading = true;
  late dynamic myprofile;
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
        .post('/login.svc/getprofile', data: {"stud_id": args.studentId});
    if (response.data['profile_detailsResult']['Status'] == 'Success') {
      setState(() {
        isLoading = false;
        myprofile = response.data['profile_detailsResult']['ProfileDetails'][0];
      });
    } else {
      setState(() {
        isLoading = false;
        error = response.data['profile_detailsResult']['Message'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // return
    // BlocBuilder<AuthenticationBloc, AuthenticationState>(
    //   builder: (context, state) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text("Profile"),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : error != null
              ? Center(
                  child: Container(
                      padding:
                          const EdgeInsets.only(top: 100, left: 10, right: 10),
                      child: Text(error!)),
                )
              : SingleChildScrollView(
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Column(
                      children: [
                        TitledInputFragment(
                          title: "Roll no",
                          inputWidget: BaseTextFieldFragment(
                            enabled: false,
                            hintText: myprofile['StudentId'],
                          ),
                        ),
                        TitledInputFragment(
                          title: "Student Name",
                          inputWidget: BaseTextFieldFragment(
                            enabled: false,
                            hintText: myprofile['StudName'],
                          ),
                        ),
                        TitledInputFragment(
                          title: "Father Name",
                          inputWidget: BaseTextFieldFragment(
                            enabled: false,
                            hintText: myprofile['FatherName'],
                          ),
                        ),
                        TitledInputFragment(
                          title: "Mother Name",
                          inputWidget: BaseTextFieldFragment(
                            enabled: false,
                            hintText: myprofile['MotherName'],
                          ),
                        ),
                        TitledInputFragment(
                          title: "Phone",
                          inputWidget: BaseTextFieldFragment(
                            enabled: false,
                            hintText: myprofile['FatherMobileNo'],
                          ),
                        ),
                        TitledInputFragment(
                          title: "User name",
                          inputWidget: BaseTextFieldFragment(
                            enabled: false,
                            hintText: myprofile['UserId'],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
    );
    //   },
    // );
  }
}
