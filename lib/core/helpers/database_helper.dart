import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tasking/config/config.dart';

class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final String path = join(await getDatabasesPath(), 'tasking.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
            CREATE TABLE lists(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              title TEXT NOT NULL,
              colorValue INTEGER NOT NULL,
              showCompleted INTEGER DEFAULT 0,
              archived INTEGER DEFAULT 0,
              created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            );
        ''');
        await db.execute('''
            CREATE TABLE tasks(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              title TEXT NOT NULL,
              note TEXT,
              completed INTEGER DEFAULT 0,
              reminder TIMESTAMP,
              dueDate TIMESTAMP,
              updated_at TIMESTAMP NOT NULL,
              created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
              list_id INTEGER NOT NULL,
              FOREIGN KEY (list_id) REFERENCES lists(id) ON DELETE CASCADE
            );
        ''');
        await db.execute('''
            CREATE TABLE steps(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              title TEXT NOT NULL,
              completed INTEGER DEFAULT 0,
              created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
              task_id INTEGER NOT NULL,
              FOREIGN KEY (task_id) REFERENCES tasks(id) ON DELETE CASCADE
            );
        ''');
      },
    );
  }

  Future<void> insertTutorialList() async {
    final Database db = await database;
    await _tutorialListQuery(db);
  }

  Future<void> _tutorialListQuery(Database db) async {
    final String now = DateTime.now().toIso8601String();
    await db.transaction((txn) async {
      final int listId = await txn.rawInsert(
        "INSERT INTO lists (title, colorValue, showCompleted) VALUES ('Tutorial', 4294951175, 1)",
      );
      await txn.rawInsert(
        "INSERT INTO tasks (title, updated_at, created_at, list_id) VALUES ('${S.pages.intro.tutorial.task1}', '$now', '$now', $listId)",
      );
      await txn.rawInsert(
        "INSERT INTO tasks (title, updated_at, created_at, list_id) VALUES ('${S.pages.intro.tutorial.task2}', '$now', '$now', $listId)",
      );
      await txn.rawInsert(
        "INSERT INTO tasks (title, updated_at, created_at, list_id) VALUES ('${S.pages.intro.tutorial.task3}', '$now', '$now', $listId)",
      );
      await txn.rawInsert(
        "INSERT INTO tasks (title, updated_at, created_at, list_id) VALUES ('${S.pages.intro.tutorial.task4}', '$now', '$now', $listId)",
      );
      await txn.rawInsert(
        "INSERT INTO tasks (title, note, updated_at, created_at, list_id) VALUES ('${S.pages.intro.tutorial.task5}', '${S.pages.intro.tutorial.task5note}', '$now', '$now', $listId)",
      );
      await txn.rawInsert(
        "INSERT INTO tasks (title, updated_at, created_at, list_id) VALUES ('${S.pages.intro.tutorial.task6}', '$now', '$now', $listId)",
      );
      await txn.rawInsert(
        "INSERT INTO tasks (title, updated_at, created_at, list_id) VALUES ('${S.pages.intro.tutorial.task7}', '$now', '$now', $listId)",
      );
      await txn.rawInsert(
        "INSERT INTO tasks (title, updated_at, created_at, list_id) VALUES ('${S.pages.intro.tutorial.task8}', '$now', '$now', $listId)",
      );
      await txn.rawInsert(
        "INSERT INTO tasks (title, updated_at, created_at, list_id) VALUES ('${S.pages.intro.tutorial.task9}', '$now', '$now', $listId)",
      );
    });
  }

  Future<void> restore() async {
    final Database db = await database;
    await db.transaction((txn) async {
      await txn.rawDelete('DELETE FROM tasks');
      await txn.rawDelete('DELETE FROM lists');
    });
    await _tutorialListQuery(db);
  }
}
