import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kThemeKey = 'vendor_theme_mode';

class ThemeCubit extends Cubit<ThemeMode> {
  // Default to light so a tester on a dark-mode OS doesn't see every screen
  // dark; users can still choose Dark or System from theme settings.
  ThemeCubit() : super(ThemeMode.light);

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_kThemeKey);
    emit(_fromString(stored));
  }

  Future<void> setLight() => _set(ThemeMode.light);
  Future<void> setDark() => _set(ThemeMode.dark);
  Future<void> setSystem() => _set(ThemeMode.system);

  Future<void> _set(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kThemeKey, _toString(mode));
    emit(mode);
  }

  static ThemeMode _fromString(String? value) => switch (value) {
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        'system' => ThemeMode.system,
        _ => ThemeMode.light, // no stored preference → default to light
      };

  static String _toString(ThemeMode mode) => switch (mode) {
        ThemeMode.light => 'light',
        ThemeMode.dark => 'dark',
        _ => 'system',
      };
}
