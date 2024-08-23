import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tasking/core/core.dart';
import 'package:tasking/features/domain/domain.dart';
import 'package:tasking/features/presentation/providers/providers.dart';
import 'package:tasking/i18n/generated/translations.g.dart';

final listTasksAddDialogProvider =
    StateNotifierProvider.autoDispose<_Notifier, _State>((ref) {
  final refresh = ref.read(allListTasksProvider.notifier).refreshAll;

  return _Notifier(refresh);
});

class _Notifier extends StateNotifier<_State> {
  _Notifier(this.refresh) : super(_State());

  final Future<void> Function() refresh;

  final _listTasksRepository = ListTasksRepository();

  void onNameChanged(String value) {
    state = state.copyWith(name: value.trim());
  }

  void onColorChanged(Color color) {
    state = state.copyWith(color: color);
  }

  Future<void> onSubmit(BuildContext context) async {
    if (state.name.isEmpty) {
      MyToast.show(S.common.dialogs.listTasksAdd.errorEmptyName);
      return;
    }
    await _listTasksRepository.add(state.name, state.color).then((list) {
      context.pop();
      refresh();
    });
  }
}

class _State {
  _State({
    this.name = '',
    this.color = const Color(0xffffc107),
  });

  final String name;
  final Color color;

  _State copyWith({
    String? name,
    Color? color,
  }) {
    return _State(
      name: name ?? this.name,
      color: color ?? this.color,
    );
  }
}
