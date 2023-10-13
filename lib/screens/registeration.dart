import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:srm_connect/dataProvider/app_data.dart';
import 'package:srm_connect/helpers/student_helper.dart';
import 'package:srm_connect/screens/home_screen.dart';
import 'package:srm_connect/screens/login_student.dart';

import '../model/parent.dart';
import '../model/student.dart';
import '../widgets/progress_dialog.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool? _success;
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var phoneController = TextEditingController();
  var fullNameController = TextEditingController();
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
    final User? user = (await _auth
            .createUserWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
    )
            .catchError((ex) {
      Navigator.pop(context);
      PlatformException thisex = ex;
      showSnackbar(thisex.message!);
    }))
        .user;

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
          name: fullNameController.text,
          email: emailController.text,
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
                  height: 40,
                ),
                Text(
                  'SRM Connect',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 28,
                  ),
                ),
                SizedBox(
                  height: 70,
                ),
                Image(
                  image: AssetImage('assets/srm.png'),
                  alignment: Alignment.center,
                  height: 100.0,
                  width: 100.0,
                ),
                SizedBox(
                  height: 40,
                ),
                Text(
                  'Create a Parent\'s account',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25, fontFamily: 'Brand-Bold'),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      //Full Name
                      TextFormField(
                        controller: fullNameController,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          labelText: 'Full Name',
                          labelStyle: TextStyle(fontSize: 14),
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 10.0),
                        ),
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      //Email Address
                      TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email address',
                          labelStyle: TextStyle(fontSize: 14),
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 10.0),
                        ),
                        style: TextStyle(fontSize: 14),
                      ),
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
                      SizedBox(
                        height: 10,
                      ),

                      //Password
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(fontSize: 14),
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 10.0),
                        ),
                        style: TextStyle(fontSize: 14),
                      ),
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
                          print(fullNameController.text);
                          if (fullNameController.text.length < 3) {
                            showSnackbar('Please provide a valid fullname');
                            return;
                          }
                          if (phoneController.text.length < 10) {
                            showSnackbar('Please provide a valid phone number');
                            return;
                          }
                          if (!emailController.text.contains('@')) {
                            showSnackbar(
                                'Please provide a valid email address');
                            return;
                          }
                          if (passwordController.text.length < 6) {
                            showSnackbar(
                                'Please provide a valid password greater than 6 characters');
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
                              'REGISTER',
                              style: TextStyle(
                                  fontSize: 18, fontFamily: 'Brand-Bold'),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginStudent()));
                    },
                    child: Text('Already have a Parent account? Log in.'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
