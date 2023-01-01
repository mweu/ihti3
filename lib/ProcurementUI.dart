
import 'package:bensonone/HomeScreen.dart';
import 'package:bensonone/StaticVariables.dart';
import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as https;

import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const ProcurementUI());
}

class ProcurementUI extends StatelessWidget {



  const ProcurementUI({super.key});

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
                  text: "Purchases",
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
                            child: payrollPeriodsList)])),

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

DataTable payrollPeriodsList =  DataTable(
  columns: const <DataColumn>[
    DataColumn(
      label: Expanded(
        child: Text(
          'Start Date',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      ),
    ),
    DataColumn(
      label: Expanded(
        child: Text(
          'End Date',
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


Future<DataTable>  getPayrollPeriods(BuildContext context) async {
  var client = https.Client();
  try {
    final response = await client.get
      (Uri.parse(
        'https://mansoftonline.com/payroll/ws/service/listprevperiod/145'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Access-Control-Allow-Origin": "*",
          'Accept': '*/*',
          'AuthorizationKey': CollegeManConstatnts.session.payrollSession.toString()
        });
    print("Response Received-->");
    print(response.body);
    /*final body = json.decode(response.body);
    final responseObject = body['response'];
    var list = responseObject['data'];*/

    final list = json.decode(response.body);
    print("Generating Payroll Periods List Bean");
    List<dynamic> payrollPeriods = list
        .map((data) => PayrollPeriodsBean.fromJson(data))
        .toList();
    /* payrollPeriods.insert(0,
        new PayrollPeriodsBean(sdate: "Start Date", edate: "End Date"));*/

    for (var period in payrollPeriods) {
      String startDate = period.sdate.toString();
      print(startDate);
    }
    print("Payroll Periods Date Read was successfull.");
    var i = 0;

    DataTable table = DataTable(columns:
    const<DataColumn>[
      DataColumn(
          label: Expanded(child:
          Text('Period Start'))),
      DataColumn(label: Expanded(child:
      Text('Period End'))),
    ],
      rows: [
        for (var period in payrollPeriods) DataRow(cells: [

          DataCell(
              Text(period.sdate.toString())
          ),
          DataCell(
              Text(period.edate.toString())),
        ], onSelectChanged: (bool? selected) {

          String from = period.sdate.toString();
          String to =  period.edate.toString();
/*yyyyMMdd*/
          final splitterFrom = from.split("-");
          final splittedTo = to.split("-");
          String finalFrom = splitterFrom[1] + "-" + splitterFrom[2] + "-" + splitterFrom[0];
          String finalTo = splittedTo[1] + "-" + splittedTo[2] + "-" + splittedTo[0];

          print(finalFrom +" " + finalTo);

          String url = "https://mansoftonline.com/payroll/ws/report/companypslip/"+ CollegeManConstatnts.session.getPayrollSession() +"/145/c4778e95-eca4-4646-ab2c-3b839dceb045/true/CompanyPayslipReport.jasper/Company%20Payslip/Print/"+ finalFrom +"/"+finalTo +"/Pdf?payrollids=145&multiCurrency=false&";
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


class PayrollPeriodsBean {

  PayrollPeriodsBean({
    this.sdate = '',
    this.edate = '',
  });

  String sdate;
  String edate;

  factory PayrollPeriodsBean.fromJson(Map<String, dynamic> json) => PayrollPeriodsBean(
    sdate: json['sdate'],
    edate: json['edate'],
  );

  Map<String, dynamic> toJson() => {
    'sdate': sdate,
    'edate': edate,
  };



}