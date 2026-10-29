import 'package:flutter/material.dart';
import 'core/constants/app_colors.dart';
import 'features/reveal/views/gender_reveal_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BabyOsApp());
}

class BabyOsApp extends StatelessWidget {
  const BabyOsApp({super.key});

  @override
  Widget build(BuildContext context) {
    const monoFontFamily = 'monospace';
    const monoFontFallbacks = [
      'JetBrains Mono',
      'Fira Code',
      'Consolas',
      'Menlo',
      'Monaco',
      'Courier New',
      'monospace',
    ];

    final baseTextTheme = ThemeData.dark().textTheme.apply(
          fontFamily: monoFontFamily,
          fontFamilyFallback: monoFontFallbacks,
        );

    return MaterialApp(
      title: 'BabyOS v1.0 - Chá Revelação',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.neonCyan,
          secondary: AppColors.neonGreen,
          surface: AppColors.terminalBody,
        ),
        fontFamily: monoFontFamily,
        fontFamilyFallback: monoFontFallbacks,
        textTheme: baseTextTheme,
        useMaterial3: true,
      ),
      home: const GenderRevealScreen(),
    );
  }
}
