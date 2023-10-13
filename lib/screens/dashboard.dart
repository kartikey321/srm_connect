import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_like_css/gradient_like_css.dart';
import 'package:provider/provider.dart';
import 'package:srm_connect/dataProvider/app_data.dart';
import 'package:srm_connect/helpers/student_helper.dart';
import 'package:srm_connect/model/student.dart';
import 'package:srm_connect/screens/dash_tabs/attendance.dart';
import 'package:srm_connect/screens/dash_tabs/backlog.dart';
import 'package:srm_connect/screens/dash_tabs/report.dart';

import '../model/parent.dart';
import '../utils/libre_text.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool isDropdownOpen = false;

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppData>(context);
    Parent parent = provider.getParent;
    List<Student> students = provider.getStudents;
    Student currentStudent = provider.getCurrentStudent;
    var dropdownvalue = students[0];
    return Scaffold(
      backgroundColor: Color(0xFFE8EEFA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: linearGradient(
                    97.78,
                    ['#8B67E6 4.29%', '#7B5FDA 71.56%', '#7B5FDA 127.9%'],
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Color(0xFFD1CCF5),
                      offset: Offset(3.0, 9.0),
                      blurRadius: 8.0,
                    ),
                  ],
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    WriteText(
                      'SRMConect',
                      style: GoogleFonts.libreFranklin(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        DropdownButton(
                          dropdownColor: Colors.grey,
                          // Initial Value
                          value: provider.getCurrentStudent,

                          // Down Arrow Icon
                          icon: const Icon(Icons.keyboard_arrow_down),

                          // Array list of items
                          items: students.map((items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(
                                items.name,
                                style: GoogleFonts.dmSans(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              ),
                            );
                          }).toList(),
                          // After selecting the desired option,it will
                          // change button value to selected value
                          onChanged: (newValue) {
                            provider.updateCurrentStudent = newValue as Student;
                            var semsList = DataHelper.getListOfSems(
                                provider.getCurrentStudent);
                            provider.updateCurrsemester = semsList[
                                semsList.contains(
                                        provider.getCurrentStudent.semester)
                                    ? provider.getCurrentStudent.semester
                                    : 0];

                            // setState(() {
                            //   dropdownvalue = newValue as Student;
                            // });
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 35),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 42,
                          backgroundImage: AssetImage('assets/profile.png'),
                        ),
                        SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  WriteText1(
                                    'Batch: ${students[0].batch}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFFD9D9D9),
                                    ),
                                  ),
                                  WriteText1(
                                    'Semester: ${students[0].semester}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFFD9D9D9),
                                    ),
                                  ),
                                ],
                              ),
                              WriteText1(
                                'Reg Number: ${students[0].regNum}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFFD9D9D9),
                                ),
                              ),
                              WriteText1(
                                'Faculty Adivsor: ${students[0].facultyAdvisor}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFFD9D9D9),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: 30),
              BelowTab()
            ],
          ),
        ),
      ),
    );
  }
}

class BelowTab extends StatefulWidget {
  const BelowTab({super.key});

  @override
  State<BelowTab> createState() => _BelowTabState();
}

class _BelowTabState extends State<BelowTab> {
  int _selectedTab = 0;
  void onTap(int i) {
    _selectedTab = i;
    setState(() {});
  }

  List<Widget> tabs = [Report(), Attendance(), Backlog()];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {
                  onTap(0);
                },
                child: AnimatedContainer(
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFFD8D8D8), width: 1.5),
                      borderRadius: BorderRadius.circular(8),
                      color: _selectedTab == 0
                          ? Color(0xFF8865E4)
                          : Color(0xFFFBFBFB),
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(3, 4),
                            blurRadius: 4,
                            color: Color(0xFF6B6B6B).withOpacity(0.25))
                      ]),
                  child: Center(
                    child: ImageIcon(
                      AssetImage('assets/copy.png'),
                      size: 35,
                      color:
                          _selectedTab == 0 ? Colors.white : Color(0xFF737373),
                    ),
                  ),
                  width: 92,
                  height: 68,
                  duration: Duration(milliseconds: 300),
                ),
              ),
              InkWell(
                onTap: () {
                  onTap(1);
                },
                child: AnimatedContainer(
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFFD8D8D8), width: 1.5),
                      borderRadius: BorderRadius.circular(8),
                      color: _selectedTab == 1
                          ? Color(0xFF8865E4)
                          : Color(0xFFFBFBFB),
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(3, 4),
                            blurRadius: 4,
                            color: Color(0xFF6B6B6B).withOpacity(0.25))
                      ]),
                  child: Center(
                    child: ImageIcon(
                      AssetImage('assets/attend.png'),
                      size: 35,
                      color:
                          _selectedTab == 1 ? Colors.white : Color(0xFF737373),
                    ),
                  ),
                  width: 92,
                  height: 68,
                  duration: Duration(milliseconds: 300),
                ),
              ),
              InkWell(
                onTap: () {
                  onTap(2);
                },
                child: AnimatedContainer(
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFFD8D8D8), width: 1.5),
                      borderRadius: BorderRadius.circular(8),
                      color: _selectedTab == 2
                          ? Color(0xFF8865E4)
                          : Color(0xFFFBFBFB),
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(3, 4),
                            blurRadius: 4,
                            color: Color(0xFF6B6B6B).withOpacity(0.25))
                      ]),
                  child: Center(
                    child: ImageIcon(
                      AssetImage('assets/back.png'),
                      size: 35,
                      color:
                          _selectedTab == 2 ? Colors.white : Color(0xFF737373),
                    ),
                  ),
                  width: 92,
                  height: 68,
                  duration: Duration(milliseconds: 300),
                ),
              )
            ],
          ),
          IndexedStack(
            children: tabs,
            index: _selectedTab,
          )
        ],
      ),
    );
  }
}
