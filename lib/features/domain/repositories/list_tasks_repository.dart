import 'package:flutter/material.dart';

import '../../data/data.dart';
import '../domain.dart';

abstract interface class IListTasksRepository {
  Future<List<ListTasks>> fetchAll();
  Future<ListTasks?> get(int id);
  Future<ListTasks> add(String name, Color color, [IconData? icon]);
  Future<void> update(ListTasks group);
  Future<void> delete(int id);
}

class ListTasksRepository extends IListTasksRepository {
  final IListTasksDataSource _dataSource = ListTasksDataSource();

  @override
  Future<ListTasks> add(String name, Color color, [IconData? icon]) {
    return _dataSource.add(name, color, icon);
  }

  @override
  Future<void> delete(int id) {
    return _dataSource.delete(id);
  }

  @override
  Future<List<ListTasks>> fetchAll() {
    return _dataSource.fetchAll();
  }

  @override
  Future<ListTasks?> get(int id) {
    return _dataSource.get(id);
  }

  @override
  Future<void> update(ListTasks group) {
    return _dataSource.update(group);
  }
}