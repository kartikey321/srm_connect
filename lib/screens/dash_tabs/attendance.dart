import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../dataProvider/app_data.dart';
import '../../model/course.dart';
import '../../model/parent.dart';
import '../../model/student.dart';
import '../../utils/libre_text.dart';

class Attendance extends StatefulWidget {
  const Attendance({super.key});

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppData>(context);
    Parent parent = provider.getParent;
    List<Student> students = provider.getStudents;
    var student = provider.getCurrentStudent;
    var courses = student.courses!
        .where((course) => course.semester == provider.getcurrSemester)
        .toList();
    return Container(
      padding: EdgeInsets.only(left: 20, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.only(right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                WriteText('Attendance',
                    style: TextStyle(fontSize: 22, color: Color(0xFF150050))),
                Container(
                  padding: EdgeInsets.all(7),
                  height: 29,
                  child: Center(
                    child: WriteText('66.7%',
                        style: TextStyle(color: Color(0xFF150050))),
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Color(0xFFFFD850)),
                )
              ],
            ),
          ),
          SizedBox(
            height: 26,
          ),
          ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                Course course = courses[index];
                return Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(15),
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: CircleAvatar(
                              radius: 27,
                              backgroundImage: AssetImage('assets/pols.png'),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            width: 252,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    WriteText(course.courseName,
                                        style: TextStyle(
                                            color: Color(0xFF4A4A4A),
                                            fontSize: 16)),
                                    WriteText(course.facultyName,
                                        style:
                                            TextStyle(color: Color(0xFF4A4A4A)))
                                  ],
                                ),
                                SizedBox(
                                  height: 7,
                                ),
                                Container(
                                  height: 11,
                                  width: 180,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Color(0xFFD9D9D9)),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          flex: course.attendance.round(),
                                          child: Container(
                                            height: 11,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color: course.attendance > 75
                                                    ? Color(0xFF47E32E)
                                                    : course.attendance > 65
                                                        ? Color(0xFFFFD950)
                                                        : Color(0xFFE87777)),
                                          )),
                                      Expanded(
                                          flex: 100 - course.attendance.round(),
                                          child: Container(
                                            height: 11,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color: Color(0xFFD9D9D9)),
                                          ))
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 7,
                                ),
                                WriteText('${course.attendance}%',
                                    style: TextStyle(
                                        color: Color(0xFF4A4A4A),
                                        fontSize: 16)),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                );
              },
              separatorBuilder: (context, index) {
                return SizedBox(
                  height: 20,
                );
              },
              itemCount: students[0].courses!.length),
        ],
      ),
    );
  }
}
