import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'package:trident/database-helper/database-helper.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('Trident Unit Tests:', () {
    late Database db;
    late DatabaseHelper helper;

    setUp(() async {
      String dbPath = p.join(await getDatabasesPath(), 'test.db');
      db = await openDatabase(
          dbPath, version: 1, onCreate: DatabaseHelper.instance.createDatabase
      );
      helper = DatabaseHelper.instance;
    });

    tearDown(() async {
      await db.close();
    });

    test('測試獲取授課講師列表，如果[成功]會回傳列表，列表的長度 > 0', () async {
      var result = await helper.getAllProfessorData();
      expect(result.length, greaterThan(0));
    });
    test('測試獲取課程列表，如果[成功]會回傳列表，列表的長度 > 0', () async {
      var result = await helper.getAllCoursesData();
      expect(result.length, greaterThan(0));
    });
    test('測試授課教師開設課程列表，如果[成功]會回傳列表，列表的長度 > 0', () async {
      var result = await helper.getProfessorOpenCourse('P001');
      expect(result.length, greaterThan(0));
    });
    test('測試更新課程內容，如果[成功]會回傳，更新時的列表的長度 > 0', () async {
      var result = await helper.editProfessorCourse(
          'C010', 'P005', '無線通訊概論TEST', 'Mon. 0800 ~ 1200', '介紹無線通訊的基本原理、技術和應用領域。'
      );
      expect(result, greaterThan(0));
    });
    test('測試更新課程內容，如果[失敗]會回傳 0', () async {
      var result = await helper.editProfessorCourse(
          '0', '0', '無線通訊概論TEST', 'Mon. 0800 ~ 1200', '介紹無線通訊的基本原理、技術和應用領域。'
      );
      expect(result, equals(0));
    });
    test('測試新增教師，如果[成功]會回傳 > 0', () async {
      var result = await helper.addNewProfessor(
        'test', 'testsubtitle', 'testuser', 'user123', 'iamgePath'
      );
      expect(result, greaterThan(0));
    });
  });
}