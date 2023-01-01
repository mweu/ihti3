

import 'package:bensonone/HomeScreen.dart';
import 'package:bensonone/StaticVariables.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as https;

import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const LeaveClassesUi());
}

class LeaveClassesUi extends StatelessWidget {



  const LeaveClassesUi({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [

                Tab(icon: Icon(Icons.supervised_user_circle),
                  text: "Leave Classes",
                ),
              ],
            ),
            title:  Row(children: [
              new GestureDetector(
                onTap: () {
                  goBackScreen(context);
                },
                child: Column(
                    children: <Widget>[
                      Image.asset('icons/gobackimage.png',
                        width: 60,
                        height: 60,
                      ),
                    ]),
              ),Text("COLLEGEMAN")
            ],),
          ),
          body: TabBarView(
            children: [
              Scrollbar(
                  child: ListView(
                      children: <Widget>[
                        SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: leaveClassesList)])),

            ],
          ),
        ),
      ),
    );
  }

  void goBackScreen(BuildContext context) async {
    Navigator.push(
      context,
      /* MaterialPageRoute(builder: (context) => const MainScreenUi()),*/
      MaterialPageRoute(builder: (context) => const MainscreenUiHome()),
    );

  }
}

DataTable leaveClassesList =  DataTable(
  columns: const <DataColumn>[
    DataColumn(
      label: Expanded(
        child: Text(
          'Leave',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      ),
    ),
  ],
  rows: const <DataRow>[
    DataRow(
      cells: <DataCell>[
        DataCell(Text('')),

      ],
    ),


  ],
);


Future<DataTable>  getLeaveClassesList(BuildContext context) async {
  var client = https.Client();
  try {
    final response = await client.get
      (Uri.parse(
        'https://mansoftonline.com/adminrs/core/cust/leavechat'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Access-Control-Allow-Origin": "*",
          'Accept': '*/*',
          'AuthorizationKey': CollegeManConstatnts.session.sessionKey.toString()
        });
    print("Response Received-->");
    print(response.body);
    /*final body = json.decode(response.body);
    final responseObject = body['response'];
    var list = responseObject['data'];*/

    final list = json.decode(response.body);
    print("Generating Leave Classes Periods List Bean");
    List<dynamic> leaveClasses = list
        .map((data) => LeaveClassesBean.fromJson(data))
        .toList();
    /* payrollPeriods.insert(0,
        new PayrollPeriodsBean(sdate: "Start Date", edate: "End Date"));*/

    for (var leave in leaveClasses) {
      String name = leave.name.toString();
      print(name);
    }
    print("Leave Periods Date Read was successfull.");
    var i = 0;

    DataTable table = DataTable(columns:
    const<DataColumn>[
      DataColumn(
          label: Expanded(child:
          Text('Leave Type'))),
    ],
      rows: [
        for (var leave in leaveClasses) DataRow(cells: [

          DataCell(
              Text(leave.name.toString())
          ),
        ], onSelectChanged: (bool? selected) {

          String name = leave.name.toString();
          String id =  leave.id.toString();

          print(name +" " + id);
          String url = "https://mansoftonline.com/adminrs/core/leave/leavereport/"+
                CollegeManConstatnts.session.sessionKey +"/"+ id + "/c4778e95-eca4-4646-ab2c-3b839dceb045/Pdf/null?groupBy=NONE&selection=null";
                _launchURL(url);
        },),
      ],/*rows: myList.map((e) => DataRow(cells:
          [
            DataCell(
              Text(e['pfNo'])
            ),
            DataCell(
                Text(e['displayName'])
            ),
            DataCell(
                Text(e['className'])
            )
          ])).toList()*/
    );


    print("Table was generated Successfully");
    return table;

  } on Exception catch (error) {
    print("An error occured during the process!!--------------------->");
    print(error);

    rethrow;
  }

  finally {
    client.close();
  }

}

_launchURL(String url) async {

  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}


class LeaveClassesBean {

  LeaveClassesBean({
    this.name = '',
    this.id = '',
  });

  String name;
  String id;

  factory LeaveClassesBean.fromJson(Map<String, dynamic> json) => LeaveClassesBean(
    name: json['name'],
    id: json['id'],
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'id': id,
  };



}