// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:srm_connect/model/parent.dart';
import 'package:srm_connect/screens/home_screen.dart';
import 'package:srm_connect/widgets/progress_dialog.dart';

import '../dataProvider/app_data.dart';
import '../helpers/student_helper.dart';
import '../model/student.dart';

class CompleteProfile extends StatefulWidget {
  User user;
  CompleteProfile({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<CompleteProfile> createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {
  bool _success = false;
  var phoneController = TextEditingController();
  var registerNumber = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void showSnackbar(String title) {
    final snackBar = SnackBar(
      content: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 15),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  registerUser() async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => ProgressDialog(
              status: 'Registering you... ',
            ));

    var user = widget.user;
    print(user);
    if (user != null) {
      int atIndex = user.email!.indexOf("@");

      // Extract the part before the "@" symbol
      String path = user.email!.substring(0, atIndex);
      DatabaseReference newUserRef =
          FirebaseDatabase.instance.ref().child('Parents/$path');
      Map userMap = {'registered': true};
      final List<String> ids = registerNumber.text.split(RegExp(r'[,\s]+'));
      Parent parent = Parent(
          id: user.uid,
          name: user.displayName!,
          email: user.email!,
          whatsappNumber: phoneController.text,
          threads: [],
          studentId: ids,
          verified: false);

      newUserRef.set(userMap);
      Provider.of<AppData>(context, listen: false).updateParent = parent;
      List<Student> students = [];
      DataHelper dataHelper = DataHelper();
      await dataHelper.addParent(parent);
      for (var d in parent.studentId as List) {
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
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
          (route) => false);
      setState(() {
        _success = true;
        print('registeration sucessfull');
      });
    } else {
      _success = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 70,
                ),
                Text(
                  'Complete your profile',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25, fontFamily: 'Brand-Bold'),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      //Full Name

                      SizedBox(
                        height: 10,
                      ),
                      //Phone No
                      TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          labelStyle: TextStyle(fontSize: 14),
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 10.0),
                        ),
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(
                        height: 10,
                      ),

                      TextField(
                        controller: registerNumber,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          labelText: 'Student\s Register No',
                          labelStyle: TextStyle(fontSize: 14),
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 10.0),
                        ),
                        style: TextStyle(fontSize: 14),
                      ),

                      //Password

                      SizedBox(
                        height: 40,
                      ),
                      MaterialButton(
                        onPressed: () async {
                          // var connectivityResult =
                          //     Connectivity().checkConnectivity();
                          // if (connectivityResult != ConnectivityResult.mobile &&
                          //     connectivityResult != ConnectivityResult.wifi) {
                          //   showSnackbar('No internet connectivity');
                          //   return;
                          // }

                          if (phoneController.text.length < 10) {
                            showSnackbar('Please provide a valid phone number');
                            return;
                          }

                          registerUser();
                        },
                        color: Color(0xFF8B67E6),
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Container(
                          height: 50,
                          child: Center(
                            child: Text(
                              'SUBMIT',
                              style: TextStyle(
                                  fontSize: 18, fontFamily: 'Brand-Bold'),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
