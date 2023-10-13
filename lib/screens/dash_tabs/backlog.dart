import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../dataProvider/app_data.dart';
import '../../model/parent.dart';
import '../../model/student.dart';
import '../../utils/libre_text.dart';

class Backlog extends StatefulWidget {
  const Backlog({super.key});

  @override
  State<Backlog> createState() => _BacklogState();
}

class _BacklogState extends State<Backlog> {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppData>(context);
    Parent parent = provider.getParent;
    List<Student> students = provider.getStudents;
    var currStudent = provider.getCurrentStudent;
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WriteText('Backlogs',
              style: TextStyle(fontSize: 22, color: Color(0xFF150050))),
          SizedBox(
            height: 20,
          ),
          ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                var backlogs = currStudent.academics![0].backlog!;
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      WriteText(backlogs[index],
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w600)),
                      WriteText('Faculty- RS Sandhya',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: AssetImage(
                          'assets/backlog.png',
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
                  height: 12,
                );
              },
              itemCount: students[0].academics![0].backlog!.length),
          SizedBox(
            height: 30,
          ),
          WriteText('Dues',
              style: TextStyle(fontSize: 22, color: Color(0xFF150050))),
          SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.all(12),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  WriteText('Biology',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w600)),
                  WriteText('Faculty- RS Sandhya',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            height: 60,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: AssetImage('assets/backlog.png'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      Color.fromRGBO(228, 102, 110, 0.85), BlendMode.srcOver),
                )),
          ),
        ],
      ),
    );
  }
}
