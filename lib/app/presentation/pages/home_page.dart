import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../../config/config.dart';
import '../../../generated/l10n.dart';
import '../../domain/domain.dart';
import '../modals/select_group_modal.dart';
import '../presentation.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final style = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    final group = ref.watch(homeProvider).group;

    return Scaffold(
      body: Scaffold(
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          title: GestureDetector(
            onTap: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              useSafeArea: true,
              elevation: 0,
              builder: (_) => const SelectGroupModal(),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  group?.icon?.iconData ?? BoxIcons.bx_crown,
                  color: colors.primary,
                ),
                const SizedBox(width: 8.0),
                Flexible(
                  child: Text(
                    group?.name ?? 'Tasking',
                    style: style.titleLarge,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8.0),
                const Icon(BoxIcons.bx_chevron_down),
              ],
            ),
          ),
          centerTitle: false,
          actions: [
            IconButton(
              onPressed: () => context.push(RoutesPath.settings),
              icon: const Icon(BoxIcons.bx_cog),
            ),
          ],
        ),
        body: _BuildTasks(),
        bottomNavigationBar: const AddTaskField(),
      ),
    );
  }
}

class _BuildTasks extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final style = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    final provider = ref.watch(homeProvider);
    final tasks = provider.tasks;

    final listCompleted =
        tasks.where((task) => task.isCompleted != null).toList();
    listCompleted.sort((a, b) => b.isCompleted!.compareTo(a.isCompleted!));

    final listPending =
        tasks.where((task) => task.isCompleted == null).toList();

    if (tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(HeroIcons.check),
            Text(S.of(context).home_empty_tasks, style: style.bodyLarge),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
      children: [
        ...listPending.map((task) => _BuildTask(task)).toList(),
        if (listCompleted.isNotEmpty)
          Row(
            children: [
              TextButton.icon(
                onPressed:
                    ref.read(homeProvider.notifier).onToggleShowCompleted,
                icon: Icon(
                  provider.isShowCompleted
                      ? BoxIcons.bx_hide
                      : BoxIcons.bx_show,
                  size: 16.0,
                ),
                style: TextButton.styleFrom(
                  foregroundColor: colors.onSurface.withOpacity(.8),
                ),
                label: provider.isShowCompleted
                    ? Text(S.of(context).button_hide)
                    : Text(S.of(context).button_show),
              ),
              const Spacer(),
              if (provider.isShowCompleted)
                TextButton.icon(
                  onPressed: () => showModalBottomSheet(
                    context: context,
                    builder: (_) => Container(
                      padding: const EdgeInsets.all(defaultPadding),
                      child: SafeArea(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              title: Text(
                                'Eliminar todas las tareas completadas',
                                style: style.titleLarge,
                              ),
                            ),
                            const Gap(defaultPadding),
                            Row(
                              children: [
                                Expanded(
                                  child: CustomFilledButton(
                                    onPressed: () => Navigator.pop(context),
                                    backgroundColor: Colors.white10,
                                    foregroundColor: colors.onSurface,
                                    child: Text(S.of(context).button_cancel),
                                  ),
                                ),
                                const Gap(defaultPadding),
                                Expanded(
                                  child: CustomFilledButton(
                                    onPressed: () {
                                      ref
                                          .read(homeProvider.notifier)
                                          .onClearCompleted();
                                      Navigator.pop(context);
                                    },
                                    backgroundColor: Colors.red,
                                    foregroundColor: colors.onSurface,
                                    child: const Text('Eliminar'),
                                  ),
                                ),
                              ],
                            ),
                            if (Platform.isAndroid) const Gap(defaultPadding),
                          ],
                        ),
                      ),
                    ),
                  ),
                  icon: const Icon(BoxIcons.bx_trash, size: 16.0),
                  label: Text(S.of(context).button_clear),
                ),
            ],
          ),
        if (provider.isShowCompleted)
          ...listCompleted.map((task) => _BuildTask(task)).toList(),
      ],
    );
  }
}

class _BuildTask extends ConsumerWidget {
  final Task task;
  const _BuildTask(this.task);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CardTask(
      onShowDetails: () {
        final routePath = RoutesPath.task.replaceAll(':id', '${task.id}');
        context.push(routePath);
      },
      onCheckTask: () => ref.read(homeProvider.notifier).onToggleCheck(task),
      task: task,
    );
  }
}
