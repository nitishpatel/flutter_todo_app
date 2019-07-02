import 'Note.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper; //Single Ton
  static Database _database; //SingleTon

  String noteTable = 'note_table';
  String colId = 'id';
  String colTitle = 'title';
  String colDescription = 'description';
  String colPriority = 'priority';
  String colDate = 'date';
  String colStatus = 'status';

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  // custom getter for database
  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'tasks.db';
    var notesDatabase =
        await openDatabase(path, version: 2, onCreate: _createDb);

    return notesDatabase;
  }

  void _createDb(Database db, int newversion) async {
    await db.execute(
        'CREATE TABLE $noteTable ($colId INTEGER PRIMARY KEY AUTOINCREMENT,$colTitle TEXT,$colDescription  TEXT,$colPriority INTEGER,$colStatus INTRGER,$colDate TEXT)');
  }

  Future<List<Map<String,dynamic>>> getNoteMapList()async{
    Database db = await this.database;
    var result = await db.query(
      noteTable,orderBy: '$colPriority ASC'
    );
    return result;
  } 
  
  Future<int> insertNote(Note note)async{
    Database db =await  this.database;
    var result = await db.insert(noteTable, note.toMap());
    return result;
  }
  Future<int> updateNote(Note note)async{
    Database db =await  this.database;
    var result = await db.update(noteTable, note.toMap(),where:'$colId=?',whereArgs: [note.id]);
    return result;
  }
  Future<int> deleteNote(int id)async{
    Database db = await database;
    var result = db.rawDelete('DELETE FROM $noteTable where  $colId = $id');
    return result;
  }

  Future<int> getCount()async{
    Database db = await this.database;
    List<Map<String,dynamic>> x = await db.rawQuery("SELECT COUNT (*) FROM $noteTable");
    int result = Sqflite.firstIntValue(x);
    // print(result);
    return result;
  }
  Future<int> getStatusCount()async{
    Database db = await this.database;
    var x = await db.rawQuery("SELECT COUNT (*) FROM $noteTable where $colStatus=1");
    int result = Sqflite.firstIntValue(x);
    // print(result);
    return result;
  }

  Future<List<Note>> getNoteList()async{
    var noteMapList = await getNoteMapList();
    int count = noteMapList.length;
    List<Note> noteList = List<Note>();
    for(var i = 0;i<count;i++){
      noteList.add(Note.fromMapObject(noteMapList[i]));
    }
    return noteList;
  }
  




}
