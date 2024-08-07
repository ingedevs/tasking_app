import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../../config/config.dart';
import '../../../generated/strings.g.dart';
import '../../domain/domain.dart';
import '../modals/list_tasks_options_modal.dart';
import '../modals/list_tasks_update_modal.dart';
import '../modals/task_add_modal.dart';
import '../providers/list_tasks_provider.dart';
import '../widgets/widgets.dart';

class ListTasksPage extends ConsumerWidget {
  const ListTasksPage(this.listId, {super.key});

  static String routePath = '/list/:id';

  final int listId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final style = Theme.of(context).textTheme;

    final list = ref.watch(listTasksProvider(listId));

    if (list.id == 0) {
      return const Scaffold(
        body: CircularProgressIndicator(),
      );
    }

    final color = Color(list.color ?? 0xFF000000);

    final notifier = ref.read(listTasksProvider(listId).notifier);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          iconSize: 30.0,
          icon: const Icon(BoxIcons.bx_chevron_left),
        ),
        actions: [
          IconButton(
            onPressed: list.archived ? null : notifier.onPinned,
            color: color,
            iconSize: 18.0,
            icon: Icon(
              list.pinned ? BoxIcons.bxs_pin : BoxIcons.bx_pin,
            ),
          ),
          IconButton(
            onPressed: notifier.onArchived,
            color: color,
            iconSize: 18.0,
            icon: Icon(
              list.archived ? BoxIcons.bxs_archive : BoxIcons.bx_archive,
            ),
          ),
          IconButton(
            onPressed: () => showModalBottomSheet(
              context: context,
              builder: (_) => ListTasksOptionsModal(context, list.id),
            ),
            color: color,
            iconSize: 18.0,
            icon: const Icon(BoxIcons.bx_dots_vertical_rounded),
          ),
        ],
      ),
      body: ListView(
        children: [
          ListTile(
            onTap: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (_) => ListTasksUpdateModal(list),
            ),
            shape: const RoundedRectangleBorder(),
            leading: Icon(
              BoxIcons.bxs_circle,
              color: Color(list.color ?? 0xFF000000),
              size: 18,
            ),
            title: Text(list.title, style: style.bodyLarge),
          ),
          if (list.tasks.isEmpty)
            _EmptyTasks(list.id)
          else
            _BuildTasks(list.tasks.toList()),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: color,
        onPressed: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (_) => TaskAddModal(list.id),
        ),
        child: const Icon(BoxIcons.bx_plus),
      ),
    );
  }
}

class _BuildTasks extends StatelessWidget {
  const _BuildTasks(this.tasks);

  final List<Task> tasks;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;

    final pendingTasks = tasks.where((task) => !task.completed).toList();
    pendingTasks.sort((a, b) => a.createdAt.compareTo(b.createdAt));

    final completedTasks = tasks.where((task) => task.completed).toList();
    completedTasks.sort((a, b) => a.createdAt.compareTo(b.createdAt));

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: pendingTasks.length,
          itemBuilder: (context, index) {
            final task = pendingTasks[index];
            return TaskCard(task);
          },
        ),
        if (completedTasks.isNotEmpty) ...[
          ListTile(
            visualDensity: VisualDensity.compact,
            shape: const RoundedRectangleBorder(),
            title: Text(
              'Completed',
              style: style.bodySmall?.copyWith(color: Colors.white70),
            ),
          ),
        ],
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: completedTasks.length,
          itemBuilder: (context, index) {
            final task = completedTasks[index];
            return TaskCard(task);
          },
        ),
      ],
    );
  }
}

class _EmptyTasks extends ConsumerWidget {
  const _EmptyTasks(this.listId);

  final int listId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final list = ref.watch(listTasksProvider(listId));

    final color = Color(list.color ?? 0xFF000000);

    return Container(
      margin: const EdgeInsets.only(top: 200.0),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(defaultPadding),
            decoration: BoxDecoration(
              color: color.withOpacity(.06),
              shape: BoxShape.circle,
            ),
            child: Icon(
              BoxIcons.bx_task,
              size: 38.0,
              color: color,
            ),
          ),
          const Gap(defaultPadding),
          Text(
            S.pages.listTasks.emptyTasks.title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const Gap(8.0),
          Text(
            S.pages.listTasks.emptyTasks.subtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white70,
                ),
          ),
        ],
      ),
    );
  }
}
