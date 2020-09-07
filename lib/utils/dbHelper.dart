import 'dart:io';
import 'package:flutter/services.dart';
import 'package:notebook/models/category.dart';
import 'package:notebook/models/note.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper{
  static DbHelper dbHelper;
  static Database db;

  DbHelper.internal();

  factory DbHelper(){
    if(dbHelper == null){
      dbHelper = DbHelper.internal();
      return dbHelper;
    }else {
      return dbHelper;
    }
  }

  Future<Database> getDb() async{
    if(db == null){
      db = await initializeDb();
      return db;
    }else {
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
      ByteData data = await rootBundle.load(join("assets", "notebook.db"));
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

  Future<List<Map>> getCategory() async{
    var db = await getDb();
    var result = await db.query("category");
    return result;
  }

  Future<int> insertCategory(Category category) async{
    var db = await getDb();
    var result = await db.insert("category", category.toMap());
    return result;
  }
  
  Future<int> updateCategory(Category category) async{
    var db = await getDb();
    var result = await db.update("category", category.toMap());
    return result;
  }

  Future<int> deleteCategory(int id) async{
    var db = await getDb();
    var result = await db.delete("category",where: "category_id = ?", whereArgs: [id]);
    return result;
  }

  Future<List<Map>> getNote() async{
    var db = await getDb();
    var result = await db.query("note");
    return result;
  }

  Future<List<Note>> getNoteList() async{
    List<Note> noteList;
    getNote().then((value){
      for(Map map in value){
        noteList.add(Note.fromMap(map));
      }
    });
    return noteList;
  }

  Future<int> insertNote(Note note) async{
    var db = await getDb();
    var result = await db.insert("note", note.toMap());
    return result;
  }

  Future<int> deleteNote(int id) async{
    var db = await getDb();
    var result = await db.delete("note", where: "note_id = ?", whereArgs: [id]);
    return result;
  }

  Future<int> updateNote(Note note) async{
    var db = await getDb();
    var result = await db.update("note", note.toMap());
    return result;
  }

}