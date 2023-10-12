import '../../domain/domain.dart';
import '../data_sources/data_sources.dart';

abstract class TaskRepository {
  Future<List<Task>> getAll();
  Future<void> write(Task task);
}

class TaskRepositoryImpl extends TaskRepository {
  final TaskDataSource _dataSource = TaskDataSourceImpl();

  @override
  Future<List<Task>> getAll() {
    return _dataSource.getAll();
  }

  @override
  Future<void> write(Task task) {
    return _dataSource.write(task);
  }
}
