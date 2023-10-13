import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:srm_connect/model/parent.dart';
import 'package:srm_connect/screens/complete_prof.dart';
import 'package:srm_connect/screens/registeration.dart';

import '../dataProvider/app_data.dart';
import '../helpers/student_helper.dart';
import '../model/student.dart';
import '../widgets/progress_dialog.dart';
import 'home_screen.dart';

class LoginStudent extends StatefulWidget {
  const LoginStudent({super.key});

  @override
  State<LoginStudent> createState() => _LoginStudentState();
}

class _LoginStudentState extends State<LoginStudent> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signInWithGoogle({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
            await auth.signInWithCredential(credential);

        user = userCredential.user;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
        } else if (e.code == 'invalid-credential') {}
      } catch (e) {}

      return user;
    }
  }

  void login() async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => ProgressDialog(
              status: 'Logging you in... ',
            ));
    try {
      final user = (await _auth
              .signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      )
              .catchError((ex) {
        Navigator.pop(context);
        FirebaseAuthException thisex = ex;
        showSnackbar(thisex.message!);
      }))
          .user;

      if (user != null) {
        int atIndex = user.email!.indexOf("@");

        // Extract the part before the "@" symbol
        String path = user.email!.substring(0, atIndex);
        DatabaseReference userRef =
            FirebaseDatabase.instance.ref().child('Parents/$path');

        userRef.once().then((d) async {
          if (d.snapshot.exists) {
            DataHelper dataHelper = DataHelper();
            Parent? parent;
            parent = await dataHelper.getParenDetails(user.email!);

            Provider.of<AppData>(context, listen: false).updateParent = parent!;
            List<Student> students = [];

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
            Navigator.pop(context);
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
                (route) => false);
          } else
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CompleteProfile(user: user)));
        });
      }
      showSnackbar('${user!.email} signed in');
    } catch (e) {
      showSnackbar(e.toString());
      print(e.toString());
    }
  }

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

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
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
                  'Sign In as a Parent',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
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
                      TextField(
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
                          // }
                          if (!emailController.text.contains('@')) {
                            showSnackbar('Please enter a valid email');
                            return;
                          }
                          if (passwordController.text.length < 6) {
                            showSnackbar('Please enter a valid password');
                            return;
                          }
                          login();
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
                              'LOGIN',
                              style: TextStyle(
                                  fontSize: 18, fontFamily: 'Brand-Bold'),
                            ),
                          ),
                        ),
                      )
                      // TaxiButton(
                      //   color: BrandColors.colorGreen,
                      //   title: 'LOGIN',
                      //   onPressed: () async {
                      //     var connectivityResult =
                      //         Connectivity().checkConnectivity();
                      //     if (connectivityResult != ConnectivityResult.mobile &&
                      //         connectivityResult != ConnectivityResult.wifi) {
                      //       showSnackbar('No internet connectivity');
                      //       return;
                      //     }
                      //     if (!emailController.text.contains('@')) {
                      //       showSnackbar('Please enter a valid email');
                      //       return;
                      //     }
                      //     if (passwordController.text.length < 6) {
                      //       showSnackbar('Please enter a valid password');
                      //       return;
                      //     }
                      //     login();
                      //   },
                      // ),
                    ],
                  ),
                ),
                TextButton(
                    onPressed: () {
                      // Navigator.pushNamed(context, RegisterationPage.id);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Register()));
                    },
                    child: Text(
                      'Dont\'t have an account, sign up here',
                      style: TextStyle(color: Colors.black),
                    )),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 0.35 * width,
                        child: Divider(
                          thickness: 1.0,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(
                        width: 7,
                      ),
                      Text(
                        'OR',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey),
                      ),
                      SizedBox(
                        width: 7,
                      ),
                      Container(
                        width: 0.35 * width,
                        child: Divider(
                          thickness: 1.0,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () async {
                    User? user = await signInWithGoogle(context: context);
                    if (user != null) {
                      int atIndex = user.email!.indexOf("@");

                      String path = user.email!.substring(0, atIndex);
                      DatabaseReference userRef = FirebaseDatabase.instance
                          .ref()
                          .child('Parents/$path');

                      userRef.once().then((data) async {
                        var snapshot = data.snapshot;
                        if (snapshot.value != null) {
                          DataHelper dataHelper = DataHelper();
                          Parent? parent;
                          parent =
                              await dataHelper.getParenDetails(user.email!);
                          List<Student> students = [];

                          print(parent);
                          for (var d in parent!.studentId as List) {
                            Student student =
                                await dataHelper.getStudentDetails(d);
                            students.add(student);
                          }
                          Provider.of<AppData>(context, listen: false)
                              .updateParent = parent;
                          Provider.of<AppData>(context, listen: false)
                              .updateStudentsList = students;

                          var semsList = DataHelper.getListOfSems(
                              Provider.of<AppData>(context, listen: false)
                                  .getCurrentStudent);
                          Provider.of<AppData>(context, listen: false)
                                  .updateCurrsemester =
                              semsList[semsList.contains(students[0].semester)
                                  ? students[0].semester
                                  : 0];

                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeScreen()),
                              (route) => false);
                          print('Child node exists');
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CompleteProfile(
                                      user: user,
                                    )),
                          );
                          print('Child node does not exist');
                        }
                      }).catchError((error) {
                        print('Error: $error');
                      });
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(35),
                      color: Colors.grey,
                    ),
                    width: 250,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 18),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Sign In With Google',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Container(
                            width: 25,
                            height: 25,
                            child: Image.asset(
                              'assets/google.png',
                              fit: BoxFit.cover,
                            ))
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
