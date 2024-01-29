import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../../config/config.dart';
import '../../../core/core.dart';
import '../../data/data.dart';

final introProvider = StateNotifierProvider.autoDispose<_Notifier, void>((ref) {
  return _Notifier();
});

class _Notifier extends StateNotifier<void> {
  _Notifier() : super(null);

  final _pref = SharedPrefsService();

  final groupDataSource = GroupDataSource();

  void onNext(BuildContext context) async {
    await _finish(context);

    //TODO: check permission notifications

    // if (isGranted) {
    //   await _finish(context);
    //   return;
    // }
    // await showModalBottomSheet(
    //   context: context,
    //   isDismissible: false,
    //   enableDrag: false,
    //   elevation: 0,
    //   builder: (_) => const PermissionNotificationModal(),
    // ).then((_) async {
    //   await onRequest().then((_) async {
    //     await _finish(context);
    //   });
    // });
  }

  Future<void> _finish(BuildContext context) async {
    final group = await groupDataSource.add('Personal', BoxIcons.bx_user);
    await _pref.setKeyValue<int>(Keys.groupId, group.id);
    await _pref.setKeyValue<bool>(Keys.isFirstTime, false).then((value) {
      context.go(RoutesPath.home);
    });
  }
}
