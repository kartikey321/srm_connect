import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:srm_connect/helpers/student_helper.dart';
import 'package:srm_connect/model/parent.dart';

import 'home_screen.dart';

class VerifiedScreen extends StatefulWidget {
  final Parent parent;
  const VerifiedScreen({super.key, required this.parent});

  @override
  State<VerifiedScreen> createState() => _VerifiedScreenState();
}

class _VerifiedScreenState extends State<VerifiedScreen> {
  Future<Parent?>? pt1;
  DataHelper dataHelper = DataHelper();
  @override
  void initState() {
    pt1 = dataHelper.getParenDetails(widget.parent.email);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                height: 350,
                width: 350,
                child: Lottie.asset('assets/loading.json')),
            SizedBox(
              height: 50,
            ),
            RefreshIndicator(
                onRefresh: () {
                  return dataHelper.getParenDetails(widget.parent.email);
                },
                child: FutureBuilder<Parent?>(
                  future: dataHelper.getParenDetails(widget.parent.email),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator(); // You can replace this with your own loading widget.
                    } else if (snapshot.hasError) {
                      // Handle the error.
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.data!.verified == false) {
                      // Account is not verified, display a message.
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Your account is not verified. Please Wait!',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 25, color: Colors.black),
                        ),
                      );
                    } else {
                      // Account is verified, navigate to HomeScreen.
                      WidgetsBinding.instance!.addPostFrameCallback((_) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                          (route) => false,
                        );
                      });
                      return Container(); // Return an empty container for now.
                    }
                  },
                ))
          ],
        ),
      ),
    );
  }
}
