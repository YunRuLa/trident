import 'package:flutter/material.dart';
import 'package:trident/professor/professor.dart';
import 'package:trident/courses/courses.dart';
import 'package:trident/database-helper/database-helper.dart';
import 'package:trident/student/student-show-enrollment-list.dart';
// view
import 'student-show-professor-list.dart';
import 'student-show-course-list.dart';

class StudentMainPage extends StatefulWidget {
  final String studentID;

  const StudentMainPage({
    super.key,
    required this.studentID
  });

  @override
  State<StudentMainPage> createState() => _StudentMainPage();
}

class _StudentMainPage extends State<StudentMainPage> with SingleTickerProviderStateMixin {
  // 獲取資料庫資料及狀態
  List<Professor> professorInfo = [];
  List<Courses> courseInfo = [];
  bool isHasProfessor = false;
  bool isHasCourses = false;
  // 控制畫面
  bool changeFloatingButtonIcon = true;
  bool controlListContent = true;
  // 動畫控制
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _getAllProfessorInfo();
    _getAllCourseInfo();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 200),
        vsync: this
    );
  }

  void _getAllProfessorInfo() async {
    professorInfo = await DatabaseHelper.instance.getAllProfessorData();
    professorInfo.removeAt(0);
    setState(() {
      if (!isHasProfessor) {
        isHasProfessor = !isHasProfessor;
      }
    });
  }

  void _getAllCourseInfo() async {
    courseInfo = await DatabaseHelper.instance.getAllCoursesData();
    setState(() {
      if (!isHasCourses) {
        isHasCourses = !isHasCourses;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: controlListContent ?
        const Text('授課教師清單', style: TextStyle(fontSize: 25)) :
        const Text('開設課程清單', style: TextStyle(fontSize: 25)) ,
      ),
      body: !isHasProfessor ?
      const Center(
        child: Text('無法取得資料', style: TextStyle(fontSize: 25)),
      ) : controlListContent ?
        ListView.builder(
          padding: const EdgeInsets.all(25),
          itemCount: professorInfo.length,
          itemBuilder: (BuildContext context, int index) {
            return ShowProfessorList(
              professor: professorInfo[index],
              student_id: widget.studentID
            );
          },
      ) : ListView.builder(
        padding: const EdgeInsets.all(25),
        itemCount: courseInfo.length,
        itemBuilder: (BuildContext context, int index) {
          return ShowCourseList(
            courses: courseInfo[index],
            student_id: widget.studentID,
          );
        },
      ),
      floatingActionButton: floatingActionButtonWidget()
    );
  }

  Widget floatingActionButtonWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizeTransition(
          axisAlignment: 2.0,
          axis: Axis.horizontal,
          sizeFactor: Tween(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
              parent: _controller,
              curve: Curves.easeOut
            )
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  controlListContent ? const Text(
                    '查詢開課清單',
                    style: TextStyle(fontSize: 20),
                  ) : const Text(
                    '查看教師清單',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(width: 20),
                  FloatingActionButton(
                    heroTag: 'courseList',
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.purple,
                    shape: const CircleBorder(),
                    onPressed: () {
                      setState(() {
                        controlListContent = !controlListContent;
                      });
                    },
                    child: controlListContent ?
                    const Icon(Icons.list_alt_outlined) :
                    const Icon(Icons.account_box_outlined),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    '查看個人選課清單',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(width: 20),
                  FloatingActionButton(
                    heroTag: 'checkEnrollmentList',
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.purple,
                    shape: const CircleBorder(),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ShowEnrollmentList(student_id: widget.studentID)
                        )
                      );
                    },
                    child: const Icon(Icons.format_list_bulleted_outlined),
                  )
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
        FloatingActionButton(
          heroTag: 'showFeature',
          foregroundColor: Colors.white,
          backgroundColor: Colors.purple,
          shape: const CircleBorder(),
          onPressed: () {
            if (_controller.isDismissed) {
              _controller.forward();
            } else {
              _controller.reverse();
            }
            setState(() {
              changeFloatingButtonIcon = !changeFloatingButtonIcon;
            });
          },
          child: changeFloatingButtonIcon ?
            const Icon(Icons.arrow_upward_outlined) : 
            const Icon(Icons.arrow_downward_outlined),
        )
      ],
    );
  }
}