import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:srm_connect/dataProvider/app_data.dart';
import 'package:srm_connect/utils/libre_text.dart';

import '../../helpers/student_helper.dart';
import '../../model/parent.dart';
import '../../model/student.dart';

class Report extends StatefulWidget {
  const Report({super.key});

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  var dropdownvalue;
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppData>(context);
    Parent parent = provider.getParent;
    List<Student> students = provider.getStudents;

    var student = provider.getCurrentStudent;
    var semsList = DataHelper.getListOfSems(student);

    return Container(
      color: Color(0xFFE8EEFA),
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          WriteText('Report',
              style: TextStyle(fontSize: 22, color: Color(0xFF150050))),
          Row(
            children: [
              WriteText1('Semester',
                  style: TextStyle(fontSize: 18, color: Color(0xFF373737))),
              DropdownButton(
                // Initial Value
                value: provider.getcurrSemester,

                // Down Arrow Icon
                icon: const Icon(Icons.keyboard_arrow_down),

                // Array list of items
                items: semsList.map((items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Container(
                      color: Colors.white,
                      margin: const EdgeInsets.only(left: 8),
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        items.toString(),
                        style: GoogleFonts.dmSans(
                            fontWeight: FontWeight.w400, color: Colors.black),
                      ),
                    ),
                  );
                }).toList(),
                // After selecting the desired option,it will
                // change button value to selected value
                onChanged: (newValue) {
                  setState(() {
                    provider.updateCurrsemester = newValue as int;
                  });
                },
              ),
              // Container(
              //   padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
              //   margin: EdgeInsets.symmetric(horizontal: 5, vertical: 6),
              //   color: Color(0xFFFFFFFF),
              //   child: Row(
              //     children: [
              //       Text('1'),
              //       SizedBox(
              //         width: 6,
              //       ),
              //       Icon(Icons.keyboard_arrow_down)
              //     ],
              //   ),
              // )
            ],
          ),
          ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Container(
                  height: 135,
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 30),
                  child: Row(children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundImage: AssetImage(
                        'assets/pols.png',
                      ),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(
                              students[0].courses![index].courseName,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              'CT1: ${students[0].courses![index].CT1.toString()}',
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              'CT2: ${students[0].courses![index].CT2.toString()}',
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                        SizedBox(
                          width: 50,
                        ),
                        Column(
                          children: [
                            Text(
                              students[0].courses![index].facultyName,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              'CT3: ${students[0].courses![index].CT3.toString()}',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        )
                      ],
                    )
                  ]),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: AssetImage(
                          'assets/dbms.png',
                        ),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                            Color.fromRGBO(139, 105, 240, 0.71),
                            BlendMode.srcOver),
                      )),
                );
              },
              separatorBuilder: (context, index) {
                return SizedBox(
                  height: 15,
                );
              },
              itemCount: students[0].courses!.length)
        ],
      ),
    );
  }
}
