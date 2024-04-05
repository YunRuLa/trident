import 'package:flutter/material.dart';
import 'package:trident/courses/courses.dart';
import 'package:trident/enrollment/enrollment.dart';
import 'package:trident/database-helper/database-helper.dart';

class ShowEnrollmentList extends StatefulWidget {
  final String student_id;

  const ShowEnrollmentList({super.key, required this.student_id});

  @override
  State<ShowEnrollmentList> createState() => _ShowEnrollmentList();
}

class _ShowEnrollmentList extends State<ShowEnrollmentList> {
  List<Enrollment> enrollmentInfo = [];
  List<Courses> allCourseInfo = [];
  List<Courses> enrollmentCourse = [];
  bool isHasEnrollmentData = false;

  @override
  void initState() {
    super.initState();
    getEnrollmentInfo();
    getEnrollmentCoursesData();
  }

  void initEnrollmentData() {
    allCourseInfo = [];
    enrollmentInfo = [];
    enrollmentCourse = [];
  }

  void getEnrollmentCoursesData() async {
    allCourseInfo = await DatabaseHelper.instance.getAllCoursesData();
    enrollmentInfo.forEach((enrollment_element) {
      allCourseInfo.forEach((element) {
        if (enrollment_element.course_id == element.id) {
          enrollmentCourse.add(element);
        }
      });
    });
    setState(() {
      if (!isHasEnrollmentData) {
        isHasEnrollmentData = !isHasEnrollmentData;
      }
    });
  }

  void getEnrollmentInfo() async {
    enrollmentInfo = await DatabaseHelper.instance.getEnrollmentDataByStudentID(widget.student_id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('當前選課清單', style: TextStyle(fontSize: 25)),
      ),
      body: !isHasEnrollmentData ?
      const Center(
        child: Text('當前無選課資料', style: TextStyle(fontSize: 25)),
      ) : enrollmentCourse.isNotEmpty ?
      ListView.builder(
        padding: const EdgeInsets.all(25),
        itemCount: enrollmentCourse.length,
        itemBuilder: (BuildContext context, int index) {
          return enrollmentCourseList(enrollmentCourse[index]);
        },
      ) : const Center(
        child: Text('當前無選課資料', style: TextStyle(fontSize: 25)),
      ),
    );
  }

  Widget enrollmentCourseList(Courses enrollmentCourse) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(5)
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.only(left: 20, right: 20),
            title: Text(enrollmentCourse.name, style: const TextStyle(fontSize: 23)),
            subtitle: Text(enrollmentCourse.time, style: const TextStyle(fontSize: 21)),
            trailing: IconButton(
              icon: const Icon(Icons.delete_forever, size: 40, color: Colors.red,),
              onPressed: () => showDeleteDialog(
                  context, enrollmentCourse.name, enrollmentCourse.id
              ),
            ),
          ),
        ),
        const SizedBox(height: 20)
      ],
    );
  }

  void showDeleteDialog(BuildContext context, String _course_name, String _course_id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('退選課程', style: TextStyle(fontSize: 23)),
          content: Text(
            '您確定要退選\n[ $_course_name ]\n這門課嗎？',
            style: const TextStyle(fontSize: 20),
          ),
          actions: [
            TextButton(
              child: const Text('取消', style: TextStyle(fontSize: 20)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('確認', style: TextStyle(fontSize: 20)),
              onPressed: () async {
                int res = await DatabaseHelper.instance.studentDeleteSelectCourse(
                    widget.student_id, _course_id
                );
                if (res > 0) {
                  Navigator.of(context).pop();
                  setState(() {
                    isHasEnrollmentData = false;
                  });
                  initEnrollmentData();
                  getEnrollmentInfo();
                  getEnrollmentCoursesData();
                  ScaffoldMessenger.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(
                        const SnackBar(
                            content: Text('退選課程成功')
                        )
                    );
                } else {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(
                        const SnackBar(
                            content: Text('退選課程失敗')
                        )
                    );
                }
              },
            ),
          ],
        );
      }
    );
  }

}