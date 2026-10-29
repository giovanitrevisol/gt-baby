import 'package:flutter/material.dart';

abstract class AppColors {
  // Pure IDE / Dark Theme (sem tons verdes no fundo)
  static const Color background = Color(0xFF090D12);
  static const Color windowHeader = Color(0xFF161B22);
  static const Color windowBorder = Color(0xFF21262D);
  static const Color terminalBody = Color(0xFF0D1117);
  static const Color cardSurface = Color(0xFF131820);

  // Window Controls
  static const Color closeButton = Color(0xFFFF5F56);
  static const Color minimizeButton = Color(0xFFFFBD2E);
  static const Color maximizeButton = Color(0xFF27C93F);

  // Accents / Neon Glow
  static const Color neonCyan = Color(0xFF00F0FF);
  static const Color neonBlue = Color(0xFF2F80ED);
  static const Color neonGreen = Color(0xFF3FB950);
  static const Color terminalText = Color(0xFFF0F6FC);
  static const Color terminalMuted = Color(0xFF8B949E);

  // Log Tag Colors
  static const Color logInfo = Color(0xFF58A6FF);
  static const Color logWarn = Color(0xFFE3B341);
  static const Color logError = Color(0xFFFF7B72);
  static const Color logSuccess = Color(0xFF3FB950);

  // Boy Palette (Tons vibrantes de Azul / Ciano / Safira)
  static const Color boyPrimary = Color(0xFF0070F3);
  static const Color boyNeon = Color(0xFF00D2FF);
  static const Color boyDeep = Color(0xFF0D253F);
  static const Color boyLight = Color(0xFF70A1FF);
  static const List<Color> boyConfettiColors = [
    Color(0xFF0070F3),
    Color(0xFF00D2FF),
    Color(0xFF1E90FF),
    Color(0xFF00FFFF),
    Color(0xFF70A1FF),
    Color(0xFF3867D6),
    Color(0xFFFFFFFF),
    Color(0xFFFFD700), // Dourado festivo
  ];

  // Girl Palette (Tons vibrantes de Rosa / Lilás / Magenta)
  static const Color girlPrimary = Color(0xFFFF1493);
  static const Color girlNeon = Color(0xFFFF2E93);
  static const Color girlDeep = Color(0xFF3D0C2A);
  static const Color girlLight = Color(0xFFFF9FF3);
  static const List<Color> girlConfettiColors = [
    Color(0xFFFF1493),
    Color(0xFFFF69B4),
    Color(0xFFD946EF),
    Color(0xFFA855F7),
    Color(0xFFFF9FF3),
    Color(0xFFF368E0),
    Color(0xFFFFFFFF),
    Color(0xFFFFD700), // Dourado festivo
  ];
}
