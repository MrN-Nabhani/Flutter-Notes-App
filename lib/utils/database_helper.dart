import 'package:path_provider/path_provider.dart';
import 'package:notes_app/models/node.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';


class DatabaseHelper {
  
  static DatabaseHelper _databaseHelper;
  static Database _database;

  String noteTable = 'note_table',
         colId = 'id',
         colTitle = 'title',
         colDesc = 'description',
         colDate = 'date';

  DatabaseHelper._createInstance();

  factory DatabaseHelper(){
    if(_databaseHelper == null)
      _databaseHelper = DatabaseHelper._createInstance();

    return _databaseHelper;
  }

  Future<Database> get database async{
    if(_database == null)
      _database = await initializeDatabase();

    return _database;
    
  }

  Future<Database> initializeDatabase() async{
      Directory directory = await getApplicationDocumentsDirectory();
      String path = directory.path + 'notes.dp';

      var notesDatabase = await openDatabase(path, version: 1, onCreate: createDatabase);
      return notesDatabase;
  }

  void createDatabase(Database db, int version) async {
      await db.execute('CREATE TABLE $noteTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, $colDesc TEXT, $colDate TEXT)');
  }

  Future<List<Map<String, dynamic>>>  getNotesMapList() async{
        Database db = await this.database;
        var result = await db.query(noteTable, orderBy: '$colId ASC');
        return result;
  }

  Future<int>  insertNote(Note values) async {
    Database db = await this.database;
    var result = await db.insert(noteTable, values.toMap());
    return result;
  }


  Future<int>  updateNote(Note values) async {
    Database db = await this.database;
    var result = await  db.update(noteTable, values.toMap(), where: '$colId = ?', whereArgs: [values.id]);
    return result;
  }

  Future<int>  deleteNote(int id) async {
    Database db = await this.database;
    var result = await  db.rawDelete('DELETE FROM $noteTable WHERE $colId = $id');
    return result;
  }

  Future<int> getCount() async {
    Database db = await this.database;
    //var result = await db.rawQuery('SELECT COUNT($colId) AS COUNT FROM $noteTable');
   // return result[0]['COUNT'];
   var list = await db.rawQuery('SELECT COUNT(*) FROM $noteTable');
   int result = Sqflite.firstIntValue(list);
   return result;
  }

  Future<List<Note>>  getNotesList() async{
    
        var noteMapList = await getNotesMapList();

        List<Note> noteList = new List<Note>();

        for(var note_map in noteMapList){
          Note note = Note.fromMapObject(note_map);
          noteList.add(note);
        }

    return noteList;
  }

}