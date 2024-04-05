import 'package:flutter/material.dart';
import 'package:trident/student/student.dart';
import 'package:trident/courses/courses.dart';
import 'package:trident/enrollment/enrollment.dart';
import 'package:trident/database-helper/database-helper.dart';

class ShowSelectedStudent extends StatefulWidget {
  final Courses course;

  const ShowSelectedStudent({super.key, required this.course});
  @override
  State<ShowSelectedStudent> createState() => _ShowSelectedStudent();
}

class _ShowSelectedStudent extends State<ShowSelectedStudent> {
  bool isSelectedStudents = false;
  List<Students> selectedStudents = [];

  @override
  void initState() {
    super.initState();
    _getAllSelectedStudent();
  }

  void _getAllSelectedStudent() async {
    List<Students> allStudentsData = await DatabaseHelper.instance.getAllStudentsData();
    List<Enrollment> allEnrollmentStudents = await DatabaseHelper.instance.getEnrollmentDataByCourseID(
      widget.course.id
    );
    for (var i = 0; i < allEnrollmentStudents.length; i++) {
      for (var j = 0;j < allStudentsData.length; j++) {
        if (allEnrollmentStudents[i].student_id == allStudentsData[j].id){
          selectedStudents.add(allStudentsData[j]);
        }
      }
    }
    setState(() {
      isSelectedStudents = true;
    });
  }

  Widget selectStudentListView(Students selectStudent) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(5)
        ),
        child: ListTile(
          title: Text(selectStudent.name, style: const TextStyle(fontSize: 23)),
          trailing: const Icon(Icons.more_vert, size: 30),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('選課學生清單', style: TextStyle(fontSize: 25)),
      ),
      body: isSelectedStudents ?
      ListView.builder(
        itemCount: selectedStudents.length,
        itemBuilder: (BuildContext context, int index) {
          return selectStudentListView(selectedStudents[index]);
        }
      ) : const Center(
        child: Text('當前無選課學生', style: TextStyle(fontSize: 25)),
      ),
    );
  }
}