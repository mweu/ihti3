import 'dart:collection';

import 'package:bensonone/LoginResponse.dart';
import 'package:bensonone/MainScreen.dart';
import 'package:bensonone/StaticVariables.dart';
import 'package:bensonone/Students.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
void main() {
  runApp(const FeePayments());
}

class FeePayments extends StatelessWidget {


  const FeePayments({super.key});



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
                  'Fee Balances',
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                      fontSize: 30),
                )),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Currency',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextField(
                obscureText: true,
                controller: passwordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                //forgot password screen
              },
              child: const Text('Forgot Password',),
            ),
            Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ElevatedButton(
                  child: const Text('Login'),
                  onPressed: () async {
                    /*print(nameController.text);
                    print(passwordController.text);*/

                    final userName = nameController.text;
                    final password = passwordController.text;
                    var client = new http.Client();
                    try {
                      Map<String,String> header = {
                        "Host": "mansoftonline.com"
                      };

                      try {
                        print("User Name:" + userName +" And Password " + password);
                        final response = await client.get
                          (Uri.parse(
                            'https://mansoftonline.com/adminrs/core/auth/ess/' + userName +"/" + password),
                            headers: <String, String>{
                              'Content-Type': 'application/json; charset=UTF-8',
                              "Access-Control-Allow-Origin": "*",
                              'Accept': '*/*'
                            });

                        final body = json.decode(response.body);
                        final responseObject = body['response'];

                        final dataObject = responseObject['data'];


                        final companyId = dataObject['companyId'];
                        final userId = dataObject['userId'];
                        final sessionKey = dataObject['key'];

                        CollegeManConstatnts.session.setSession(sessionKey);
                        CollegeManConstatnts.session.setTenantId(companyId);

                        CollegeManConstatnts.session.setUserId(userId);

                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Successful Login"),
                        ));

                        getStudentsData(context);



                      }on Exception catch(error){
                        print(error);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(error.toString()),
                        ));
                      }





                    }
                    finally {
                      client.close();
                    }


                    /* Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MainScreenUi()),
                    );*/
                  },
                )
            ),
            Row(
              children: <Widget>[
                const Text('Does not have account?'),
                TextButton(
                  child: const Text(
                    'Contact System Admin',
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    //signup screen
                  },
                )
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
          ],
        ));
  }

  void getStudentsData(BuildContext context) async {
    studentsData =  await generateProductList(context);
    bankBalances = await generateBankBalances(context);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MainScreenUi()),
    );

  }
}
