import 'package:flutter/material.dart';
import 'student/student-main-page.dart';
import 'database-helper/database-helper.dart';
import 'professor/professor-main-page.dart';

class LoginPage extends StatefulWidget {

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  bool isObscure = true;
  final TextEditingController accountController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    accountController.dispose();
  }

  @override
  Widget build (BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            style: const TextStyle(fontSize: 23),
            keyboardType: TextInputType.text,
            controller: accountController,
            decoration: const InputDecoration(
              hintText: '帳號',
              hintStyle: TextStyle(fontSize: 23),
              border: OutlineInputBorder()
            )
          ),
          const SizedBox(height: 20),
          TextField(
            style: const TextStyle(fontSize: 23),
            obscureText: isObscure,
            controller: passwordController,
            decoration: InputDecoration(
              hintText: '密碼',
              hintStyle: const TextStyle(fontSize: 23),
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: isObscure ?
                  const Icon(Icons.visibility) :
                  const Icon(Icons.visibility_off),
                onPressed: () {
                  setState(() {
                    isObscure = !isObscure;
                  });
                },
              )
            )
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                child: const Text(
                  '老師登入',
                  style: TextStyle(fontSize: 25),
                ),
                onPressed: () async {
                  bool isValidUser = await DatabaseHelper.instance.verifyUser(
                    'professor_table',
                    accountController.text, passwordController.text
                  );
                  if (isValidUser) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfessorMainPage(
                            professorID: accountController.text
                        )
                      )
                    );
                  } else {
                    ScaffoldMessenger.of(context)
                      ..removeCurrentSnackBar()
                      ..showSnackBar(
                          const SnackBar(
                              content: Text(
                                  '帳號密碼輸入有誤',
                                  style: TextStyle(fontSize: 23)
                              )
                          )
                      );
                  }
                },
              ),
              ElevatedButton(
                child: const Text(
                  '學生登入',
                  style: TextStyle(fontSize: 25),
                ),
                onPressed: () async {
                  bool isValidUser = await DatabaseHelper.instance.verifyUser(
                    'student_table',
                    accountController.text, passwordController.text
                  );
                  if (isValidUser) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StudentMainPage(
                          studentID: accountController.text
                        )
                      )
                    );
                  } else {
                    ScaffoldMessenger.of(context)
                      ..removeCurrentSnackBar()
                      ..showSnackBar(
                          const SnackBar(
                            content: Text(
                              '帳號密碼輸入有誤',
                              style: TextStyle(fontSize: 23)
                            )
                          )
                      );
                  }
                },
              )
            ],
          ),
          // dataBaseInfo.isNotEmpty ? Text(dataBaseInfo.toString()) : Text("NotData"),
          // ElevatedButton(
          //   child: const Text(
          //     '新增資料庫資料',
          //   ),
          //   onPressed: () async {
          //     Future<int> value = DatabaseHelper.instance.insertProfessor(newData);
          //   },
          // ),
          // ElevatedButton(
          //   child: const Text(
          //     '獲取資料庫資料',
          //   ),
          //   onPressed: () async {
          //     dataBaseInfo = await DatabaseHelper.instance.getAllProfessors();
          //     dataBaseInfo.forEach((element) {
          //       print(element.title);
          //     });
          //   },
          // )
        ],
      ),
    );
  }
}