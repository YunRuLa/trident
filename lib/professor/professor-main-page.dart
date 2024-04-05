import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:trident/courses/courses.dart';
import 'package:trident/database-helper/database-helper.dart';
import 'professor-show-list-of-selected-student.dart';

class ProfessorMainPage extends StatefulWidget {
  final String professorID;

  const ProfessorMainPage({
    super.key,
    required this.professorID
  });

  @override
  State<ProfessorMainPage> createState() => _ProfessorMainPage();
}

Future<int> addCourse(List<Courses> allCourse, String professorId, String title, String time, String content) async {
  String newID = 'P${(int.parse(
    allCourse[allCourse.length - 1].id.substring(1)
  ) + 1).toString().padLeft(3, '0')}';
  final int res = await DatabaseHelper.instance.addProfessorCourse(
    Courses(
      id: newID,
      name: title,
      time: time,
      intro: content,
      professor_id: professorId
    )
  );
  return res;
}

class _ProfessorMainPage extends State<ProfessorMainPage> with SingleTickerProviderStateMixin {

  List<Courses> coursesInfo = [];
  bool isHasCourses = false;
  late AnimationController _controller;
  List<IconData> icons = [
    Icons.add, Icons.account_circle
  ];
  List<String> floatingButtonText = [
    '新增課程', '查看個人資料'
  ];

  @override
  void initState() {
    super.initState();
    getCoursesData();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this
    );
  }

  @override
  Widget build (BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text('教師授課清單', style: TextStyle(fontSize: 25)),
      ),
      body: isHasCourses ?
      ListView.builder(
          itemCount: coursesInfo.length,
          itemBuilder: (BuildContext context, int index) {
            return courseBoxWidget(coursesInfo[index]);
          }) : const Text('當前沒有授課清單資料'),
      floatingActionButton: floatingButtonColumn(),
    );
  }

  void getCoursesData() async {
    coursesInfo = await DatabaseHelper.instance.getAllCoursesData();
    setState(() {
      if (!isHasCourses) {
        isHasCourses = !isHasCourses;
      }
    });
  }

  _showEditCourseDialog(BuildContext context, Courses course) {
    TextEditingController courseTitle = TextEditingController(text: course.name);
    TextEditingController courseTime = TextEditingController(text: course.time);
    TextEditingController courseContent = TextEditingController(text: course.intro);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('課程內容編輯', style: TextStyle(fontSize: 23)),
          content: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Text('課程標題', style: TextStyle(fontSize: 22)),
                  const SizedBox(height: 10),
                  TextField(
                    style: const TextStyle(fontSize: 21),
                    controller: courseTitle,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      border: OutlineInputBorder(),
                      hintText: '課程標題'
                    )
                  ),
                  const SizedBox(height: 10),
                  const Text('課程時間', style: TextStyle(fontSize: 22)),
                  const SizedBox(height: 10),
                  TextField(
                    style: const TextStyle(fontSize: 21),
                    controller: courseTime,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      border: OutlineInputBorder(),
                      hintText: '課程時間'
                    )
                  ),
                  const SizedBox(height: 10),
                  const Text('課程內容', style: TextStyle(fontSize: 22)),
                  const SizedBox(height: 10),
                  TextField(
                    style: const TextStyle(fontSize: 21),
                    controller: courseContent,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: '課程標題'
                    )
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              child: const Text('取消', style: TextStyle(fontSize: 20)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('修改', style: TextStyle(fontSize: 20)),
              onPressed: () async {
                int res = await DatabaseHelper.instance.editProfessorCourse(
                    course.id, widget.professorID,
                    courseTitle.text, courseTime.text, courseContent.text
                );
                if (res > 0) {
                  Navigator.of(context).pop();
                  setState(() {
                    isHasCourses = !isHasCourses;
                  });
                  getCoursesData();
                } else {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(
                        const SnackBar(
                            content: Text('更新課程失敗')
                        )
                    );
                }
              },
            )
          ],
        );
      }
    );
  }

  _showDeleteCourseDialog(BuildContext context, String _courseName, String _courseID) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('刪除課程', style: TextStyle(fontSize: 23)),
          content: Text(
            '您確定要刪除\n[ $_courseName ]\n這門課程嗎？',
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
              child: const Text('確定', style: TextStyle(fontSize: 20)),
              onPressed: () async {
                int res = await DatabaseHelper.instance.deleteProfessorCourse(
                    _courseID, widget.professorID);
                if (res > 0) {
                  Navigator.of(context).pop();
                  setState(() {
                    isHasCourses = false;
                  });
                  getCoursesData();
                } else {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(
                        const SnackBar(
                            content: Text('刪除課程失敗')
                        )
                    );
                }
              },
            )
          ],
        );
      }
    );
  }

  Widget courseBoxWidget(Courses course) {
    if (course.professor_id == widget.professorID) {
      return Container(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(5)
          ),
          child: ListTile(
            title: Text(course.name, style: const TextStyle(fontSize: 23)),
            subtitle: Text(course.time, style: const TextStyle(fontSize: 23)),
            trailing: PopupMenuButton(
              color: Colors.white,
              icon: const Icon(Icons.more_vert, size: 30),
              onSelected: (String result) {
                switch (result) {
                  case 'students':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ShowSelectedStudent(
                          course: course,
                        )
                      )
                    );
                    break;
                  case 'edit':
                    _showEditCourseDialog(context, course);
                    break;
                  case 'delete':
                    _showDeleteCourseDialog(context, course.name, course.id);
                    break;
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'students',
                  child: Text('查詢選課學生清單', style: TextStyle(fontSize: 20)),
                ),
                const PopupMenuItem<String>(
                  value: 'edit',
                  child: Text('編輯課程內容', style: TextStyle(fontSize: 20)),
                ),
                const PopupMenuItem<String>(
                  value: 'delete',
                  child: Text('刪除課程', style: TextStyle(fontSize: 20)),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget floatingButtonColumn() {
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
                    const Text(
                        '新增課程',
                        style: TextStyle(fontSize: 20)
                    ),
                    const SizedBox(width: 20),
                    FloatingActionButton(
                      heroTag: 'addCourse',
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.purple,
                      shape: const CircleBorder(),
                      onPressed: () => showAddCourseDialog(context),
                      child: const Icon(Icons.add),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                        '查看個人資料',
                        style: TextStyle(fontSize: 20)
                    ),
                    const SizedBox(width: 20),
                    FloatingActionButton(
                      heroTag: 'viewPersonalInfo',
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.purple,
                      shape: const CircleBorder(),
                      child: const Icon(Icons.account_circle),
                      onPressed: () {},
                    )
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton(
                  heroTag: 'showAnimate',
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.purple,
                  shape: const CircleBorder(),
                  child: const Icon(Icons.arrow_upward_outlined),
                  onPressed: () {
                    if (_controller.isDismissed) {
                      _controller.forward();
                    } else {
                      _controller.reverse();
                    }
                  },
                )
              ],
            )
        ],
    );
  }

  void showAddCourseDialog(BuildContext context) {
    TextEditingController courseName = TextEditingController();
    TextEditingController courseTime = TextEditingController();
    TextEditingController courseIntro = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('新增課程', style: TextStyle(fontSize: 25)),
          content: SingleChildScrollView(
            child: Column(
              children: [
                const Text('課程標題', style: TextStyle(fontSize: 22)),
                const SizedBox(height: 10),
                TextField(
                    style: const TextStyle(fontSize: 21),
                    controller: courseName,
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        border: OutlineInputBorder(),
                        hintText: '課程標題'
                    )
                ),
                const SizedBox(height: 10),
                const Text('課程時間', style: TextStyle(fontSize: 22)),
                const SizedBox(height: 10),
                TextField(
                    style: const TextStyle(fontSize: 21),
                    controller: courseTime,
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        border: OutlineInputBorder(),
                        hintText: '課程時間'
                    )
                ),
                const SizedBox(height: 10),
                const Text('課程內容', style: TextStyle(fontSize: 22)),
                const SizedBox(height: 10),
                TextField(
                    style: const TextStyle(fontSize: 21),
                    controller: courseIntro,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: '課程標題'
                    )
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("取消", style: TextStyle(fontSize: 21)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("新增", style: TextStyle(fontSize: 21)),
              onPressed: () async {
                int res = await addCourse(
                    coursesInfo,
                    widget.professorID,
                    courseName.text,
                    courseTime.text,
                    courseIntro.text
                );
                if (res > 0) {
                  Navigator.of(context).pop();
                  setState(() {
                    isHasCourses = !isHasCourses;
                  });
                  getCoursesData();
                } else {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(
                        const SnackBar(
                            content: Text('新增課程失敗')
                        )
                    );
                }
              },
            )
          ],
        );
      },
    );
  }
}