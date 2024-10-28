import 'package:tasking/features/data/data.dart';
import 'package:tasking/features/domain/domain.dart';

class StepRepositoryImpl implements StepRepository {
  StepRepositoryImpl([StepDataSource? dataSource])
      : _dataSource = dataSource ?? StepDataSourceImpl();

  final StepDataSource _dataSource;

  @override
  Future<void> add(int taskId, String value) {
    return _dataSource.add(taskId, value);
  }

  @override
  Future<List<StepTask>> getAll(int taskId) {
    return _dataSource.getAll(taskId);
  }
}
