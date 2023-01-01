import 'package:bensonone/HomeScreen.dart';
import 'package:bensonone/StaticVariables.dart';
import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as https;

import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const TranscripsUI());
}

class TranscripsUI extends StatelessWidget {



  const TranscripsUI({super.key});

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
                  text: "Transcripts",
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
                            child: semestersList)])),

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

DataTable semestersList =  DataTable(
  columns: const <DataColumn>[
    DataColumn(
      label: Expanded(
        child: Text(
          'Semester',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      ),
    ),
  ],
  rows: const <DataRow>[
    DataRow(
      cells: <DataCell>[
        DataCell(Text('')),
        DataCell(Text('')),

      ],
    ),


  ],
);


Future<DataTable>  getSchoolSemesters(BuildContext context) async {
  var client = https.Client();
  try {
    final response = await client.get
      (Uri.parse(
        'https://mansoftonline.com/schooladmin/core/college/getSchoolSemestersTree/'+ CollegeManConstatnts.session.tenantId),
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
    print("Generating Payroll Periods List Bean");
    List<dynamic> schoolSemester = list
        .map((data) => SemestersBean.fromJson(data))
        .toList();
    /* payrollPeriods.insert(0,
        new PayrollPeriodsBean(sdate: "Start Date", edate: "End Date"));*/

    for (var semester in schoolSemester) {
      String startDate = semester.name.toString();
      print(startDate);
    }
    print("Semesters Read was Successfull successfull.");
    var i = 0;

    DataTable table = DataTable(columns:
    const<DataColumn>[
      DataColumn(
          label: Expanded(child:
          Text('Semester'))),
    ],
      rows: [
        for (var semester in schoolSemester) DataRow(cells: [

          DataCell(
              Text(semester.name.toString())
          ),
        ], onSelectChanged: (bool? selected) {

          String id = semester.id.toString();
          String name =  semester.name.toString();
/*yyyyMMdd*/


          String url = "https://mansoftonline.com/schooladmin/core/schoolReports/getStudentTranscriptsemesters/"+ CollegeManConstatnts.session.getTenantId() +"/"+ id+"/null";
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


class SemestersBean {

  SemestersBean({
    this.id = '',
    this.name = '',
  });

  String id;
  String name;

  factory SemestersBean.fromJson(Map<String, dynamic> json) => SemestersBean(
    id: json['id'],
    name: json['name'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
  };



}