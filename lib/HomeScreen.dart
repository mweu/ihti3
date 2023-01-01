import 'package:bensonone/AttendanceUI.dart';
import 'package:bensonone/BankBalancesUI.dart';
import 'package:bensonone/FeeBalancesUI.dart';
import 'package:bensonone/LeaveClassesUi.dart';
import 'package:bensonone/PayrollPeriodsUI.dart';
import 'package:bensonone/StaticVariables.dart';
import 'package:bensonone/StudentsDart.dart';
import 'package:bensonone/TranscriptsUI.dart';
import 'package:bensonone/generated/PurchasesUI.dart';
import 'package:bensonone/generated/SalesProspectsUI.dart';
import 'package:flutter/material.dart';
void main() {
  runApp(const MainscreenUiHome());
}

class MainscreenUiHome extends StatelessWidget {


  const MainscreenUiHome({super.key});



  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'COLLEGEAN',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home:  Scaffold(
        appBar: AppBar(title: const Text("COLLEGE MAN")),
        body: const MyStatefulWidget(),
      ),
    );
  }


}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var displayName = "Welcome " + CollegeManConstatnts.session.getDisplanyName();
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(1),
        child: ListView(
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child:  Text(
                  displayName,
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                      fontSize: 23,
                      decoration: TextDecoration.none,

                  ),
                )),

            Row(children: [
              SizedBox(height: 100),
            ],),
            Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: <Widget>[
                      new GestureDetector(
                        onTap: () {
                          goToStudentsScreen(context);
                        },
                        child: Column(
                            children: <Widget>[
                              Image.asset('icons/student.png',
                                width: 60,
                                height: 60,
                              ),

                              Text('Students',
                                style:
                                TextStyle(fontSize: 15,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.none),
                              )]),
                      ),

                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      new GestureDetector(
                        onTap: () {
                          goToFeeBalancesScreen(context);
                        },
                        child: Column(
                            children: <Widget>[
                              Image.asset('icons/fees.png',
                                width: 60,
                                height: 60,

                              ), Text('Fee Balances',
                                style:
                                TextStyle(fontSize: 15,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.none),
                              )]),
                      ),

                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      new GestureDetector(
                        onTap: () {
                          goToPayrollPeriodScreen(context);

                        },
                        child: Column(
                            children: <Widget>[
                              Image.asset('icons/payroll.png',
                                width: 50,
                                height: 50,

                              ), Text('Payroll',
                                style:
                                TextStyle(fontSize: 15,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.none),
                              )]),
                      ),

                    ],
                  ),
                )
              ],
              mainAxisAlignment: MainAxisAlignment.center,

            ), SizedBox(height: 10,),
            /* SECOND  ROW  BEGIN*/

            Row(children: [
              SizedBox(height: 70),
            ],),
            Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: <Widget>[
                      new GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            /* MaterialPageRoute(builder: (context) => const MainScreenUi()),*/
                            MaterialPageRoute(builder: (context) => const PurchasesUI()),
                          );
                        },
                        child: Column(
                            children: <Widget>[
                              Image.asset('icons/procurement.png',
                                width: 60,
                                height: 60,

                              ), Text('Procurement',
                                style:
                                TextStyle(fontSize: 15,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.none),
                              )]),
                      ),

                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      new GestureDetector(
                        onTap: () {
                          goToBankBalancesScreen(context);
                        },
                        child: Column(
                            children: <Widget>[
                              Image.asset('icons/banks.png',
                                width: 60,
                                height: 60,

                              ), Text('Banks',
                                style:
                                TextStyle(fontSize: 15,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.none),
                              )]),
                      ),

                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      new GestureDetector(
                        onTap: () {
                          goToLeaveClassesScreen(context);

                        },
                        child: Column(
                            children: <Widget>[
                              Image.asset('icons/leave.png',
                                width: 60,
                                height: 60,

                              ), Text('Leave',
                                style:
                                TextStyle(fontSize: 15,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.none),
                              )]),
                      ),

                    ],
                  ),
                )
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
            /*END OF SECOND ROW*/

            /* THIRD  ROW  BEGIN*/
            Row(children: [
              SizedBox(height: 70),
            ],),


            Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: <Widget>[
                      new GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            /* MaterialPageRoute(builder: (context) => const MainScreenUi()),*/
                            MaterialPageRoute(builder: (context) => const AttendanceUI()),
                          );
                        },
                        child: Column(
                            children: <Widget>[
                              Image.asset('icons/attendance.png',
                                width: 50,
                                height: 50,

                              ), Text('Attendance',
                                style:
                                TextStyle(fontSize: 15,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.none),
                              )]),
                      ),

                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      new GestureDetector(
                        onTap: () {
                          goToSchoolSemesters(context);
                        },
                        child: Column(
                            children: <Widget>[
                              Image.asset('icons/transcripts.png',
                                width: 60,
                                height: 60,

                              ), Text('Transcripts',
                                style:
                                TextStyle(fontSize: 15,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.none),
                              )]),
                      ),

                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      new GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            /* MaterialPageRoute(builder: (context) => const MainScreenUi()),*/
                            MaterialPageRoute(builder: (context) => const SalesProspectsUI()),
                          );
                        },
                        child: Column(
                            children: <Widget>[
                              Image.asset('icons/sales.png',
                                width: 60,
                                height: 60,

                              ), Text('Sales',
                                style:
                                TextStyle(fontSize: 15,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.none),
                              )]),
                      ),

                    ],
                  ),
                )
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            )
            /*END OF THIRD ROW*/

          ],
        ));
  }

  void goToStudentsScreen(BuildContext context) async {
     studentsDataList =  await getStudentsList(context);
     /*bankBalances = await generateBankBalances(context);
    feeBalances = await generateFeeBalances(context);
    semesters =   await generateSemestersForTranscripts(context);*/


    Navigator.push(
      context,
      /* MaterialPageRoute(builder: (context) => const MainScreenUi()),*/
      MaterialPageRoute(builder: (context) => const StudentsUi()),
    );

  }

  void goToBankBalancesScreen(BuildContext context) async {
    bankBalancesList =  await getBankBalancesList(context);

    Navigator.push(
      context,
      /* MaterialPageRoute(builder: (context) => const MainScreenUi()),*/
      MaterialPageRoute(builder: (context) => const BanksBalancesUi()),
    );

  }

  void goToFeeBalancesScreen(BuildContext context) async {
    feeBalancesElementsList =  await getFeeBalancesDataList(context);

    Navigator.push(
      context,
      /* MaterialPageRoute(builder: (context) => const MainScreenUi()),*/
      MaterialPageRoute(builder: (context) => const FeeBalancesUI()),
    );

  }

  void goToPayrollPeriodScreen(BuildContext context) async {
    payrollPeriodsList =  await getPayrollPeriods(context);

    Navigator.push(
      context,
      /* MaterialPageRoute(builder: (context) => const MainScreenUi()),*/
      MaterialPageRoute(builder: (context) => const PayrollPeriodsUI()),
    );

  }

  void goToSchoolSemesters(BuildContext context) async {
    semestersList =  await getSchoolSemesters(context);

    Navigator.push(
      context,
      /* MaterialPageRoute(builder: (context) => const MainScreenUi()),*/
      MaterialPageRoute(builder: (context) => const TranscripsUI()),
    );

  }

  void goToLeaveClassesScreen(BuildContext context) async {
    leaveClassesList =  await getLeaveClassesList(context);

    Navigator.push(
      context,
      /* MaterialPageRoute(builder: (context) => const MainScreenUi()),*/
      MaterialPageRoute(builder: (context) => const LeaveClassesUi()),
    );

  }


}
