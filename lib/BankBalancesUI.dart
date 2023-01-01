
import 'package:bensonone/HomeScreen.dart';
import 'package:bensonone/StaticVariables.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as https;

import 'package:intl/intl.dart';

void main() {
  runApp(const BanksBalancesUi());
}

class BanksBalancesUi extends StatelessWidget {

  const BanksBalancesUi({super.key});

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
                  text: "Account Balances",),
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
                            child: bankBalancesList)])),

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

DataTable bankBalancesList =  DataTable(
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


Future<DataTable>  getBankBalancesList(BuildContext context) async {
  var client = https.Client();
  try {
    final response = await client.get
      (Uri.parse(
        'https://mansoftonline.com/manplanservice/core/manplan/getCashBookAccounts'),
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




    var formatter = NumberFormat('#,###,000.00');
    print("Generating Bank Balance UI");
    List<dynamic> bankBalances = list
        .map((data) => BankBalancesBean.fromJson(data))
        .toList();
   /* bankBalances.insert(0,
        new BankBalancesBean(currencySymbol: "Currency", manplanAccountNo: "Account No", manplanBalance: "0"));*/

    for (var bank in bankBalances) {
      String accountNo = bank.manplanAccountNo.toString();
      print(accountNo);
    }
    print("Generating Bank Balances Successfully");
    var i = 0;

    DataTable table = DataTable(columns:
    const<DataColumn>[
      DataColumn(
          label: Expanded(child:
          Text('Account No'))),
      DataColumn(label: Expanded(child:
      Text('Balance'))),
    ],
      rows: [
        for (var bank in bankBalances) DataRow(cells: [

          DataCell(
              Text(bank.manplanAccountNo.toString())
          ),
          DataCell(
              Text(formatter.format(bank.manplanBalance).toString(),
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

class FeeBalancesBean {

  FeeBalancesBean({
    this.balanceBf = 0.0,
    this.billing = 0.0,
    this.paid = 0.0,
    this.semester = 'Semester',
    this.currency = 'Currency',
  });

  var balanceBf;
  var billing;
  var paid;
  var semester;
  var currency;

  factory FeeBalancesBean.fromJson(Map<String, dynamic> json) => FeeBalancesBean(
    balanceBf: json['balanceBf'],
    billing: json['billing'],
    paid: json['paid'],
    semester: json['semester'],
    currency: json['currency'],
  );

  Map<String, dynamic> toJson() => {
    'balanceBf': balanceBf,
    'billing': billing,
    'paid': paid,
    'semester': semester,
    'currency': currency,
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