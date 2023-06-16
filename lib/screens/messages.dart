import 'package:base_http/base_http.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:next_shala/config/routing_arg.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  bool isLoading = true;
  List messagesData = [];

  // late dynamic messagesData;
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
        .post('/login.svc/getsmsdetails', data: {"stud_id": args.studentId});
    if (response.data['sms_count_detailsResult']['Status'] == 'Success') {
      setState(() {
        isLoading = false;
        messagesData = response.data['sms_count_detailsResult']['MessageInfo'];
      });
    } else {
      setState(() {
        isLoading = false;
        error = response.data['sms_count_detailsResult']['Message'];
      });
    }
  }

  DataRow buildAttendenceInfo(int index) {
    return DataRow(cells: [
      DataCell(
        Text((index + 1).toString()),
      ),
      DataCell(
        Text(messagesData[index]['MessageReason']),
      ),
      DataCell(
        SizedBox(width: 200, child: Text(messagesData[index]['Message'])),
      ),
      DataCell(
        Text(messagesData[index]['MessageDate']),
      ),
      DataCell(
        Text(messagesData[index]['MobileNo']),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        automaticallyImplyLeading: true,
        title: Text("Message",
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
          : messagesData.isEmpty
              ? SingleChildScrollView(
                  child: Center(
                  child: Container(
                    padding:
                        const EdgeInsets.only(top: 100, left: 10, right: 10),
                    child: Text("No Data found",
                        style: GoogleFonts.montserrat(
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                            fontSize: 16)),
                  ),
                ))
              : ListView.builder(
                  itemCount: messagesData.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, right: 8.0, top: 12.0),
                      child: Card(
                          elevation: 4,
                          color: Colors.transparent,
                          child: Center(
                            child: Container(
                              height: 180,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0Xff2DCDDF),
                                    Color(0XffC0EEF2),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: Column(
                                children: [
                                  ListTile(
                                    title: Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child:
                                          Text(messagesData[index]['Message'],
                                              style: GoogleFonts.montserrat(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                              )),
                                    ),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                          "${"Date :"}"
                                          " ${messagesData[index]['MessageDate']}",
                                          style: GoogleFonts.montserrat(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400,
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
                                  ),
                                  Container(
                                    color: Colors.transparent,
                                    width: MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.only(
                                        left:
                                            MediaQuery.of(context).size.width /
                                                5.8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            "${"Reason :"}"
                                            " ${messagesData[index]['MessageReason']}",
                                            style: GoogleFonts.montserrat(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 16)),
                                        Text(
                                            "${"MobileNo :"}"
                                            " ${messagesData[index]['MobileNo']}",
                                            style: GoogleFonts.montserrat(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 16)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )),
                    );
                  }),
    );
  }
}
