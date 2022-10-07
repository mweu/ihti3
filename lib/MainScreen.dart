import 'package:bensonone/FeePayments.dart';
import 'package:bensonone/LoginResponse.dart';
import 'package:bensonone/MainScreen.dart';
import 'package:bensonone/StaticVariables.dart';
import 'package:flutter/material.dart';
import 'package:json_table/json_table.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as https;

import 'package:intl/intl.dart';

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

Table studentsData = Table();

Table bankBalances = Table();

Table feeBalances = Table();
void main() {
  runApp(const MainScreenUi());
}

class MainScreenUi extends StatelessWidget {

  const MainScreenUi({super.key});
  @override
  Widget build(BuildContext context) {

 /* getStudentsData(context);*/
  return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.supervised_user_circle),
                  text: "Students",),
                Tab(icon: Icon(Icons.money),
                text: "Bank Balances",),
                Tab(icon: Icon(Icons.money_off_outlined),
                text: "Fee Balances",),
                Tab(icon: Icon(Icons.transcribe_rounded),
                text: "Transcripts",),
              ],
            ),
            title: const Text('COLLEGEMAN'),
          ),
          body: TabBarView(
            children: [
              Scrollbar(
              child: ListView(
              children: <Widget>[
              SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: studentsData)])),

              Scrollbar(
                  child: ListView(
                      children: <Widget>[
                        SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: bankBalances)])),
              Scrollbar(
                  child: ListView(
                      children: <Widget>[
                        SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: feeBalances)])),
              Icon(Icons.transcribe_rounded),
            ],
          ),
        ),
      ),
    );
  }


}

void getStudentsData(BuildContext context) async {
  studentsData =  await generateProductList(context);


}

void getBankDetailsData(BuildContext context) async {
  bankBalances =  await generateBankBalances(context);

}

Future<Table>  generateFeeBalances(BuildContext context) async {
  var client = https.Client();
  try {
    final response = await client.get
      (Uri.parse(
        'https://mansoftonline.com/manplanservice/core/collegesync/getFeePaymentSummaryios/c4778e95-eca4-4646-ab2c-3b839dceb045'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Access-Control-Allow-Origin": "*",
          'Accept': '*/*'
        });
    print("Response Received-->");
    print(response.body);
    final body = json.decode(response.body);
    final responseObject = body['response'];
    var list = responseObject['data'];



    print("Generating Fee Balalances");
    List<dynamic> feeBalances = list
        .map((data) => FeeBalancesBean.fromJson(data))
        .toList();
    feeBalances.insert(0, new FeeBalancesBean(balanceBf: 0.0, billing: 0.0, currency: "Currency", paid: 0.0, semester: "Semester"));

    for (var balance in feeBalances) {
      var balanceBf = balance.balanceBf.toString();
      print(balanceBf);
    }
    print("Bank Balances were generated Successfully");
    NumberFormat myFormat = NumberFormat.decimalPattern('en_us');
    var i = 0;
    Table table =   Table(
        border: TableBorder.symmetric(
            inside: BorderSide(width: 1, color: Colors.blue),
            outside: BorderSide(width: 1)),
        defaultColumnWidth: FixedColumnWidth(150),
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,

        children: [

          for (var balance in feeBalances) TableRow(children: [
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  new Text(balance.semester.toString(),
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, height: 3)),
                  new Text(balance.currency +" " + myFormat.format(balance.balanceBf) ,
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, height: 3)),
                  new Text(balance.currency +" " + myFormat.format(balance.billing) ,
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, height: 3)),
                  new Text(balance.currency +" " + myFormat.format(balance.paid) ,
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, height: 3)),
                  new Text(balance.currency +" " + myFormat.format( (balance.balanceBf + balance.billing) -balance.paid) ,
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, height: 3)),



                ],
              ),
            )
          ],
              decoration: BoxDecoration(color: Colors.grey[200]))


        ]
    );
    print("Table was generated Successfully");
    return table;

  } on Exception catch (error) {
    print("An error occured during the process!!");
    print(error);

    rethrow;
  }

  finally {
    client.close();
  }
}

Future<Table>  generateBankBalances(BuildContext context) async {
  var client = https.Client();
  try {
    final response = await client.get
      (Uri.parse(
        'https://mansoftonline.com/manplanservice/core/manplan/getCashBookAccountsCore/c4778e95-eca4-4646-ab2c-3b839dceb045'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Access-Control-Allow-Origin": "*",
          'Accept': '*/*'
        });
    print("Response Received-->");
    print(response.body);
    final body = json.decode(response.body);
    final responseObject = body['response'];
    var list = responseObject['data'];



    print("Generating Bank Balances");
    List<dynamic> bankBalances = list
        .map((data) => BankBalancesBean.fromJson(data))
        .toList();
    bankBalances.insert(0, new BankBalancesBean(manplanAccountNo: "Account No", manplanBalance: 0.0, currencySymbol: "Currency"));

    for (var bank in bankBalances) {
      String accountNo = bank.manplanAccountNo.toString();
      print(accountNo);
    }
    print("Bank Balances were generated Successfully");
    NumberFormat myFormat = NumberFormat.decimalPattern('en_us');
    var i = 0;
    Table table =   Table(
        border: TableBorder.symmetric(
            inside: BorderSide(width: 1, color: Colors.blue),
            outside: BorderSide(width: 1)),
        defaultColumnWidth: FixedColumnWidth(150),
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,

        children: [

          for (var bank in bankBalances) TableRow(children: [
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  new Text(bank.manplanAccountNo.toString(),
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, height: 3)),
                  new Text(bank.currencySymbol +" " + myFormat.format(bank.manplanBalance) ,  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, height: 3)),

                ],
              ),
            )
          ],
              decoration: BoxDecoration(color: Colors.grey[200]))


        ]
    );
    print("Table was generated Successfully");
    return table;

  } on Exception catch (error) {
    print("An error occured during the process!!");
    print(error);

    rethrow;
  }

  finally {
    client.close();
  }
}

Future<Table>  generateProductList(BuildContext context) async {
  var client = https.Client();
  try {
    final response = await client.get
      (Uri.parse(
        'https://mansoftonline.com/schooladmin/core/school/listschoolusers/c4778e95-eca4-4646-ab2c-3b839dceb045'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Access-Control-Allow-Origin": "*",
          'Accept': '*/*'
        });
        print("Response Received-->");
        print(response.body);
      final body = json.decode(response.body);
                            final responseObject = body['response'];
                            var list = responseObject['data'];



                            print("Generating Students List Bean");
               List<dynamic> studentsList = list
                        .map((data) => StudentsBean.fromJson(data))
                        .toList();
                       studentsList.insert(0, new StudentsBean(className: "Class Name", displayName: "Name", pfNo: "Staff Number"));

            for (var student in studentsList) {
              String studName = student.displayName.toString();
             print(studName);
          }
        print("Student Data was generated Successfully");
            var i = 0;
                       Table table =   Table(
                           border: TableBorder.symmetric(
                               inside: BorderSide(width: 1, color: Colors.blue),
                               outside: BorderSide(width: 1)),
                           defaultColumnWidth: FixedColumnWidth(150),
                           defaultVerticalAlignment: TableCellVerticalAlignment.middle,

                            children: [

                              for (var student in studentsList) TableRow(children: [
                                TableCell(
                                  verticalAlignment: TableCellVerticalAlignment.middle,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      new Text(student.pfNo.toString(),
                                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, height: 3)),
                                      new Text(student.displayName.toString(),  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, height: 3)),
                                      new Text(student.className.toString(),  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, height: 3)),
                                    ],
                                  ),
                                )
                              ],
                              decoration: BoxDecoration(color: Colors.grey[200]))


                            ]
                        );
      print("Table was generated Successfully");
      return table;

  } on Exception catch (error) {
    print("An error occured during the process!!");
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