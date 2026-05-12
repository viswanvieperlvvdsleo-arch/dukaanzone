import 'package:flutter/material.dart';

const primary = Color(0xFF628ECB);
const ink = Color(0xFF172033);
const muted = Color(0xFF8A94A6);
const success = Color(0xFF059669);
const bgLight = Color(0xFFF9FAFB);
const bgDark = Color(0xFF0B0F19); // User spec: Obsidian/Midnight
const bg = bgLight; // Alias for backward compatibility

final navGradient = const LinearGradient(
  colors: [primary, Color(0xFF404040)], 
  begin: Alignment.topLeft, 
  end: Alignment.bottomRight
);

final neonGlow = [
  BoxShadow(
    color: primary.withOpacity(0.3),
    blurRadius: 20,
    spreadRadius: 2,
  )
];

final shadowSm = [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 3))];
final shadowLg = [BoxShadow(color: Colors.black.withOpacity(0.09), blurRadius: 20, offset: const Offset(0, 12))];

class AppTheme {
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: bgLight,
    colorScheme: ColorScheme.fromSeed(seedColor: primary, brightness: Brightness.light),
    fontFamily: 'Inter',
    splashFactory: InkRipple.splashFactory,
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
      },
    ),
  );

  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: bgDark,
    colorScheme: ColorScheme.fromSeed(seedColor: primary, brightness: Brightness.dark, background: bgDark),
    fontFamily: 'Inter',
    splashFactory: InkRipple.splashFactory,
    cardTheme: CardThemeData(
      color: const Color(0xFF1A1F2B),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
      },
    ),
  );
}
