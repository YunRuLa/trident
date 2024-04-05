import 'package:flutter/material.dart';
import 'package:trident/courses/courses.dart';
import 'package:trident/database-helper/database-helper.dart';

class ShowCourseList extends StatefulWidget {
  final Courses courses;
  final String student_id;

  ShowCourseList({
    super.key,
    required this.courses,
    required this.student_id
  });

  @override
  State<ShowCourseList> createState() => _ShowCourseList();
}

class _ShowCourseList extends State<ShowCourseList> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(5)
          ),
          child: ListTile(
              visualDensity: const VisualDensity(
                  horizontal: 0,
                  vertical: -4
              ),
              contentPadding: const EdgeInsets.only(left: 20, right: 20),
              title: Text(
                widget.courses.name,
                style: const TextStyle(
                    fontSize: 23
                ),
              ),
              subtitle: Text(
                widget.courses.time,
                style: const TextStyle(
                    fontSize: 21
                ),
              ),
              trailing: coursePopupMenuItem(widget.courses.id)
          ),
        ),
        const SizedBox(height: 20)
      ],
    );
  }

  void addSelectCourse(String course_id) async {
    int res = await DatabaseHelper.instance.studentAddSelectCourse(
        widget.student_id, course_id
    );
    if (res > 0) {
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
}