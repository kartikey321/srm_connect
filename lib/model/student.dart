// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:srm_connect/model/parent_info.dart';

import 'academics.dart';
import 'course.dart';

class Student {
  String id;
  String regNum;
  String name;
  String email;
  String batch;
  int semester;
  String facultyAdvisor;
  String department;
  String whatsappNumber;
  List<ParentInfo>? parents;
  List<Academics>? academics;
  List<Course>? courses;
  Student({
    required this.id,
    required this.regNum,
    required this.name,
    required this.email,
    required this.batch,
    required this.semester,
    required this.facultyAdvisor,
    required this.department,
    required this.whatsappNumber,
    this.parents,
    this.academics,
    this.courses,
  });

  Student copyWith({
    String? id,
    String? regNum,
    String? name,
    String? email,
    String? batch,
    int? semester,
    String? facultyAdvisor,
    String? department,
    String? whatsappNumber,
    List<ParentInfo>? parents,
    List<Academics>? academics,
    List<Course>? courses,
  }) {
    return Student(
      id: id ?? this.id,
      regNum: regNum ?? this.regNum,
      name: name ?? this.name,
      email: email ?? this.email,
      batch: batch ?? this.batch,
      semester: semester ?? this.semester,
      facultyAdvisor: facultyAdvisor ?? this.facultyAdvisor,
      department: department ?? this.department,
      whatsappNumber: whatsappNumber ?? this.whatsappNumber,
      parents: parents ?? this.parents,
      academics: academics ?? this.academics,
      courses: courses ?? this.courses,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'regNum': regNum,
      'name': name,
      'email': email,
      'batch': batch,
      'semester': semester,
      'facultyAdvisor': facultyAdvisor,
      'department': department,
      'whatsappNumber': whatsappNumber,
      'parents': parents!.map((x) => x?.toMap()).toList(),
      'academics': academics!.map((x) => x?.toMap()).toList(),
      'courses': courses!.map((x) => x?.toMap()).toList(),
    };
  }

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'] as String,
      regNum: map['regNum'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      batch: map['batch'] as String,
      semester: map['semester'] as int,
      facultyAdvisor: map['facultyAdvisor'] as String,
      department: map['department'] as String,
      whatsappNumber: map['whatsappNumber'] as String,
      parents: map['parents'] != null
          ? List<ParentInfo>.from(
              (map['parents'] as List).map<ParentInfo?>(
                (x) => ParentInfo.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      academics: map['academics'] != null
          ? List<Academics>.from(
              (map['academics'] as List).map<Academics?>(
                (x) => Academics.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      courses: map['courses'] != null
          ? List<Course>.from(
              (map['courses'] as List).map<Course?>(
                (x) => Course.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Student.fromJson(String source) =>
      Student.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Student(id: $id, regNum: $regNum, name: $name, email: $email, batch: $batch, semester: $semester, facultyAdvisor: $facultyAdvisor, department: $department, whatsappNumber: $whatsappNumber, parents: $parents, academics: $academics, courses: $courses)';
  }

  @override
  bool operator ==(covariant Student other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.regNum == regNum &&
        other.name == name &&
        other.email == email &&
        other.batch == batch &&
        other.semester == semester &&
        other.facultyAdvisor == facultyAdvisor &&
        other.department == department &&
        other.whatsappNumber == whatsappNumber &&
        listEquals(other.parents, parents) &&
        listEquals(other.academics, academics) &&
        listEquals(other.courses, courses);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        regNum.hashCode ^
        name.hashCode ^
        email.hashCode ^
        batch.hashCode ^
        semester.hashCode ^
        facultyAdvisor.hashCode ^
        department.hashCode ^
        whatsappNumber.hashCode ^
        parents.hashCode ^
        academics.hashCode ^
        courses.hashCode;
  }
}
