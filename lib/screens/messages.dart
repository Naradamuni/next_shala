import 'package:base_http/base_http.dart';
import 'package:flutter/material.dart';
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
  late dynamic messagesData;
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
        centerTitle: true,
        title: const Text('Message'),
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
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: (messagesData == null)
                          ? const Text("No data found")
                          : Column(
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                DataTable(
                                  columnSpacing: 30,
                                  columns: const [
                                    DataColumn(label: Text("Sl")),
                                    DataColumn(label: Text("Reason")),
                                    DataColumn(label: Text("Message")),
                                    DataColumn(label: Text("Date")),
                                    DataColumn(label: Text("Father Phone")),
                                  ],
                                  rows: List.generate(messagesData.length,
                                          (index) => buildAttendenceInfo(index))
                                      .toList(),
                                ),
                              ],
                            ),
                    ),
                  )),
    );
  }
}
