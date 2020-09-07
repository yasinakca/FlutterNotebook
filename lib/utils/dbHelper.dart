import 'dart:io';
import 'package:flutter/services.dart';
import 'package:notebook/models/category.dart';
import 'package:notebook/models/note.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static DbHelper dbHelper;
  static Database db;

  DbHelper.internal();

  factory DbHelper() {
    if (dbHelper == null) {
      dbHelper = DbHelper.internal();
      return dbHelper;
    } else {
      return dbHelper;
    }
  }

  Future<Database> getDb() async {
    if (db == null) {
      db = await initializeDb();
      return db;
    } else {
      return db;
    }
  }

  Future<Database> initializeDb() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "app.db");

    // Check if the database exists
    var exists = await databaseExists(path);

    if (!exists) {
      // Should happen only the first time you launch your application
      print("Creating new copy from asset");

      // Make sure the parent directory exists
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      // Copy from asset
      ByteData data = await rootBundle.load(join("assets", "proje.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      print("Opening existing database");
    }
    // open the database
    db = await openDatabase(path, readOnly: false);
    return db;
  }

  Future<List<Map>> getCategory() async {
    var db = await getDb();
    var result = await db.query("category");
    return result;
  }

  Future<int> insertCategory(Category category) async {
    var db = await getDb();
    var result = await db.insert("category", category.toMap());
    return result;
  }

  Future<int> updateCategory(Category category) async {
    var db = await getDb();
    var result = await db.update("category", category.toMap());
    return result;
  }

  Future<int> deleteCategory(int id) async {
    var db = await getDb();
    var result =
        await db.delete("category", where: "category_id = ?", whereArgs: [id]);
    return result;
  }

  Future<List<Map>> getNote() async {
    var db = await getDb();
    var result = await db.rawQuery(
        "Select * from note join category on note.category_id = category.category_id");
    return result;
  }

  Future<List<Note>> getNoteList() async {
    List<Note> noteList = List<Note>();
    getNote().then((value) {
      for (Map map in value) {
        noteList.add(Note.fromMap(map));
      }
    });
    return noteList;
  }

  Future<int> insertNote(Note note) async {
    var db = await getDb();
    var result = await db.insert("note", note.toMap());
    return result;
  }

  Future<int> deleteNote(int id) async {
    var db = await getDb();
    var result = await db.delete("note", where: "note_id = ?", whereArgs: [id]);
    return result;
  }

  Future<int> updateNote(Note note) async {
    var db = await getDb();
    var result = await db.update("note", note.toMap());
    return result;
  }

  String dateFormat(DateTime tm){

    DateTime today = new DateTime.now();
    Duration oneDay = new Duration(days: 1);
    Duration twoDay = new Duration(days: 2);
    Duration oneWeek = new Duration(days: 7);
    String month;
    switch (tm.month) {
      case 1:
        month = "Ocak";
        break;
      case 2:
        month = "Şubat";
        break;
      case 3:
        month = "Mart";
        break;
      case 4:
        month = "Nisan";
        break;
      case 5:
        month = "Mayıs";
        break;
      case 6:
        month = "Haziran";
        break;
      case 7:
        month = "Temmuz";
        break;
      case 8:
        month = "Ağustos";
        break;
      case 9:
        month = "Eylük";
        break;
      case 10:
        month = "Ekim";
        break;
      case 11:
        month = "Kasım";
        break;
      case 12:
        month = "Aralık";
        break;
    }

    Duration difference = today.difference(tm);

    if (difference.compareTo(oneDay) < 1) {
      return "Bugün";
    } else if (difference.compareTo(twoDay) < 1) {
      return "Dün";
    } else if (difference.compareTo(oneWeek) < 1) {
      switch (tm.weekday) {
        case 1:
          return "Pazartesi";
        case 2:
          return "Salı";
        case 3:
          return "Çarşamba";
        case 4:
          return "Perşembe";
        case 5:
          return "Cuma";
        case 6:
          return "Cumartesi";
        case 7:
          return "Pazar";
      }
    } else if (tm.year == today.year) {
      return '${tm.day} $month';
    } else {
      return '${tm.day} $month ${tm.year}';
    }
    return "";
  }
}
