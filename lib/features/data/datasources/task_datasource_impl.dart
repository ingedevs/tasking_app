import 'dart:developer';

import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tasking/core/core.dart';
import 'package:tasking/features/domain/domain.dart';

class TaskDataSourceImpl implements TaskDataSource {
  final dbHelper = DatabaseHelper();

  @override
  Future<Task> get(int id) async {
    try {
      final Database db = await dbHelper.database;
      final data = await db.query(
        'tasks',
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );
      return Task.fromMap(data.first);
    } catch (e) {
      log(e.toString(), name: 'TaskDataSourceImpl.get');
      rethrow;
    }
  }

  @override
  Future<List<Task>> getByDate(DateTime value) async {
    try {
      final Database db = await dbHelper.database;
      final formattedDate = DateFormat('yyyy-MM-dd').format(value);
      final data = await db.rawQuery(
        '''
          SELECT
              tasks.*,
              lists.title AS list_title
          FROM
              tasks
          JOIN
              lists ON tasks.list_id = lists.id
          WHERE
              dateline LIKE ?;
        ''',
        ['$formattedDate%'],
      );
      if (data.isEmpty) return <Task>[];
      return data.map((e) => Task.fromMap(e)).toList();
    } catch (e) {
      log('TaskDataSourceImpl.getByDate: $e');
      return <Task>[];
    }
  }

  @override
  Future<List<Task>> getByListId(int id) async {
    try {
      final Database db = await dbHelper.database;
      final data = await db.query(
        'tasks',
        where: 'list_id = ?',
        whereArgs: [id],
      );
      if (data.isEmpty) return <Task>[];
      return data.map((e) => Task.fromMap(e)).toList();
    } catch (e) {
      log('TaskDataSourceImpl.getByListId: $e');
      return <Task>[];
    }
  }

  @override
  Future<List<Task>> getImportant() async {
    try {
      final Database db = await dbHelper.database;
      final data = await db.query(
        'tasks',
        where: 'is_important = ?',
        whereArgs: [1],
      );
      if (data.isEmpty) return <Task>[];
      return data.map((e) => Task.fromMap(e)).toList();
    } catch (e) {
      log('TaskDataSourceImpl.getImportant: $e');
      return <Task>[];
    }
  }

  @override
  Future<List<Task>> search(String value) async {
    try {
      final Database db = await dbHelper.database;
      final data = await db.rawQuery(
        '''
          SELECT
              tasks.*,
              lists.title AS list_title
          FROM
              tasks
          JOIN
              lists ON tasks.list_id = lists.id
          WHERE
              tasks.title LIKE ? OR lists.title LIKE ?;
        ''',
        ['%$value%', '%$value%'],
      );
      if (data.isEmpty) return <Task>[];
      return data.map((e) => Task.fromMap(e)).toList();
    } catch (e) {
      log('TaskDataSourceImpl.search: $e');
      return <Task>[];
    }
  }

  @override
  Future<Task> add(Task task) async {
    try {
      final Database db = await dbHelper.database;
      final id = await db.insert(
        'tasks',
        task.toMap(),
        conflictAlgorithm: ConflictAlgorithm.abort,
      );
      final data = await db.query(
        'tasks',
        where: 'id = ?',
        whereArgs: [id],
      );
      return Task.fromMap(data.first);
    } catch (e) {
      log('TaskDataSourceImpl.add: $e');
      rethrow;
    }
  }

  @override
  Future<void> delete(int id) async {
    try {
      final Database db = await dbHelper.database;
      await db.delete(
        'tasks',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      log('TaskDataSourceImpl.delete: $e');
      rethrow;
    }
  }

  @override
  Future<void> update(int id, Map<String, dynamic> data) async {
    try {
      final Database db = await dbHelper.database;
      await db.update(
        'tasks',
        data,
        where: 'id = ?',
        whereArgs: [id],
        conflictAlgorithm: ConflictAlgorithm.abort,
      );
    } catch (e) {
      log('TaskDataSourceImpl.update: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteReminder(int id) async {
    try {
      final Database db = await dbHelper.database;
      await db.update(
        'tasks',
        {'reminder': null},
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      log('TaskDataSourceImpl.deleteReminder: $e');
      rethrow;
    }
  }
}
