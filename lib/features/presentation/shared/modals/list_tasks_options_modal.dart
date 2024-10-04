import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:tasking/config/config.dart';
import 'package:tasking/features/presentation/providers/providers.dart';
import 'package:tasking/features/presentation/shared/shared.dart';
import 'package:tasking/i18n/i18n.dart';

class ListTasksOptionsModal extends ConsumerWidget {
  const ListTasksOptionsModal(this.contextPage, this.listId, {super.key});

  final BuildContext contextPage;
  final int listId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final list = ref.watch(listTasksProvider(listId));
    final notifier = ref.read(listTasksProvider(listId).notifier);

    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: defaultPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(left: defaultPadding),
              child: Text(
                S.modals.listTasksOptions.list.title,
                style: const TextStyle(color: Colors.white70),
              ),
            ),
            ListTile(
              onTap: () async {
                context.pop();
                final result = await showDialog<bool?>(
                  context: context,
                  builder: (_) => ListTaskDeleteDialog(list.id),
                );
                if (result != null && result) {
                  notifier.onDelete(contextPage);
                }
              },
              shape: const RoundedRectangleBorder(),
              visualDensity: VisualDensity.compact,
              leading: const Icon(IconsaxOutline.trash, size: 18),
              title: Text(S.modals.listTasksOptions.list.delete),
            ),
            ListTile(
              onTap: () async {
                context.pop();
                showDialog<bool?>(
                  context: context,
                  builder: (_) => ArchivedConfirmDialog(
                    titleList: list.title,
                  ),
                ).then((value) {
                  if (value != null && value) {
                    notifier.onArchived(contextPage);
                  }
                });
              },
              shape: const RoundedRectangleBorder(),
              visualDensity: VisualDensity.compact,
              // iconColor: list.color,
              leading: const Icon(IconsaxOutline.archive, size: 18),
              title: Text(S.modals.listTasksOptions.list.archive),
            ),
            const Gap(defaultPadding),
            Container(
              margin: const EdgeInsets.only(left: defaultPadding),
              child: Text(
                S.modals.listTasksOptions.tasks.title,
                style: const TextStyle(color: Colors.white70),
              ),
            ),
            ListTile(
              onTap: () {
                context.pop();
                notifier.onMarkIncompleteAllTasks();
              },
              enabled: list.tasks.isNotEmpty,
              shape: const RoundedRectangleBorder(),
              visualDensity: VisualDensity.compact,
              // iconColor: list.color,
              leading: const Icon(IconsaxOutline.record, size: 18),
              title: Text(
                S.modals.listTasksOptions.tasks.incompleteAllTasks,
              ),
            ),
            ListTile(
              onTap: () {
                context.pop();
                notifier.onMarkCompleteAllTasks();
              },
              enabled: list.tasks.isNotEmpty,
              shape: const RoundedRectangleBorder(),
              visualDensity: VisualDensity.compact,
              // iconColor: list.color,
              leading: const Icon(IconsaxOutline.record_circle, size: 18),
              title: Text(S.modals.listTasksOptions.tasks.completeAllTasks),
            ),
            ListTile(
              onTap: () {
                context.pop();
                notifier.onDeleteCompletedAllTasks();
              },
              enabled: list.tasks.isNotEmpty,
              shape: const RoundedRectangleBorder(),
              visualDensity: VisualDensity.compact,
              // iconColor: list.color,
              leading: const Icon(IconsaxOutline.minus_cirlce, size: 18),
              title: Text(
                S.modals.listTasksOptions.tasks.deleteAllCompletedTasks,
              ),
            ),
          ],
        ),
      ),
    );
  }
}