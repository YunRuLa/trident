import 'package:trident/courses/courses.dart';
import 'package:trident/enrollment/enrollment.dart';
import 'package:trident/professor/professor.dart';
import 'package:trident/student/student.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'interview-database.db');
    return await openDatabase(path, version: 1, onCreate: createDatabase);
  }

  Future<void> createDatabase(Database db, int version) async {
    await _createProfessorData(db);
    await _createStudentsData(db);
    await _createCoursesData(db);
    await _createEnrollment(db);
  }

  Future<void> _createProfessorData(Database db) async {
    await db.execute('''
      CREATE TABLE professor_table (
        professor_id TEXT PRIMARY KEY,
        name TEXT,
        title TEXT,
        account TEXT,
        password TEXT,
        image_path TEXT,
        show_course INTEGER
      )
    ''');
    Batch batch = db.batch();
    batch.insert('professor_table', {
      'professor_id': 'ROOT',
      'name': 'ROOT',
      'title': 'ROOT',
      'account': 'admin',
      'password': 'admin',
      'image_path': 'no-image-path',
      'show_course': 0,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
    batch.insert('professor_table', {
      'professor_id': 'P001',
      'name': 'Thomas Alva Edison',
      'title': 'Scientist',
      'account': 'P001',
      'password': 'P001',
      'image_path': 'assets/image/professor00.jpg',
      'show_course': 0,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
    batch.insert('professor_table', {
      'professor_id': 'P002',
      'name': 'Albert Einstein',
      'title': 'Physicist',
      'account': 'P002',
      'password': 'P002',
      'image_path': 'assets/image/professor01.jpg',
      'show_course': 0,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
    batch.insert('professor_table', {
      'professor_id': 'P002',
      'name': 'Albert Einstein',
      'title': 'Physicist',
      'account': 'P002',
      'password': 'P002',
      'image_path': 'assets/image/professor01.jpg',
      'show_course': 0,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
    batch.insert('professor_table', {
      'professor_id': 'P003',
      'name': 'Sir Isaac Newton',
      'title': 'Mathematician',
      'account': 'P003',
      'password': 'P003',
      'image_path': 'assets/image/professor02.jpg',
      'show_course': 0,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
    batch.insert('professor_table', {
      'professor_id': 'P004',
      'name': 'Maria Skłodowska-Curie',
      'title': 'Chemist',
      'account': 'P004',
      'password': 'P004',
      'image_path': 'assets/image/professor03.jpg',
      'show_course': 0,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
    batch.insert('professor_table', {
      'professor_id': 'P005',
      'name': 'Nikola Tesla',
      'title': 'Mechanical Engineers',
      'account': 'P005',
      'password': 'P005',
      'image_path': 'assets/image/professor04.jpg',
      'show_course': 0,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
    await batch.commit();
  }

  Future<void> _createStudentsData(Database db) async {
    await db.execute('''
      CREATE TABLE student_table (
        id TEXT PRIMARY KEY,
        name TEXT,
        account TEXT,
        password TEXT
      )
    ''');
    Batch batch = db.batch();
    batch.insert('student_table', {
      'id': 'S001',
      'name': '王小美',
      'account': 'S001',
      'password': 'S001'
    });
    batch.insert('student_table', {
      'id': 'S002',
      'name': '蘇曉波',
      'account': 'S002',
      'password': 'S002'
    });
    batch.insert('student_table', {
      'id': 'S003',
      'name': '陳慧美',
      'account': 'S003',
      'password': 'S003'
    });
    batch.insert('student_table', {
      'id': 'S004',
      'name': '王曉波',
      'account': 'S004',
      'password': 'S004'
    });
    await batch.commit();
  }

  Future<void> _createCoursesData(Database db) async {
    await db.execute('''
      CREATE TABLE course_table (
        id TEXT PRIMARY KEY,
        name TEXT,
        time TEXT,
        intro TEXT,
        professor_id TEXT,
        FOREIGN KEY (professor_id) REFERENCES professor_table (professor_id)
      )
    ''');
    Batch batch = db.batch();
    batch.insert('course_table', {
      'id': 'C001',
      'name': '光電概論',
      'time': '週四, 0900 ~ 1200',
      'intro': '進一步深入光電子學領域，探討光學概念、光電器件設計及應用案例。',
      'professor_id': 'P001'
    });
    batch.insert('course_table', {
      'id': 'C002',
      'name': '電學概論',
      'time': '週四, 0900 ~ 1200',
      'intro': '介紹電學的基本概念、電場、電位、電場分析方法和應用。',
      'professor_id': 'P001'
    });
    batch.insert('course_table', {
      'id': 'C003',
      'name': '相對論',
      'time': '週三, 0900 ~ 1200',
      'intro': '探討相對論的基本概念、洛倫茲變換、時空四維等相對論基礎知識。',
      'professor_id': 'P002'
    });
    batch.insert('course_table', {
      'id': 'C004',
      'name': '量子力學',
      'time': '週五, 1300 ~ 1500',
      'intro': '介紹量子物理學的基本原理、波粒二象性、量子力學中的算符和波函數。',
      'professor_id': 'P002'
    });
    batch.insert('course_table', {
      'id': 'C005',
      'name': '線性代數',
      'time': '週一, 0900 ~ 1200',
      'intro': '學習向量、矩陣、線性方程組等線性代數基礎知識和運算技巧。',
      'professor_id': 'P003'
    });
    batch.insert('course_table', {
      'id': 'C006',
      'name': '微積分',
      'time': '週四, 1300 ~ 1500',
      'intro': '探討微分、積分、極限等微積分的基本概念和計算方法。',
      'professor_id': 'P003'
    });
    batch.insert('course_table', {
      'id': 'C007',
      'name': '化工材料概論',
      'time': '週一, 1300 ~ 1600',
      'intro': '介紹化工材料的種類、性質、製備方法和應用範圍。',
      'professor_id': 'P004'
    });
    batch.insert('course_table', {
      'id': 'C008',
      'name': '危險化學實驗',
      'time': '週五, 1300 ~ 1600',
      'intro': '學習化學實驗室中的安全操作、危險品處理和實驗技術。',
      'professor_id': 'P004'
    });
    batch.insert('course_table', {
      'id': 'C009',
      'name': '交流電學概論',
      'time': '週二, 0900 ~ 1200',
      'intro': '探討交流電路中的基本概念、分析方法和應用案例。',
      'professor_id': 'P005'
    });
    batch.insert('course_table', {
      'id': 'C010',
      'name': '無線通訊概論',
      'time': '週三, 1300 ~ 1500',
      'intro': '介紹無線通訊的基本原理、技術和應用領域。',
      'professor_id': 'P005'
    });
    await batch.commit();
  }

  Future<void> _createEnrollment(Database db) async {
    await db.execute('''
      CREATE TABLE enrollment_table (
        id TEXT PRIMARY KEY,
        student_id TEXT,
        course_id TEXT,
        FOREIGN KEY (student_id) REFERENCES student_table (id),
        FOREIGN KEY (course_id) REFERENCES course_table (id)
      )
    ''');
    Batch batch = db.batch();
    batch.insert('enrollment_table', {
      'id': 'E001',
      'course_id': 'C001',
      'student_id': 'S001'
    });
    batch.insert('enrollment_table', {
      'id': 'E002',
      'course_id': 'C001',
      'student_id': 'S003'
    });
    batch.insert('enrollment_table', {
      'id': 'E003',
      'course_id': 'C001',
      'student_id': 'S004'
    });
    batch.insert('enrollment_table', {
      'id': 'E004',
      'course_id': 'C002',
      'student_id': 'S002'
    });
    batch.insert('enrollment_table', {
      'id': 'E005',
      'course_id': 'C002',
      'student_id': 'S004'
    });
    batch.insert('enrollment_table', {
      'id': 'E006',
      'course_id': 'C003',
      'student_id': 'S001'
    });
    batch.insert('enrollment_table', {
      'id': 'E007',
      'course_id': 'C003',
      'student_id': 'S003'
    });
    batch.insert('enrollment_table', {
      'id': 'E008',
      'course_id': 'C004',
      'student_id': 'S001'
    });
    batch.insert('enrollment_table', {
      'id': 'E009',
      'course_id': 'C004',
      'student_id': 'S002'
    });
    batch.insert('enrollment_table', {
      'id': 'E010',
      'course_id': 'C004',
      'student_id': 'S003'
    });
    batch.insert('enrollment_table', {
      'id': 'E011',
      'course_id': 'C004',
      'student_id': 'S004'
    });
    await batch.commit();
  }

  Future<bool> verifyUser(String tableName, String account, String password) async {
    Database db = await instance.database;
    var res = await db.query(
        tableName,
        where: 'account = ? AND password = ?',
        whereArgs: [account, password]
    );
    return res.isNotEmpty;
  }

  Future<List<Students>> getAllStudentsData() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query('student_table');
    return List.generate(maps.length, (i) {
      return Students.fromMap(maps[i]);
    });
  }

  Future<int> insertStudent(Students student) async {
    Database db = await instance.database;
    return await db.insert('student_table', student.toMap());
  }

  Future<List<Professor>> getAllProfessorData() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query('professor_table');
    return List.generate(maps.length, (i) {
      return Professor.fromMap(maps[i]);
    });
  }

  Future<int> insertProfessor(Professor professor) async {
    Database db = await instance.database;
    return await db.insert('professor_table', professor.toMap());
  }

  Future<List<Courses>> getAllCoursesData() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query('course_table');
    return List.generate(maps.length, (i) {
      return Courses.fromMap(maps[i]);
    });
  }

  Future<int> insertCourse(Courses course) async {
    Database db = await instance.database;
    return await db.insert('course_table', course.toMap());
  }

  Future<List<Enrollment>> getAllEnrollmentData() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query('enrollment_table');
    return List.generate(maps.length, (i) {
      return Enrollment.fromMap(maps[i]);
    });
  }

  Future<List<Enrollment>> getEnrollmentDataByCourseID(String courseID) async {
    Database db = await instance.database;
    var res = await db.query(
      'enrollment_table',
      where: 'course_id = ?',
      whereArgs: [courseID]
    );
    return List.generate(res.length, (i) {
      return Enrollment.fromMap(res[i]);
    });
  }

  Future<List<Enrollment>> getEnrollmentDataByStudentID(String student_id) async {
    Database db = await instance.database;
    var res = await db.query(
      'enrollment_table',
      where: 'student_id=?',
      whereArgs: [student_id]
    );
    return List.generate(res.length, (i) {
      return Enrollment.fromMap(res[i]);
    });
  }

  Future<int> addProfessorCourse(Courses course) async {
    Database db = await instance.database;
    return await db.insert('course_table', course.toMap());
  }

  Future<int> deleteProfessorCourse(String courseID, String professorID) async {
    Database db = await instance.database;
    return await db.delete(
      'course_table',
      where: 'id = ? AND professor_id = ?',
      whereArgs: [courseID, professorID],
    );
  }

  Future<int> editProfessorCourse(
        String courseID, String professorID,
        String courseName, String courseTime, String courseIntro
      ) async {
    Database db = await instance.database;
    Map<String, dynamic> rows = {
      'name': courseName,
      'time': courseTime,
      'intro': courseIntro
    };
    return await db.update(
      'course_table',
      rows,
      where: 'id = ? AND professor_id = ?',
      whereArgs: [courseID, professorID],
    );
  }

  Future<int> studentAddSelectCourse(String student_id, String course_id) async {
    Database db = await instance.database;
    var repeat = await db.query(
      'enrollment_table',
      where: 'course_id = ? AND student_id = ?',
      whereArgs: [course_id, student_id]
    );
    if (repeat.isNotEmpty) {
      return 0;
    } else {
      var res = await db.query('enrollment_table');
      var temp = List.generate(res.length, (i) {
        return Enrollment.fromMap(res[i]);
      });
      String newID = 'E${(int.parse(
          temp[res.length - 1].id.substring(1)
        ) + 1).toString().padLeft(3, '0')}';
      Enrollment rows = Enrollment(id: newID, student_id: student_id, course_id: course_id);
      return await db.insert(
          'enrollment_table',
          rows.toMap()
      );
    }
  }

  Future<int> studentDeleteSelectCourse(String student_id, String course_id) async {
    Database db = await instance.database;
    try {
      var res = await db.delete(
          'enrollment_table',
          where: 'course_id = ? AND student_id = ?',
          whereArgs: [course_id, student_id]
      );
      return res;
    } catch (e) {
      return -1;
    }
  }
}