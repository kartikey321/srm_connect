// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers

import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:srm_connect/helpers/student_helper.dart';
import 'package:srm_connect/model/parent.dart';
import 'package:srm_connect/model/student.dart';
import 'package:srm_connect/screens/login_student.dart';
import 'package:srm_connect/screens/verified.dart';

import '../dataProvider/app_data.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final Connectivity _connectivity = Connectivity();

  bool ActiveConnection = false;
  String T = "";
  Future checkUserConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          ActiveConnection = true;
          T = "Turn off the data and repress again";
        });
      }
    } on SocketException catch (_) {
      DataHelper.showSnackbar('Check your internet connection', context);
      setState(() {
        ActiveConnection = false;
        T = "Turn On the data and repress again";
      });
    }
  }

  bool push = false;
  setUpVars() async {
    await checkUserConnection();
    if (FirebaseAuth.instance.currentUser != null) {
      User user = FirebaseAuth.instance.currentUser!;
      DataHelper dataHelper = DataHelper();
      Parent? userData;
      userData = await dataHelper.getParenDetails(user.email!);
      userData ??= await dataHelper.getParenDetails(user.email!);

      List<Student> students = [];
      Provider.of<AppData>(context, listen: false).updateParent = userData!;

      for (var d in userData.studentId as List) {
        Student student = await dataHelper.getStudentDetails(d);
        students.add(student);
      }
      Provider.of<AppData>(context, listen: false).updateStudentsList =
          students;

      var semsList = DataHelper.getListOfSems(
          Provider.of<AppData>(context, listen: false).getCurrentStudent);
      Provider.of<AppData>(context, listen: false).updateCurrsemester =
          semsList[semsList.contains(students[0].semester)
              ? students[0].semester
              : 0];

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => VerifiedScreen(parent: userData!)));
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginStudent()));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 0), () {
      setUpVars();
    });

    // if (FirebaseAuth.instance.currentUser != null) {
    //   setUpVars();
    // }
    // // Future.delayed(Duration(seconds: 3), () {});
    // if (FirebaseAuth.instance.currentUser == null) {
    //   Navigator.push(
    //       context, MaterialPageRoute(builder: (context) => LoginScreen()));
    // } else {
    //   while (push != true) {}
    //   Navigator.push(
    //       context, MaterialPageRoute(builder: (context) => HomePage()));
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(color: Color(0xFF8865E4)),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(padding: EdgeInsets.only(top: 10.0)),
                      Text(
                        "SRM Connect",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 26.0,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: Colors.white,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                    ),
                    // Text("Online Store \nFor Everyone",
                    //     style: TextStyle(
                    //         color: Colors.white,
                    //         fontSize: 18.0,
                    //         fontWeight: FontWeight.bold))
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
