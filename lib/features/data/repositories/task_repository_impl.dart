import 'package:tasking/features/data/data.dart';
import 'package:tasking/features/domain/domain.dart';

class TaskRepositoryImpl extends TaskRepository {
  TaskRepositoryImpl([TaskDataSource? dataSource])
      : _dataSource = dataSource ?? TaskDataSourceImpl();

  final TaskDataSource _dataSource;

  @override
  Future<Task> get(int id) {
    return _dataSource.get(id);
  }

  @override
  Future<List<Task>> getByDate(DateTime value) {
    return _dataSource.getByDate(value);
  }

  @override
  Future<List<Task>> getByListId(int id) {
    return _dataSource.getByListId(id);
  }

  @override
  Future<List<Task>> getImportant() {
    return _dataSource.getImportant();
  }

  @override
  Future<List<Task>> search(String value) {
    return _dataSource.search(value);
  }

  @override
  Future<Task> add(Task task) {
    return _dataSource.add(task);
  }

  @override
  Future<void> delete(int id) {
    return _dataSource.delete(id);
  }

  @override
  Future<void> deleteReminder(int id) {
    return _dataSource.deleteReminder(id);
  }

  @override
  Future<void> update(int id, Map<String, dynamic> data) {
    return _dataSource.update(id, data);
  }
}
