import 'package:flutter/material.dart';
import 'package:srm_connect/model/student.dart';

import '../model/parent.dart';

class AppData extends ChangeNotifier {
  Parent? _parent;
  List<Student> _students = [];

  Student? _currentStudent;
  int? _currSemester;

  Parent get getParent => _parent!;

  set updateParent(Parent pt1) {
    _parent = pt1;
    notifyListeners();
  }

  List<Student> get getStudents => _students;

  set updateStudentsList(List<Student> stud) {
    _students = stud;
    _currentStudent = _students[0];
    notifyListeners();
  }

  Student get getCurrentStudent => _currentStudent!;

  set updateCurrentStudent(Student student) {
    _currentStudent = student;
    notifyListeners();
  }

  int get getcurrSemester => _currSemester!;

  set updateCurrsemester(int x) {
    _currSemester = x;
    notifyListeners();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _parent = null;
    _currSemester = null;
    _students = [];
    _currentStudent = null;
  }
}
