import 'package:base_http/base_http.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.9),
      appBar: AppBar(
        toolbarHeight: 60,
        automaticallyImplyLeading: true,
        title: Text("Profile",
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
          : error != null
              ? Center(
                  child: Container(
                      padding:
                          const EdgeInsets.only(top: 100, left: 10, right: 10),
                      child: Text(error!)),
                )
              : SingleChildScrollView(
                  child: Container(
                    padding:
                        const EdgeInsets.only(left: 20.0, top: 20, right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TitledInputFragment(
                          title: "Roll no",
                          inputWidget: BaseTextFieldFragment(
                              enabled: false,
                              hintText: myprofile['StudentId'],
                              fillColor:
                                  const Color(0XFF686868).withOpacity(0.3)),
                        ),
                        TitledInputFragment(
                          title: "Student Name",
                          inputWidget: BaseTextFieldFragment(
                              enabled: false,
                              hintText: myprofile['StudName'],
                              fillColor:
                                  const Color(0XFF686868).withOpacity(0.3)),
                        ),
                        TitledInputFragment(
                          title: "Father Name",
                          inputWidget: BaseTextFieldFragment(
                              enabled: false,
                              hintText: myprofile['FatherName'],
                              fillColor:
                                  const Color(0XFF686868).withOpacity(0.3)),
                        ),
                        TitledInputFragment(
                          title: "Mother Name",
                          inputWidget: BaseTextFieldFragment(
                              enabled: false,
                              hintText: myprofile['MotherName'],
                              fillColor:
                                  const Color(0XFF686868).withOpacity(0.3)),
                        ),
                        TitledInputFragment(
                          title: "Phone",
                          inputWidget: BaseTextFieldFragment(
                              enabled: false,
                              hintText: myprofile['FatherMobileNo'],
                              fillColor:
                                  const Color(0XFF686868).withOpacity(0.3)),
                        ),
                        TitledInputFragment(
                          title: "User name",
                          textColor: Colors.black,
                          inputWidget: BaseTextFieldFragment(
                              enabled: false,
                              hintText: myprofile['UserId'],
                              fillColor:
                                  const Color(0XFF686868).withOpacity(0.3)),
                        )
                      ],
                    ),
                  ),
                ),
    );
  }
}
