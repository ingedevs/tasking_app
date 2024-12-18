import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';
import 'package:tasking/core/core.dart';
import 'package:tasking/features/domain/domain.dart';

class ListTasks {
  ListTasks({
    required this.id,
    required this.title,
    required this.icon,
    this.pendingTasksLength = 0,
    this.showCompleted = false,
    this.isDefault = false,
    required this.createdAt,
  });

  factory ListTasks.create({
    required String title,
    required IconData icon,
    required DateTime createdAt,
  }) {
    return ListTasks(id: 0, title: title, icon: icon, createdAt: createdAt);
  }

  factory ListTasks.empty() {
    return ListTasks(
      id: 0,
      title: '',
      icon: IconsaxOutline.folder,
      createdAt: DateTime.now(),
    );
  }

  factory ListTasks.fromMap(Map<String, dynamic> map) {
    return ListTasks(
      id: map['id'] as int,
      title: map['title'] as String,
      icon: IconDataUtils.decode(map['icon_json'] as String),
      pendingTasksLength: map['pending_tasks_length'] as int? ?? 0,
      showCompleted: map['is_show_completed'] as int == 1,
      isDefault: map['is_default'] as int == 1,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'icon_json': IconDataUtils.encode(icon),
      'is_show_completed': showCompleted ? 1 : 0,
      'created_at': createdAt.toDatabaseFormat(),
    };
  }

  ListTasks copyWith({
    int? id,
    String? title,
    IconData? icon,
    bool? showCompleted,
    bool? isDefault,
    DateTime? createdAt,
  }) {
    return ListTasks(
      id: id ?? this.id,
      title: title ?? this.title,
      icon: icon ?? this.icon,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  final int id;
  final String title;
  final IconData icon;
  final int pendingTasksLength;
  final bool showCompleted;
  final bool isDefault;
  final DateTime createdAt;

  List<Task> tasks = <Task>[];
}
