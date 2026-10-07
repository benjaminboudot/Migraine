import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/theme/app_theme.dart';

/// Theme mode enum
enum AppThemeMode {
  system,
  light,
  dark,
  migraine,
}

/// Theme settings model
class ThemeSettings {
  final AppThemeMode themeMode;
  final double textScale;
  final bool useMigraineMode;

  const ThemeSettings({
    this.themeMode = AppThemeMode.system,
    this.textScale = 1.0,
    this.useMigraineMode = false,
  });

  ThemeSettings copyWith({
    AppThemeMode? themeMode,
    double? textScale,
    bool? useMigraineMode,
  }) {
    return ThemeSettings(
      themeMode: themeMode ?? this.themeMode,
      textScale: textScale ?? this.textScale,
      useMigraineMode: useMigraineMode ?? this.useMigraineMode,
    );
  }
}

/// Theme settings notifier
class ThemeSettingsNotifier extends StateNotifier<ThemeSettings> {
  static const String _themeModeKey = 'theme_mode';
  static const String _textScaleKey = 'text_scale';
  static const String _useMigraineModeKey = 'use_migraine_mode';

  ThemeSettingsNotifier() : super(const ThemeSettings()) {
    _loadSettings();
  }

  /// Load settings from shared preferences
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    
    final themeModeIndex = prefs.getInt(_themeModeKey);
    final textScale = prefs.getDouble(_textScaleKey) ?? 1.0;
    final useMigraineMode = prefs.getBool(_useMigraineModeKey) ?? false;
    
    if (themeModeIndex != null) {
      state = state.copyWith(
        themeMode: AppThemeMode.values[themeModeIndex],
        textScale: textScale,
        useMigraineMode: useMigraineMode,
      );
    }
  }

  /// Set theme mode
  Future<void> setThemeMode(AppThemeMode themeMode) async {
    state = state.copyWith(themeMode: themeMode);
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeModeKey, themeMode.index);
  }

  /// Set text scale
  Future<void> setTextScale(double textScale) async {
    state = state.copyWith(textScale: textScale);
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_textScaleKey, textScale);
  }

  /// Set migraine mode
  Future<void> setMigraineMode(bool useMigraineMode) async {
    state = state.copyWith(useMigraineMode: useMigraineMode);
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_useMigraineModeKey, useMigraineMode);
  }

  /// Toggle migraine mode
  Future<void> toggleMigraineMode() async {
    await setMigraineMode(!state.useMigraineMode);
  }

  /// Reset to default settings
  Future<void> resetToDefaults() async {
    state = const ThemeSettings();
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_themeModeKey);
    await prefs.remove(_textScaleKey);
    await prefs.remove(_useMigraineModeKey);
  }

  /// Get theme data based on current settings
  ThemeData getThemeData() {
    if (state.useMigraineMode) {
      return AppTheme.migraineModeTheme;
    }
    
    switch (state.themeMode) {
      case AppThemeMode.system:
        // Use system default
        return WidgetsBinding.instance.window.platformBrightness == Brightness.dark
            ? AppTheme.darkTheme
            : AppTheme.lightTheme;
      case AppThemeMode.light:
        return AppTheme.lightTheme;
      case AppThemeMode.dark:
        return AppTheme.darkTheme;
      case AppThemeMode.migraine:
        return AppTheme.migraineModeTheme;
    }
  }

  /// Get is dark mode
  bool get isDarkMode {
    if (state.useMigraineMode) return true;
    
    switch (state.themeMode) {
      case AppThemeMode.system:
        return WidgetsBinding.instance.window.platformBrightness == Brightness.dark;
      case AppThemeMode.light:
        return false;
      case AppThemeMode.dark:
      case AppThemeMode.migraine:
        return true;
    }
  }
}

/// Theme settings provider
final themeSettingsProvider = StateNotifierProvider<ThemeSettingsNotifier, ThemeSettings>((ref) {
  return ThemeSettingsNotifier();
});

/// Theme mode provider
final themeModeProvider = Provider<ThemeMode>((ref) {
  final themeSettings = ref.watch(themeSettingsProvider);
  
  if (themeSettings.useMigraineMode) {
    return ThemeMode.dark;
  }
  
  switch (themeSettings.themeMode) {
    case AppThemeMode.system:
      return ThemeMode.system;
    case AppThemeMode.light:
      return ThemeMode.light;
    case AppThemeMode.dark:
      return ThemeMode.dark;
    case AppThemeMode.migraine:
      return ThemeMode.dark;
  }
});

/// Text scale provider
final textScaleProvider = Provider<double>((ref) {
  final themeSettings = ref.watch(themeSettingsProvider);
  return themeSettings.textScale;
});

/// Migraine mode provider
final migraineModeProvider = Provider<bool>((ref) {
  final themeSettings = ref.watch(themeSettingsProvider);
  return themeSettings.useMigraineMode;
});

/// Is dark mode provider
final isDarkModeProvider = Provider<bool>((ref) {
  final themeSettings = ref.watch(themeSettingsProvider);
  return themeSettings.isDarkMode;
});

/// Theme data provider
final themeDataProvider = Provider<ThemeData>((ref) {
  final themeSettings = ref.watch(themeSettingsProvider);
  return themeSettings.getThemeData();
});
