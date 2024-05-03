import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../../config/config.dart';
import '../../domain/domain.dart';
import '../modals/update_list_tasks_modal.dart';
import '../providers/list_tasks_provider.dart';

class ModalListTasksOptions extends ConsumerWidget {
  const ModalListTasksOptions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;

    ListTasks? list = ref.watch(listTasksProvider);

    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: defaultPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(left: defaultPadding),
              child:
                  const Text('List', style: TextStyle(color: Colors.white70)),
            ),
            ListTile(
              onTap: () {
                context.pop();
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  useSafeArea: true,
                  builder: (_) => UpdateListTasksModal(list!),
                );
              },
              shape:
                  const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              visualDensity: VisualDensity.compact,
              iconColor: colors.primary,
              leading: const Icon(BoxIcons.bx_pencil, size: 18),
              title: const Text('Edit list'),
            ),
            ListTile(
              onTap: () {
                context.pop();
                showDialog(
                  context: context,
                  builder: (context) => _DeleteDialog(),
                );
              },
              shape:
                  const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              visualDensity: VisualDensity.compact,
              iconColor: colors.primary,
              leading: const Icon(BoxIcons.bx_trash, size: 18),
              title: const Text('Delete list'),
            ),
            const Divider(),
            Container(
              margin: const EdgeInsets.only(left: defaultPadding),
              child:
                  const Text('Tasks', style: TextStyle(color: Colors.white70)),
            ),
            ListTile(
              onTap: () {},
              shape:
                  const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              visualDensity: VisualDensity.compact,
              iconColor: colors.primary,
              leading: const Icon(BoxIcons.bx_circle, size: 18),
              title: const Text('Incomplete all tasks'),
            ),
            ListTile(
              onTap: () {},
              shape:
                  const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              visualDensity: VisualDensity.compact,
              iconColor: colors.primary,
              leading: const Icon(BoxIcons.bx_check_circle, size: 18),
              title: const Text('Complete all tasks'),
            ),
            ListTile(
              onTap: () {},
              shape:
                  const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              visualDensity: VisualDensity.compact,
              iconColor: colors.primary,
              leading: const Icon(BoxIcons.bx_x_circle, size: 18),
              title: const Text('Delete all completed tasks'),
            ),
          ],
        ),
      ),
    );
  }
}

class _DeleteDialog extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final style = Theme.of(context).textTheme;

    return AlertDialog(
      title: Text('Do you want to delete this list?', style: style.titleLarge),
      content: Text('Delete this list will also delete the tasks',
          style: style.bodyLarge),
      actions: [
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 45,
                child: FilledButton(
                  onPressed: () => context.pop(),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white10,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Cancel'),
                ),
              ),
            ),
            const Gap(8.0),
            Expanded(
              child: SizedBox(
                height: 45,
                child: FilledButton(
                  onPressed: () {
                    context.pop();
                    ref.read(listTasksProvider.notifier).onDelete();
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                  ),
                  child: const Text('Delete'),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
