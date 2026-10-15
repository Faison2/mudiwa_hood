import 'package:flutter/material.dart';

/// Brand palette pulled from the Mudiwa Hood crest (gold on ink).
class AppColors {
  AppColors._();

  static const Color ink = Color(0xFF0E0E10);
  static const Color charcoal = Color(0xFF1C1C1F);
  static const Color paper = Color(0xFFFAFAF7);
  static const Color card = Color(0xFFF2F1EC);
  static const Color line = Color(0xFFE7E5DD);
  static const Color muted = Color(0xFF8A8A8E);

  static const Color gold = Color(0xFFC9A227);
  static const Color goldLight = Color(0xFFE4C878);
  static const Color goldDeep = Color(0xFF9C7D1C);

  static const Color danger = Color(0xFFD64545);

  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [goldLight, gold, goldDeep],
  );

  static const LinearGradient inkGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF1C1C1F), ink, Color(0xFF0B0B0C)],
  );
}

class AppTheme {
  AppTheme._();

  static const LinearGradient navActiveGradient = LinearGradient(
    colors: [Color(0xFF1C1C1F), Color(0xFF0B0B0C)],
  );

  static ThemeData get light {
    final base = ThemeData.light(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.paper,
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.ink,
        secondary: AppColors.gold,
        surface: AppColors.paper,
      ),
      textTheme: base.textTheme.apply(
        bodyColor: AppColors.ink,
        displayColor: AppColors.ink,
      ),
      splashFactory: InkRipple.splashFactory,
      highlightColor: Colors.transparent,
      dividerColor: AppColors.line,
      iconTheme: const IconThemeData(color: AppColors.ink),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }
}
