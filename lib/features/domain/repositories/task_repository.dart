import 'package:tasking/features/domain/domain.dart';

abstract class TaskRepository {
  Future<Task> get(int id);
  Future<List<Task>> getByDate(DateTime value);
  Future<List<Task>> getTodayTasks();
  Future<List<Task>> getByListId(int id);
  Future<List<Task>> getReminders();
  Future<Task> add(Task task);
  Future<void> update(Task task);
  Future<void> delete(int id);
  Future<void> deleteReminder(int id);
  Future<void> toggleCompleted(int id);
}
