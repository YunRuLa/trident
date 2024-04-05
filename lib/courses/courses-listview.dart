import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// class Courses {
//   String courseName;
//   String courseTime;
//   String content;
//
//   Courses({
//     required this.courseName,
//     required this.courseTime,
//     required this.content
//   });
//
//   static Courses getCoursesByIndex(String id) {
//     switch (id) {
//       case 'LEB001':
//         return Courses(
//           courseName: '光電概論',
//           courseTime: '週四, 0900 ~ 1200',
//           content: '進一步深入光電子學領域，探討光學概念、光電器件設計及應用案例。'
//         );
//       case 'EB0001':
//         return Courses(
//             courseName: '電學概論',
//             courseTime: '週四, 0900 ~ 1200',
//             content: '介紹電學的基本概念、電場、電位、電場分析方法和應用。'
//         );
//       case 'RE0001':
//         return Courses(
//             courseName: '相對論',
//             courseTime: '週三, 0900 ~ 1200',
//             content: '探討相對論的基本概念、洛倫茲變換、時空四維等相對論基礎知識。'
//         );
//       case 'QUT001':
//         return Courses(
//             courseName: '量子力學',
//             courseTime: '週五, 1300 ~ 1500',
//             content: '介紹量子物理學的基本原理、波粒二象性、量子力學中的算符和波函數。'
//         );
//       case 'LA0001':
//         return Courses(
//             courseName: '線性代數',
//             courseTime: '週一, 0900 ~ 1200',
//             content: '學習向量、矩陣、線性方程組等線性代數基礎知識和運算技巧。'
//         );
//       case 'CAL001':
//         return Courses(
//             courseName: '微積分',
//             courseTime: '週四, 1300 ~ 1500',
//             content: '探討微分、積分、極限等微積分的基本概念和計算方法。'
//         );
//       case 'ICM001':
//         return Courses(
//             courseName: '化工材料概論',
//             courseTime: '週一, 1300 ~ 1600',
//             content: '介紹化工材料的種類、性質、製備方法和應用範圍。'
//         );
//       case 'HCE001':
//         return Courses(
//             courseName: '危險化學實驗',
//             courseTime: '週五, 1300 ~ 1600',
//             content: '學習化學實驗室中的安全操作、危險品處理和實驗技術。'
//         );
//       case 'ACE001':
//         return Courses(
//             courseName: '交流電學概論',
//             courseTime: '週二, 0900 ~ 1200',
//             content: '探討交流電路中的基本概念、分析方法和應用案例。'
//         );
//       case 'IWC001':
//         return Courses(
//             courseName: '無線通訊概論',
//             courseTime: '週三, 1300 ~ 1500',
//             content: '介紹無線通訊的基本原理、技術和應用領域。'
//         );
//       default:
//         return Courses(
//             courseName: '無法取得課程標題',
//             courseTime: '無法取得課程時間',
//             content: '尚無課程內容'
//         );
//     }
//   }
// }

// class CourseView extends StatefulWidget {
//   final String instructor;
//   final String instructorImagePath;
//   final String courseID;
//   final String courseName;
//   final String courseTime;
//
//   const CourseView({
//     super.key,
//     required this.instructor,
//     required this.instructorImagePath,
//     required this.courseID,
//     required this.courseName,
//     required this.courseTime
//   });
//
//   @override
//   State<CourseView> createState() => _CourseView();
// }

// class _CourseView extends State<CourseView> {
//   late Courses course;
//
//   @override
//   void initState() {
//     super.initState();
//     course = Courses.getCoursesByIndex(widget.courseID);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         title: const Text(
//             '課程內容',
//             style: TextStyle(
//                 fontSize: 30,
//                 fontWeight: FontWeight.bold
//             )
//         ),
//       ),
//       body: SafeArea(
//         child: Column(
//           children: [
//             Flexible(
//               flex: 3,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   Flexible(
//                     flex: 1,
//                     child: Image.asset(
//                       widget.instructorImagePath,
//                       width: 100,
//                     ),
//                   ),
//                   Expanded(
//                     flex: 2,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: <Widget>[
//                         Text(
//                           '課程名稱：${widget.courseName}',
//                           softWrap: true,
//                           style: const TextStyle(fontSize: 23),
//                         ),
//                         Text(
//                           '授課教授：${widget.instructor}',
//                           softWrap: true,
//                           style: const TextStyle(fontSize: 23),
//                         ),
//                         Text(
//                           '開課時間：${widget.courseTime}',
//                           softWrap: true,
//                           style: const TextStyle(fontSize: 23),
//                         )
//                       ],
//                     )
//                   )
//                 ],
//               ),
//             ),
//             Flexible(
//               flex: 5,
//               child: Container(
//                 padding: const EdgeInsets.only(left: 10, right: 10),
//                 child: Text(
//                   '課程說明：${course.content}',
//                   style: const TextStyle(
//                     fontSize: 23
//                   ),
//                 ),
//               ),
//             )
//           ],
//         ),
//       )
//     );
//   }
// }