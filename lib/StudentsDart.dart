import 'package:bensonone/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as https;


void main() {
  runApp(const StudentsUi());
}

class StudentsUi extends StatelessWidget {



  const StudentsUi({super.key});

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
                  text: "Students",
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
                            child: studentsDataList)])),

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

DataTable studentsDataList =  DataTable(
  columns: const <DataColumn>[
    DataColumn(
      label: Expanded(
        child: Text(
          'Pf No',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      ),
    ),
    DataColumn(
      label: Expanded(
        child: Text(
          'Name',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      ),
    ),
    DataColumn(
      label: Expanded(
        child: Text(
          'Class',
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
        DataCell(Text('')),
      ],
    ),


  ],
);


Future<DataTable>  getStudentsList(BuildContext context) async {
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
    studentsList.insert(0,
        new StudentsBean(className: "CLASS", displayName: "NAME", pfNo: "ADM. NO"));

    for (var student in studentsList) {
      String studName = student.displayName.toString();
      print(studName);
    }
    print("Student Data was generated Successfully");
    var i = 0;

    DataTable table = DataTable(columns:
        const<DataColumn>[
          DataColumn(
              label: Expanded(child:
                  Text('Adm No'))),
          DataColumn(label: Expanded(child:
            Text('Name'))),
          DataColumn(label: Expanded(child:
            Text('Class')))
        ],
      rows: [
        for (var stud in studentsList) DataRow(cells: [

          DataCell(
              Text(stud.pfNo.toString())
          ),
          DataCell(
             Text(stud.displayName.toString())),
          DataCell(
              Text(stud.className.toString())),
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