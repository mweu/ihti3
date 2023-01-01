import 'package:bensonone/HomeScreen.dart';
import 'package:bensonone/StaticVariables.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
void main() {
  runApp(const AttendanceUI());
}

class AttendanceUI extends StatelessWidget {


  const AttendanceUI({super.key});



  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'COLLEGEMAN',
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
        appBar: AppBar(title:
        Row(children: [
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
        ],)),
        body: const MyStatefulWidget(),

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

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController frominput = TextEditingController();
  TextEditingController toinput = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'Select Date Range',
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                      fontSize: 30),
                )),
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  ' ',
                  style: TextStyle(fontSize: 20),
                )),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: frominput,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'From',
                ),
                readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context, initialDate: DateTime.now(),
                        firstDate: DateTime(2000), //DateTime.now() - not to allow to choose before today.
                        lastDate: DateTime(2701)
                    );

                    if(pickedDate != null ){
                      print(pickedDate);  //pickedDate output format => 2021-03-10 00:00:00.000
                      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                      print(formattedDate); //formatted date output using intl package =>  2021-03-16
                      //you can implement different kind of Date Format here according to your requirement

                      setState(() {
                        frominput.text = formattedDate; //set output date to TextField value.
                      });
                    }else{
                      print("Date is not selected");
                    }
                  }
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextField(
                 controller: toinput,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'To',
                ),
                readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context, initialDate: DateTime.now(),
                        firstDate: DateTime(2000), //DateTime.now() - not to allow to choose before today.
                        lastDate: DateTime(2701)
                    );

                    if(pickedDate != null ){
                      print(pickedDate);  //pickedDate output format => 2021-03-10 00:00:00.000
                      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                      print(formattedDate); //formatted date output using intl package =>  2021-03-16
                      //you can implement different kind of Date Format here according to your requirement

                      setState(() {
                        toinput.text = formattedDate; //set output date to TextField value.
                      });
                    }else{
                      print("Date is not selected");
                    }
                  }
              ),
            ),
            TextButton(
              onPressed: () {
                //forgot password screen
              },
              child: const Text(' ',),
            ),
            Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ElevatedButton(
                  child: const Text('Submit'),
                  onPressed: () async {
                    /*print(nameController.text);
                    print(passwordController.text);*/

                    final from = frominput.text;
                    final to = toinput.text;

                    String url = "https://mansoftonline.com/adminrs/core/tamodule/gettaattendancereport/"+
                        CollegeManConstatnts.session.sessionKey +"/"+ from +"/" + to + "/c48963a1-6dc2-4419-b508-a75fa5126820";
                    _launchURL(url);



                    /* Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MainScreenUi()),
                    );*/
                  },
                )
            ),
          ],
        ));

  }



  void getStudentsData(BuildContext context) async {
    /* studentsData =  await generateProductList(context);
    bankBalances = await generateBankBalances(context);
    feeBalances = await generateFeeBalances(context);
    semesters =   await generateSemestersForTranscripts(context);*/


    Navigator.push(
      context,
      /* MaterialPageRoute(builder: (context) => const MainScreenUi()),*/
      MaterialPageRoute(builder: (context) => const MainscreenUiHome()),
    );

  }

  Future<void> loginToPayroll(String upn, String password) async {
    print(upn + " " + password);
    var client = new http.Client();
    /* final msg = jsonEncode( {
      "userName": upn,
      "password": password
    });*/
    // https://mansoftonline.com/payroll/ws/auth/authtst/mansoft@ihti.net/P0werm@n
    final response = await client.get
      (Uri.parse(
        'https://mansoftonline.com/payroll/ws/auth/authtst/' + upn +"/" + password),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Access-Control-Allow-Origin": "*",
        'Accept': '*/*'
      },);

    final body = json.decode(response.body);
    print(body);
    final responseObject = body['response'];

    final dataObject = responseObject['data'];


    final sessionKey = dataObject['key'];

    CollegeManConstatnts.session.setPayrollSession(sessionKey);

    print("Payroll Login was successfull");
    print(sessionKey);
  }

  _launchURL(String url) async {

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
