import 'package:flutter/material.dart';
import 'professor.dart';
import 'package:trident/courses/courses.dart';
import 'package:trident/database-helper/database-helper.dart';

class ProfessorListView extends StatefulWidget {
  final Professor professor;

  const ProfessorListView({super.key, required this.professor});

  @override
  State<ProfessorListView> createState() => _ProfessorListView();
}

class _ProfessorListView  extends State<ProfessorListView> {
  List<Courses> allCourses = [];
  List<Courses> courses = [];
  bool isGetCourses = false;

  @override
  void initState() {
    super.initState();
    getProfessorCourses();
  }

  void getProfessorCourses() async {
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
                        trailing: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.keyboard_arrow_right),
                        ),
                      );
                    },
                  )
                // ListView.builder(
                //   shrinkWrap: true,
                //   physics: const NeverScrollableScrollPhysics(),
                //   itemCount: widget.professor.courses.length,
                //   itemBuilder: (context, int index) {
                //     return  ListTile(
                //       contentPadding: const EdgeInsets.only(left: 20, right: 20),
                //       leading: const Icon(Icons.calendar_month_outlined),
                //       title: Text(widget.professor.courses[index]["name"]!),
                //       subtitle: Text(widget.professor.courses[index]["time"]!),
                //       trailing: IconButton(
                //         onPressed: () {
                //           Navigator.of(context).push(
                //               MaterialPageRoute(
                //                   builder: (context) {
                //                     return CourseView(
                //                       instructor: widget.professor.name,
                //                       instructorImagePath: widget.professor.imgPath,
                //                       courseID: widget.professor.courses[index]['id']!,
                //                       courseName: widget.professor.courses[index]['name']!,
                //                       courseTime: widget.professor.courses[index]['time']!,
                //                     );
                //                   }
                //               )
                //           );
                //         },
                //         icon: const Icon(Icons.keyboard_arrow_right),
                //       ),
                //     );
                //   },
                // )
              ],
            )
        ),
        const SizedBox(height: 20)
      ],
    );
  }
}