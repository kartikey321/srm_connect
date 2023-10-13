import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:srm_connect/model/srm_mail.dart';

import '../dataProvider/app_data.dart';
import '../helpers/student_helper.dart';
import '../model/parent.dart';
import '../model/student.dart';

class Write_Msg extends StatefulWidget {
  const Write_Msg({super.key});

  @override
  State<Write_Msg> createState() => _Write_MsgState();
}

class _Write_MsgState extends State<Write_Msg> {
  final _formKey = GlobalKey<FormState>();
  var person = "";
  var ward = "";
  var reason = "";
  var multimsg = "";
  final personController = TextEditingController();
  final wardController = TextEditingController();
  final reasonController = TextEditingController();
  final multimsgController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    personController.dispose();
    wardController.dispose();
    reasonController.dispose();
    multimsgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppData>(context);
    Parent parent = provider.getParent;
    List<Student> students = provider.getStudents;
    var dropdownvalue = students[0];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(
          color: Colors.black,
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: ListView(
            children: [
              Container(
                child: TextFormField(
                  autofocus: false,
                  decoration: InputDecoration(
                      labelText: 'Select Person',
                      labelStyle: GoogleFonts.lato(
                        fontSize: 18,
                      ),
                      errorStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      )),
                  controller: personController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter your Select Person';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                child: Row(
                  children: [
                    Text(
                      'Select Ward',
                      style: GoogleFonts.lato(
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(
                      width: 25,
                    ),
                    DropdownButton(
                      // Initial Value
                      value: dropdownvalue,

                      // Down Arrow Icon
                      icon: const Icon(Icons.keyboard_arrow_down),

                      // Array list of items
                      items: students.map((items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items.name),
                        );
                      }).toList(),
                      // After selecting the desired option,it will
                      // change button value to selected value
                      onChanged: (newValue) {
                        setState(() {
                          dropdownvalue = newValue as Student;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Container(
                child: TextFormField(
                  autofocus: false,
                  decoration: InputDecoration(
                      labelText: 'Select Reason',
                      labelStyle: GoogleFonts.lato(
                        fontSize: 18,
                      ),
                      errorStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      )),
                  controller: reasonController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter your Select Person';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 30),
                child: TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: InputDecoration(
                      labelText: 'Write Message',
                      labelStyle: GoogleFonts.lato(
                        fontSize: 18,
                      ),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 1, color: Color(0xff7B5FDA)))),
                  controller: multimsgController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Write a message';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 45),
              Container(
                child: ElevatedButton.icon(
                  label: Text(
                    "Send",
                    style: GoogleFonts.lato(fontSize: 18, color: Colors.white),
                  ),
                  icon: Icon(Icons.arrow_circle_right_outlined),
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(double.infinity, 60),
                    backgroundColor: Color(0xff7B5FDA),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        person = personController.text;
                        ward = wardController.text;
                        reason = reasonController.text;
                        multimsg = multimsgController.text;
                      });
                      DataHelper dataHelper = DataHelper();
                      var res =
                          await dataHelper.addThread(parent.email, person);
                      var threadId = jsonDecode(res)['threadId'];
                      SRMMail mail = SRMMail(
                          body: multimsg,
                          senderId: parent.email,
                          time: DateTime.now(),
                          directedTo: person,
                          studentId: dropdownvalue.regNum);
                      await dataHelper.addMail(mail, context, threadId);
                      Navigator.pop(context);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
