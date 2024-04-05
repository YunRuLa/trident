import 'package:flutter/material.dart';
import 'package:trident/professor/professor.dart';
import 'package:trident/courses/courses.dart';
import 'package:trident/database-helper/database-helper.dart';

class ShowProfessorList extends StatefulWidget {
  final Professor professor;
  final String student_id;

  const ShowProfessorList({
    super.key,
    required this.professor,
    required this.student_id
  });

  @override
  State<ShowProfessorList> createState() => _ShowProfessorList();
}

class _ShowProfessorList  extends State<ShowProfessorList> {
  List<Courses> allCourses = [];
  List<Courses> courses = [];
  bool isGetCourses = false;

  @override
  void initState() {
    super.initState();
    getProfessorCourses();
  }

  void getProfessorCourses() async {
    allCourses = [];
    courses = [];
    allCourses = await DatabaseHelper.instance.getAllCoursesData();
    allCourses.forEach((element) {
      if (element.professor_id == widget.professor.professorId) {
        courses.add(element);
      }
    });
    setState(() {
      if (!isGetCourses) {
        isGetCourses = !isGetCourses;
      }
    });
  }

  @override
  Widget build(BuildContext context){
    return Column(
      children: [
        Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(5)
            ),
            child: !widget.professor.showCourse ?
            ListTile(
              visualDensity: const VisualDensity(
                  horizontal: 0,
                  vertical: -4
              ),
              contentPadding: const EdgeInsets.only(left: 20, right: 20),
              leading: CircleAvatar(
                backgroundImage: AssetImage(widget.professor.imagePath),
              ),
              title: Text(
                widget.professor.title,
                style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 18
                ),
              ),
              subtitle: Text(
                widget.professor.name,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20
                ),
              ),
              trailing: IconButton(
                onPressed: () {
                  setState(() {
                    widget.professor.showCourse = !widget.professor.showCourse;
                  });
                },
                icon: const Icon(Icons.add),
              ),
            ) :
            Column(
              children: <Widget>[
                ListTile(
                  visualDensity: const VisualDensity(
                      horizontal: 0,
                      vertical: -4
                  ),
                  contentPadding: const EdgeInsets.only(
                      left: 20,
                      top: 10,
                      right: 20,
                      bottom: 10
                  ),
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(widget.professor.imagePath),
                  ),
                  title: Text(
                    widget.professor.title,
                    style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 18
                    ),
                  ),
                  subtitle: Text(
                    widget.professor.name,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20
                    ),
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      setState(() {
                        widget.professor.showCourse = !widget.professor.showCourse;
                      });
                    },
                    icon: const Icon(Icons.add),
                  ),
                ),
                const Divider(
                  thickness: 2,
                  endIndent: 20,
                  indent: 20,
                ),
                !isGetCourses ? Container(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: const Text('該教授尚無課程', style: TextStyle(fontSize: 23)),
                ) : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: courses.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      contentPadding: const EdgeInsets.only(left: 20, right: 20),
                      leading: const Icon(Icons.calendar_month_outlined),
                      title: Text(courses[index].name),
                      subtitle: Text(courses[index].time),
                      trailing: coursePopupMenuItem(courses[index].id),
                    );
                  },
                )
              ],
            )
        ),
        const SizedBox(height: 20)
      ],
    );
  }

  Widget coursePopupMenuItem(String course_id) {
    return PopupMenuButton(
      icon: const Icon(Icons.keyboard_arrow_right),
      onSelected: (String result){
        switch (result) {
          case 'select':
            addSelectCourse(course_id);
            break;
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>> [
        const PopupMenuItem<String>(
          value: 'select',
          child: Text('加選該門課程', style: TextStyle(fontSize: 20)),
        ),
      ],
    );
  }

  void addSelectCourse(String course_id) async {
    int res = await DatabaseHelper.instance.studentAddSelectCourse(
      widget.student_id, course_id
    );
    if (res > 0) {
      setState(() {
        isGetCourses = false;
      });
      getProfessorCourses();
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(
            const SnackBar(
                content: Text('加選課程成功')
            )
        );
    } else {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(
            const SnackBar(
                content: Text('加選課程錯誤，您擁有該門選課')
            )
        );
    }
  }
}