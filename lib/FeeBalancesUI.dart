

import 'package:bensonone/HomeScreen.dart';

import 'package:bensonone/StaticVariables.dart';
import 'package:flutter/material.dart';


import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as https;

import 'package:intl/intl.dart';


void main() {
  runApp(const FeeBalancesUI());
}

class FeeBalancesUI extends StatelessWidget {

  const FeeBalancesUI({super.key});

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
                  text: "Fee Balances",),
              ],
            ),
            title: Row(children: [
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
                            child: feeBalancesElementsList)])),

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

DataTable feeBalancesElementsList =  DataTable(
  columns: const <DataColumn>[
    DataColumn(
      label: Expanded(
        child: Text(
          'Account',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      ),
    ),
    DataColumn(
      label: Expanded(
        child: Text(
          'Balance',
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


Future<DataTable>  getFeeBalancesDataList(BuildContext context) async {
  var client = https.Client();
  try {
    final response = await client.get
      (Uri.parse(
        'https://mansoftonline.com/manplanservice/core/collegesync/getFeeBalancesall/'
            + CollegeManConstatnts.session.getTenantId()),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Access-Control-Allow-Origin": "*",
          'Accept': '*/*',
          'session': CollegeManConstatnts.session.getSessionKey()
        });
    print("Response Received-->");
    print(response.body);
    final body = json.decode(response.body);
    final responseObject = body['response'];
    var list = responseObject['data'];




    print("Generating Bank Balance UI");
    List<dynamic> feeBalances = list
        .map((data) => FeeBalancesBean.fromJson(data))
        .toList();
    /* bankBalances.insert(0,
        new BankBalancesBean(currencySymbol: "Currency", manplanAccountNo: "Account No", manplanBalance: "0"));*/

    for (var stud in feeBalances) {
                 /* this.adminNo = 'Adm No',
                  this.name = 'Name',
                  this.balanceBF = 0.0,
                  this.amountDue = 0.0,
                  this.amountPaid = 0.0,
                  this.totalBalance = 0.0*/
      String admNo = stud.adminNo.toString();
      String name = stud.name.toString();
      String balance = stud.totalBalance.toString();
      print(admNo +' ' + name + ' ' + balance);
    }
    print("Generating Fee Balances Successfully");
    var i = 0;

    var formatter = NumberFormat('#,###,000.00');
    DataTable feeBalancesList = DataTable(columns:
    const<DataColumn>[
      DataColumn(label: Expanded(child:
         Text('Name'))),
          DataColumn(label: Expanded(child:
      Text('Balance')))
    ],
      rows: [
        for (var stud in feeBalances) DataRow(cells: [

         DataCell(
            Text(stud.name.toString(),
                textAlign: TextAlign.left),
          ),
          DataCell(
            Text(formatter.format(stud.totalBalance).toString(),
                textAlign: TextAlign.right),
          ),

        ], onSelectChanged: (bool? selected) {


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
    return feeBalancesList;

  } on Exception catch (error) {
    print("An error occured during the process!!--------------------->");
    print(error);

    rethrow;
  }

  finally {
    client.close();
  }

}

class FeeBalancesBean {

  FeeBalancesBean({
    this.adminNo = 'Adm No',
    this.name = 'Name',
    this.balanceBF = 0.0,
    this.amountDue = 0.0,
    this.amountPaid = 0.0,
    this.totalBalance = 0.0
  });

  var adminNo;
  var name;
  var balanceBF;
  var amountDue;
  var amountPaid;
  var totalBalance;

  factory FeeBalancesBean.fromJson(Map<String, dynamic> json) => FeeBalancesBean(
    adminNo: json['adminNo'],
    name: json['name'],
    balanceBF: json['balanceBF'],
    amountPaid: json['amountPaid'],
    totalBalance: json['totalBalance'],
  );

  Map<String, dynamic> toJson() => {
    'adminNo': adminNo,
    'name': name,
    'balanceBF': balanceBF,
    'amountPaid': amountPaid,
    'totalBalance': totalBalance,
  };
}

class SemestersBean {

  SemestersBean({
    this.mansoftltdCode = 'Code',
    this.mansoftltdDescription = 'Name',
    this.mansoftltdIndex ='Index'

  });

  var mansoftltdCode;
  var mansoftltdDescription;
  var mansoftltdIndex;


  factory SemestersBean.fromJson(Map<String, dynamic> json) => SemestersBean(
    mansoftltdCode: json['mansoftltdCode'],
    mansoftltdDescription: json['mansoftltdDescription'],
    mansoftltdIndex: json['mansoftltdIndex'],
  );

  Map<String, dynamic> toJson() => {
    'mansoftltdCode': mansoftltdCode,
    'mansoftltdDescription': mansoftltdDescription,
    'mansoftltdIndex': mansoftltdIndex
  };
}

class BankBalancesBean {

  BankBalancesBean({
    this.manplanAccountNo = '',
    this.manplanBalance = 0.0,
    this.currencySymbol = '',
  });

  var manplanAccountNo;
  var manplanBalance;
  var currencySymbol;

  factory BankBalancesBean.fromJson(Map<String, dynamic> json) => BankBalancesBean(
    manplanAccountNo: json['manplanAccountNo'],
    manplanBalance: json['manplanBalance'],
    currencySymbol: json['currencySymbol'],
  );

  Map<String, dynamic> toJson() => {
    'manplanAccountNo': manplanAccountNo,
    'manplanBalance': manplanBalance,
    'currencySymbol': currencySymbol,
  };
}

class StudentsBean {

  StudentsBean({
    this.pfNo = '',
    this.displayName = '',
    this.className = '',
  });

  String pfNo;
  String displayName;
  String className;

  factory StudentsBean.fromJson(Map<String, dynamic> json) => StudentsBean(
    pfNo: json['pfNo'],
    displayName: json['displayName'],
    className: json['className'],
  );

  Map<String, dynamic> toJson() => {
    'pfNo': pfNo,
    'displayName': displayName,
    'className': className,
  };
}