import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasking/config/config.dart';
import 'package:tasking/core/core.dart';

final colorThemeProvider = StateNotifierProvider<_Notifier, Color>((ref) {
  return _Notifier();
});

class _Notifier extends StateNotifier<Color> {
  _Notifier() : super(Colors.amber) {
    initialize();
  }

  final _pref = SharedPrefs();

  void initialize() {
    final colorValue = _pref.getValue<int>(StorageKeys.colorSeed);
    if (colorValue == null) return;
    state = Color(colorValue);
  }

  Future<void> setColor(Color color) async {
    await _pref.setKeyValue<int>(StorageKeys.colorSeed, color.value);
    state = color;
  }
}
