import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/gender_result.dart';

class ResultService {
  static const String _assetPath = 'assets/resultado.json';

  Future<GenderResult> loadResult() async {
    try {
      final jsonString = await rootBundle.loadString(_assetPath, cache: false);
      final dynamic decoded = jsonDecode(jsonString);
      if (decoded is Map<String, dynamic>) {
        return GenderResult.fromJson(decoded);
      }
      return const GenderResult(type: GenderType.boy);
    } catch (e) {
      // Fallback seguro caso haja erro na leitura do arquivo
      return const GenderResult(type: GenderType.boy);
    }
  }
}
