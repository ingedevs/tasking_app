import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:tasking/generated/l10n.dart';

import '../../../config/config.dart';
import '../../../core/core.dart';
import '../../data/data.dart';

final introProvider = StateNotifierProvider.autoDispose<_Notifier, void>((ref) {
  return _Notifier();
});

class _Notifier extends StateNotifier<void> {
  _Notifier() : super(null);

  final _pref = SharedPrefs();

  final groupDataSource = GroupDataSource();

  Future<void> onFinish(BuildContext context) async {
    final group = await groupDataSource.add(
      S.current.default_group_1,
      BoxIcons.bx_list_ul,
    );
    await groupDataSource.add(
      S.current.default_group_2,
      BoxIcons.bx_cart,
    );
    await groupDataSource.add(
      S.current.default_group_3,
      BoxIcons.bx_briefcase,
    );
    await _pref.setKeyValue<int>(Keys.groupId, group.id);
    await _pref.setKeyValue<bool>(Keys.isFirstTime, false).then((value) {
      context.go(RoutesPath.home);
    });
  }
}
