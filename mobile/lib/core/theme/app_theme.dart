import 'package:flutter/material.dart';

class AppColors {
  // Light theme colors
  static const primary = Color(0xFF6C63FF);
  static const primaryLight = Color(0xFF8A85FF);
  static const primaryDark = Color(0xFF4A42E0);
  static const secondary = Color(0xFFFF6B6B);
  static const secondaryLight = Color(0xFFFF8D8D);
  static const secondaryDark = Color(0xFFE04F4F);
  
  // Neutral colors
  static const white = Color(0xFFFFFFFF);
  static const black = Color(0xFF000000);
  static const grey50 = Color(0xFFF5F7FA);
  static const grey100 = Color(0xFFF0F2F5);
  static const grey200 = Color(0xFFE0E4EA);
  static const grey300 = Color(0xFFD1D9E6);
  static const grey400 = Color(0xFFB8C5D6);
  static const grey500 = Color(0xFF9AA8BC);
  static const grey600 = Color(0xFF7A899C);
  static const grey700 = Color(0xFF5A6A7C);
  static const grey800 = Color(0xFF3A4A5C);
  static const grey900 = Color(0xFF1A2A3C);
  
  // Semantic colors
  static const success = Color(0xFF4CAF50);
  static const successLight = Color(0xFF81C784);
  static const warning = Color(0xFFFFC107);
  static const warningLight = Color(0xFFFFE082);
  static const error = Color(0xFFF44336);
  static const errorLight = Color(0xFFE57373);
  static const info = Color(0xFF2196F3);
  static const infoLight = Color(0xFF64B5F6);
  
  // Migraine mode colors (low contrast, dark)
  static const migraineBg = Color(0xFF121212);
  static const migraineSurface = Color(0xFF1E1E1E);
  static const migrainePrimary = Color(0xFFB39DDB);
  static const migraineText = Color(0xFFE0E0E0);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        primaryContainer: AppColors.primaryLight,
        secondary: AppColors.secondary,
        secondaryContainer: AppColors.secondaryLight,
        surface: AppColors.white,
        error: AppColors.error,
        onPrimary: AppColors.white,
        onSecondary: AppColors.white,
        onSurface: AppColors.grey900,
        onError: AppColors.white,
      ),
      scaffoldBackgroundColor: AppColors.grey50,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.grey900,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.grey900,
        ),
      ),
      cardTheme: CardTheme(
        color: AppColors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          side: const BorderSide(
            color: AppColors.primary,
            width: 1.5,
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.grey100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: AppColors.grey300,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: AppColors.error,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: AppColors.error,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        labelStyle: const TextStyle(
          color: AppColors.grey600,
          fontSize: 14,
        ),
        hintStyle: const TextStyle(
          color: AppColors.grey500,
          fontSize: 14,
        ),
        errorStyle: const TextStyle(
          color: AppColors.error,
          fontSize: 12,
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        elevation: 4,
        shape: CircleBorder(),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.grey500,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.grey200,
        thickness: 1,
        space: 1,
      ),
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith<Color>(
          (states) {
            if (states.contains(MaterialState.selected)) {
              return AppColors.primary;
            }
            return AppColors.grey400;
          },
        ),
        trackColor: MaterialStateProperty.resolveWith<Color>(
          (states) {
            if (states.contains(MaterialState.selected)) {
              return AppColors.primary.withOpacity(0.5);
            }
            return AppColors.grey300;
          },
        ),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.primary,
        inactiveTrackColor: AppColors.grey300,
        thumbColor: AppColors.primary,
        overlayColor: AppColors.primary.withOpacity(0.2),
        valueIndicatorColor: AppColors.primary,
        trackHeight: 4,
        thumbShape: const RoundSliderThumbShape(
          enabledThumbRadius: 10,
        ),
        overlayShape: const RoundSliderOverlayShape(
          overlayRadius: 20,
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
        linearTrackColor: AppColors.grey300,
        circularTrackColor: AppColors.grey300,
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: AppColors.grey900,
        contentTextStyle: TextStyle(
          color: AppColors.white,
          fontSize: 14,
        ),
        actionTextColor: AppColors.primary,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
      ),
      dialogTheme: const DialogTheme(
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.white,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(16),
          ),
        ),
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.grey900,
        ),
        contentTextStyle: TextStyle(
          fontSize: 14,
          color: AppColors.grey700,
        ),
      ),
      timePickerTheme: TimePickerThemeData(
        backgroundColor: AppColors.white,
        hourMinuteColor: AppColors.primary,
        hourMinuteTextColor: AppColors.white,
        dialBackgroundColor: AppColors.grey100,
        dialTextColor: AppColors.grey700,
        entryModeIconColor: AppColors.primary,
      ),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: AppColors.white,
        headerBackgroundColor: AppColors.primary,
        headerForegroundColor: AppColors.white,
        todayBackgroundColor: MaterialStateColor.resolveWith(
          (states) => AppColors.primary.withOpacity(0.2),
        ),
        todayForegroundColor: MaterialStateColor.resolveWith(
          (states) => AppColors.primary,
        ),
        selectedDayBackgroundColor: MaterialStateColor.resolveWith(
          (states) => AppColors.primary,
        ),
        selectedDayForegroundColor: MaterialStateColor.resolveWith(
          (states) => AppColors.white,
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.grey900,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: AppColors.grey900,
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.grey900,
        ),
        headlineLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: AppColors.grey900,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.grey900,
        ),
        headlineSmall: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.grey900,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.grey900,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.grey900,
        ),
        titleSmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.grey900,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: AppColors.grey700,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: AppColors.grey700,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: AppColors.grey600,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.grey700,
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.grey600,
        ),
        labelSmall: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.normal,
          color: AppColors.grey500,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        primaryContainer: AppColors.primaryDark,
        secondary: AppColors.secondary,
        secondaryContainer: AppColors.secondaryDark,
        surface: AppColors.grey900,
        error: AppColors.error,
        onPrimary: AppColors.white,
        onSecondary: AppColors.white,
        onSurface: AppColors.grey100,
        onError: AppColors.white,
      ),
      scaffoldBackgroundColor: AppColors.grey900,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.grey900,
        foregroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.white,
        ),
      ),
      cardTheme: CardTheme(
        color: AppColors.grey800,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          side: const BorderSide(
            color: AppColors.primary,
            width: 1.5,
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.grey800,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: AppColors.grey600,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        labelStyle: const TextStyle(
          color: AppColors.grey400,
          fontSize: 14,
        ),
        hintStyle: const TextStyle(
          color: AppColors.grey500,
          fontSize: 14,
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.grey900,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.grey500,
        type: BottomNavigationBarType.fixed,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.grey700,
        thickness: 1,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.white,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: AppColors.white,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: AppColors.grey300,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: AppColors.grey300,
        ),
      ),
    );
  }

  static ThemeData get migraineModeTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.migrainePrimary,
        secondary: AppColors.migrainePrimary,
        surface: AppColors.migraineSurface,
        onPrimary: AppColors.migraineText,
        onSurface: AppColors.migraineText,
      ),
      scaffoldBackgroundColor: AppColors.migraineBg,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.migraineSurface,
        foregroundColor: AppColors.migraineText,
        elevation: 0,
      ),
      cardTheme: CardTheme(
        color: AppColors.migraineSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.migrainePrimary,
          foregroundColor: AppColors.migraineText,
          padding: const EdgeInsets.symmetric(
            horizontal: 32,
            vertical: 20,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.bold,
          color: AppColors.migraineText,
        ),
        bodyLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.normal,
          color: AppColors.migraineText,
        ),
      ),
    );
  }
}
