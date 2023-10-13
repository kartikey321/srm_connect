// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:srm_connect/screens/dashboard.dart';
import 'package:srm_connect/screens/mail.dart';
import 'package:srm_connect/screens/profile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Widget> screens = [
    Dashboard(),
    MailScreen(),
    Send_Msg(),
  ];
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    void onTap(int i) {
      setState(() {
        _selectedIndex = i;
      });
    }

    return Scaffold(
      body: IndexedStack(
        children: screens,
        index: _selectedIndex,
      ),
      backgroundColor: Colors.white,
      bottomNavigationBar: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
            height: 65,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF8865E4), Color(0xFF7B5FDA)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      _selectedIndex = 0;
                    });
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 400),
                    child: Column(
                      children: [
                        Expanded(
                          child: Icon(
                            Icons.dashboard,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        _selectedIndex == 0
                            ? Text(
                                'Dashboard',
                                style: GoogleFonts.libreFranklin(
                                    fontSize: 12, color: Colors.white),
                              )
                            : Container()
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      _selectedIndex = 1;
                    });
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 400),
                    child: Column(
                      children: [
                        Expanded(
                          child: Icon(
                            Icons.mail_outline,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        _selectedIndex == 1
                            ? Text(
                                'Messages',
                                style: GoogleFonts.libreFranklin(
                                    fontSize: 12, color: Colors.white),
                              )
                            : Container()
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      _selectedIndex = 2;
                    });
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 400),
                    child: Column(
                      children: [
                        Expanded(
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        _selectedIndex == 2
                            ? Text(
                                'Profile',
                                style: GoogleFonts.libreFranklin(
                                    fontSize: 12, color: Colors.white),
                              )
                            : Container()
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          // BottomNavigationBar(
          //   showUnselectedLabels: false,
          //   selectedItemColor: Colors.white,
          //   backgroundColor: Colors.transparent,
          //   onTap: onTap,
          //   currentIndex: _selectedIndex,
          //   items: [
          //     BottomNavigationBarItem(
          //       label: 'Dashboard',
          //       icon: Icon(
          //         Icons.dashboard,
          //         color: Colors.white,
          //       ),
          //     ),
          //     BottomNavigationBarItem(
          //       backgroundColor: Colors.transparent,
          //       label: 'Messages',
          //       icon: Icon(
          //         Icons.mail_outline,
          //         color: Colors.white,
          //       ),
          //     ),
          //     BottomNavigationBarItem(
          //       label: 'Profile',
          //       icon: Icon(
          //         Icons.person,
          //         color: Colors.white,
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}
