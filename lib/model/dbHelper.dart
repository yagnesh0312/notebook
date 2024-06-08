import 'package:notebook/datatype/type.dart';
import 'package:notebook/model/Note.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static const String table = "notes";
  static Future<Database> getDB() async {
    // if(await databaseExists(join(await getDatabasesPath(), "notes.db"))){
    //   await deleteDatabase(join(await getDatabasesPath(), "notes.db"));
    //   print("db deleted");
    // }
    Database db = await openDatabase(
      join(await getDatabasesPath(), "notes.db"),
      version: 1,
      onCreate: (db, version) {
        db.execute(
            "Create table notes(id text primary key,title text,content text,time INTEGER)");
      },
    );
    return db;
  }

  static addNote(NoteModel n) async {
    Database db = await getDB();
    db.insert(table, n.toMap()).then((value) {
      return value;
    });
  }

  static updateNote(NoteModel n) async {
    Database db = await getDB();
    db
        .update(table, n.toMap(),
            where: "id = ?",
            whereArgs: [n.id],
            conflictAlgorithm: ConflictAlgorithm.replace)
        .then((value) {
      return value;
    });
  }

  static deleteNote(NoteModel n) async {
    Database db = await getDB();
    db.delete(table, where: "id = ?", whereArgs: [n.id]).then((value) {
      return value;
    });
  }

  static Future<List<NoteModel>> getNote() async {
    Database db = await getDB();
    List<MyMap> m = await db.query(table);
    return List.generate(m.length, (index) => NoteModel.fromMap(m[index]));
  }
}
