import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:srm_connect/dataProvider/mail_provider.dart';
import 'package:srm_connect/helpers/request_helper.dart';
import 'package:srm_connect/model/parent.dart';

import '../model/srm_mail.dart';
import '../model/student.dart';
import '../model/thread.dart';

class DataHelper {
  final String baseUrl = 'https://srmconnserver-production-0ad7.up.railway.app';
  Future<Student> getStudentDetails(String regNum) async {
    var data = await RequestHelper.getRequest('$baseUrl/student/$regNum');
    Student student = Student.fromMap(data['data']);
    return student;
  }

  addStudent(Student student) async {
    var res =
        await RequestHelper.postRequest('$baseUrl/student', student.toMap());
    return res;
  }

  addParent(Parent parent) async {
    var res =
        await RequestHelper.postRequest('$baseUrl/parent', parent.toMap());
    return res;
  }

  Future<Parent?> getParenDetails(String id) async {
    try {
      var data = await RequestHelper.getRequest('$baseUrl/parent/$id');
      Parent parent = Parent.fromMap(data['data']);
      print(parent);
      return parent;
    } catch (e) {
      print(e);
    }
  }

  // Future<Academics> getAcademicsDetails(String studentId) async {
  //   var data = await RequestHelper.getRequest(
  //       '$baseUrl/academics?studentId=$studentId');
  //   Academics academics = Academics.fromMap(data);
  //   return academics;
  // }
  //
  // Future<Course> getCourseDetails(String studentId, int semester) async {
  //   var data = await RequestHelper.getRequest(
  //       '$baseUrl/courses?semester=$semester&Num=$studentId');
  //   Course course = Course.fromMap(data);
  //   return course;
  // }

  Future<Thread> getThreadDetails(String id) async {
    var data = await RequestHelper.getRequest('$baseUrl/thread/$id');
    Thread thread = Thread.fromMap(data['data']);
    return thread;
  }

  Future<SRMMail> getMailDetails(String id) async {
    var data = await RequestHelper.getRequest('$baseUrl/mail/$id');
    SRMMail mail = SRMMail.fromMap(data['data']);
    return mail;
  }

  addMail(SRMMail mail, BuildContext context, String threadId) async {
    var body = mail.toMap();
    body['threadId'] = threadId;
    var res = await RequestHelper.postRequest('$baseUrl/mail', body);
    return res;
  }

  updateMessages(BuildContext context) async {
    var thread =
        Provider.of<MailProvider>(context, listen: false).currentThread;
    if (thread != null) {
      var res = await getThreadDetails(thread.id!);
      Provider.of<MailProvider>(context, listen: false).setCurrentThread = res;
      Provider.of<MailProvider>(context, listen: false).updateMailIds =
          res.messageIds;
    }
  }

  Future<String> addThread(String senderId, String recieverId) async {
    Map<String, dynamic> body = {
      "senderId": senderId, //sender email
      "senderType": "parents", //students,parents,faculties
      "recieverId": recieverId, //reciever email.
      "recieverType": "faculties"
    };
    var res = await RequestHelper.postRequest('$baseUrl/thread', body);
    return res;
  }

  static showSnackbar(String title, BuildContext context) {
    final snackBar = SnackBar(
      content: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 15),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static List<int> getListOfSems(Student student) {
    Set<int> sems = {};
    for (var course in student.courses!) {
      sems.add(course.semester);
    }
    var semsList = sems.toList();
    semsList.sort();

    return semsList;
  }
}
