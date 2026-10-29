import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/constants/app_logs.dart';
import '../../../core/models/gender_result.dart';
import '../../../core/services/result_service.dart';

enum RevealStage {
  boot,
  processing,
  reveal,
}

class RevealController extends ChangeNotifier {
  final ResultService _resultService;

  RevealStage _stage = RevealStage.boot;
  double _progress = 0.0;
  int _currentLogIndex = 0;
  LogEntry _currentLog = AppLogs.processingLogs.first;
  final List<LogEntry> _logHistory = [];
  GenderResult? _result;
  bool _isSuspensePaused = false;

  Timer? _progressTimer;
  Timer? _logTimer;
  Timer? _suspenseTimer;
  Timer? _transitionTimer;

  RevealController({ResultService? resultService})
      : _resultService = resultService ?? ResultService();

  RevealStage get stage => _stage;
  double get progress => _progress;
  LogEntry get currentLog => _currentLog;
  List<LogEntry> get logHistory => List.unmodifiable(_logHistory);
  GenderResult? get result => _result;
  bool get isSuspensePaused => _isSuspensePaused;

  Future<void> startDeploy() async {
    _cancelTimers();
    _stage = RevealStage.processing;
    _progress = 0.0;
    _currentLogIndex = 0;
    _isSuspensePaused = false;
    _logHistory.clear();
    _currentLog = AppLogs.processingLogs.first;
    _logHistory.add(_currentLog);
    notifyListeners();

    // Carrega o resultado de forma anti-spoiler em segundo plano
    _result = await _resultService.loadResult();

    // 25 logs com intervalo exato de 3 segundos entre cada um
    const int logIntervalMs = 3000;
    _logTimer = Timer.periodic(const Duration(milliseconds: logIntervalMs), (timer) {
      if (_progress >= 0.99) {
        timer.cancel();
        return;
      }
      _currentLogIndex++;
      if (_currentLogIndex < AppLogs.processingLogs.length) {
        _currentLog = AppLogs.processingLogs[_currentLogIndex];
        _logHistory.add(_currentLog);
        notifyListeners();
      } else {
        timer.cancel();
      }
    });

    // 24 transições de 3 segundos = 72 segundos para atingir 99% de forma perfeitamente sincronizada
    final int totalDurationMs = (AppLogs.processingLogs.length - 1) * logIntervalMs;
    const int tickMs = 50;
    final double step = 0.99 / (totalDurationMs / tickMs);

    _progressTimer = Timer.periodic(const Duration(milliseconds: tickMs), (timer) {
      if (_progress + step < 0.99) {
        _progress += step;
        notifyListeners();
      } else {
        // Atingiu 99%! Trava o progresso e ativa o suspense por exatamente 10 segundos
        _progress = 0.99;
        _isSuspensePaused = true;
        _currentLog = AppLogs.suspenseLog;
        _logHistory.add(_currentLog);
        timer.cancel();
        notifyListeners();

        _suspenseTimer = Timer(const Duration(seconds: 10), () {
          // Após os 10 segundos de suspense, pula para 100%
          _progress = 1.0;
          _isSuspensePaused = false;
          _currentLog = AppLogs.successLog;
          _logHistory.add(_currentLog);
          notifyListeners();

          // Aguarda 1.5s para celebração final do compilador e transiciona para a Revelação
          _transitionTimer = Timer(const Duration(milliseconds: 1500), () {
            _stage = RevealStage.reveal;
            notifyListeners();
          });
        });
      }
    });
  }

  void restart() {
    _cancelTimers();
    _stage = RevealStage.boot;
    _progress = 0.0;
    _currentLogIndex = 0;
    _logHistory.clear();
    _currentLog = AppLogs.processingLogs.first;
    _isSuspensePaused = false;
    notifyListeners();
  }

  void _cancelTimers() {
    _progressTimer?.cancel();
    _logTimer?.cancel();
    _suspenseTimer?.cancel();
    _transitionTimer?.cancel();
  }

  @override
  void dispose() {
    _cancelTimers();
    super.dispose();
  }
}
