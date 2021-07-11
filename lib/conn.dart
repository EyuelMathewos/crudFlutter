import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'model.dart';

class DBHelper {
  static Database _db;
  static const String ID = 'id';
  static const String NAME = 'name';
  static const String COURSE = 'course';
  static const String TABLE = 'Student';
  static const String DB_NAME = 'student.db';

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $TABLE ($ID INTEGER PRIMARY KEY, $NAME TEXT, $COURSE TEXT)");
  }

  Future<Student> save(Student student) async {
    var dbClient = await db;
    student.id = await dbClient.insert(TABLE, student.toMap());
    return student;
    /*
    await dbClient.transaction((txn) async {
      var query = "INSERT INTO $TABLE ($NAME) VALUES ('" + employee.name + "')";
      return await txn.rawInsert(query);
    });
    */
  }

  Future<List<Student>> getStudents() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(TABLE, columns: [ID, NAME, COURSE]);
    //List<Map> maps = await dbClient.rawQuery("SELECT * FROM $TABLE");
    List<Student> students = [];
    return List.generate(maps.length, (i) {
      return Student(
          id: maps[i]['id'], name: maps[i]['name'], course: maps[i]['course']);
    });
  }

  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient.delete(TABLE, where: '$ID = ?', whereArgs: [id]);
  }

  Future<int> update(Student student) async {
    var dbClient = await db;
    return await dbClient.update(TABLE, student.toMap(),
        where: '$ID = ?', whereArgs: [student.id]);
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
