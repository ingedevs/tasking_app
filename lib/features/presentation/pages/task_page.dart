import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../../config/config.dart';
import '../../../core/core.dart';
import '../../../generated/strings.g.dart';
import '../../domain/domain.dart';
import '../dialogs/task_delete_dialog.dart';
import '../providers/list_tasks_provider.dart';
import '../providers/task_provider.dart';

class TaskPage extends ConsumerWidget {
  const TaskPage(this.task, {super.key});

  final Task task;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final style = Theme.of(context).textTheme;

    final list = ref.watch(listTasksProvider(task.listId));
    final color = Color(list.color!);

    final provider = ref.watch(taskProvider(task));
    final notifier = ref.read(taskProvider(task).notifier);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(BoxIcons.bx_arrow_back),
          color: color,
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            onPressed: () => notifier.onUpdateReminder(context),
            iconSize: 20.0,
            color: color,
            icon: Icon(
              (provider.reminder != null)
                  ? BoxIcons.bxs_bell
                  : BoxIcons.bx_bell,
            ),
          ),
          IconButton(
            onPressed: () => showModalBottomSheet(
              context: context,
              builder: (contextModel) => SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      onTap: () async {
                        Navigator.pop(contextModel);
                        final result = await showDialog<bool?>(
                          context: context,
                          builder: (_) => TaskDeleteDialog(),
                        );
                        if (result != null && result) {
                          await notifier.onDeleteTask();
                          Navigator.pop(context);
                        }
                      },
                      shape: const RoundedRectangleBorder(),
                      iconColor: color,
                      leading: const Icon(BoxIcons.bx_trash),
                      title: Text(S.buttons.delete),
                    ),
                  ],
                ),
              ),
            ),
            iconSize: 20.0,
            color: color,
            icon: const Icon(BoxIcons.bx_dots_vertical_rounded),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            initialValue: provider.title,
            style: style.titleLarge,
            autocorrect: false,
            maxLines: null,
            cursorColor: color,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              hintText: S.pages.task.placeholderTitle,
              filled: false,
            ),
            onChanged: notifier.onTitleChanged,
          ),
          TextFormField(
            initialValue: provider.note,
            maxLines: null,
            autocorrect: false,
            cursorColor: color,
            decoration: InputDecoration(
              hintText: S.pages.task.placeholderNote,
              filled: false,
            ),
            onChanged: notifier.onNoteChanged,
          ),
          if (task.reminder != null)
            _ReminderSchedule(
              onPressed: () => notifier.onUpdateReminder(context),
              reminder: provider.reminder!,
            ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              S.pages.task.edited(time: HumanFormat.time(task.updatedAt)),
              style: style.bodySmall?.copyWith(
                color: Colors.white60,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReminderSchedule extends StatelessWidget {
  const _ReminderSchedule({
    required this.onPressed,
    required this.reminder,
  });

  final VoidCallback onPressed;
  final DateTime reminder;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;

    Color colorStatus() {
      final now = DateTime.now();
      final different = now.difference(reminder);
      if (different.inSeconds > 0) {
        return Colors.white60;
      } else {
        return Colors.white;
      }
    }

    return Container(
      margin: const EdgeInsets.only(
        left: defaultPadding,
        top: defaultPadding,
      ),
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.card,
          foregroundColor: colorStatus(),
          textStyle: style.bodyMedium,
        ),
        child: Text(HumanFormat.datetime(reminder)),
      ),
    );
  }
}
