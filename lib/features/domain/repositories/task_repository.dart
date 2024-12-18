import 'package:tasking/features/domain/domain.dart';

abstract class TaskRepository {
  Future<Task> get(int id);
  Future<List<Task>> getByDate(DateTime value);
  Future<List<Task>> getByListId(int id);
  Future<List<Task>> getImportant();
  Future<List<Task>> search(String value);
  Future<Task> add(Task task);
  Future<void> update(int id, Map<String, dynamic> data);
  Future<void> delete(int id);
  Future<void> deleteReminder(int id);
}
