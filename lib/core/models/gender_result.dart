import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

enum GenderType {
  boy,
  girl,
}

class GenderResult {
  final GenderType type;

  const GenderResult({required this.type});

  bool get isBoy => type == GenderType.boy;
  bool get isGirl => type == GenderType.girl;

  String get babyName => isBoy ? 'Pietro' : 'Pietra';

  String get releaseTag => isBoy ? 'v1.0.0-pietro' : 'v1.0.0-pietra';

  String get revealTitle => isBoy ? 'PIETRO A CAMINHO... 💙' : 'PIETRA A CAMINHO... 💖';

  String get subTitle => 'O amor de Lara & Giovani agora tem nome.';

  String get releaseNotes =>
      'O amor de Lara & Giovani agora tem nome e está compilado com sucesso para a vida.';

  Color get primaryColor => isBoy ? AppColors.boyPrimary : AppColors.girlPrimary;
  Color get neonColor => isBoy ? AppColors.boyNeon : AppColors.girlNeon;
  Color get deepColor => isBoy ? AppColors.boyDeep : AppColors.girlDeep;
  List<Color> get confettiColors =>
      isBoy ? AppColors.boyConfettiColors : AppColors.girlConfettiColors;

  factory GenderResult.fromString(String raw) {
    final cleaned = raw.toLowerCase().trim();
    if (cleaned.contains('menina') ||
        cleaned.contains('girl') ||
        cleaned.contains('female') ||
        cleaned.contains('pietra')) {
      return const GenderResult(type: GenderType.girl);
    }
    return const GenderResult(type: GenderType.boy);
  }

  factory GenderResult.fromJson(Map<String, dynamic> json) {
    final value = json['resultado'] ?? json['gender'] ?? json['result'] ?? 'menino';
    return GenderResult.fromString(value.toString());
  }
}
