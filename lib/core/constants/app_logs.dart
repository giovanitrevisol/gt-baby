import 'package:flutter/material.dart';
import 'app_colors.dart';

enum LogLevel { info, warn, error, success }

class LogEntry {
  final LogLevel level;
  final String tag;
  final String message;

  const LogEntry({
    required this.level,
    required this.tag,
    required this.message,
  });

  Color get tagColor {
    switch (level) {
      case LogLevel.info:
        return AppColors.logInfo;
      case LogLevel.warn:
        return AppColors.logWarn;
      case LogLevel.error:
        return AppColors.logError;
      case LogLevel.success:
        return AppColors.logSuccess;
    }
  }

  String get fullText => '$tag $message';
}

abstract class AppLogs {
  static const List<LogEntry> processingLogs = [
    LogEntry(
      level: LogLevel.info,
      tag: '[INFO]',
      message: 'Conectando ao repositório central: familia-lara-giovani/baby...',
    ),
    LogEntry(
      level: LogLevel.info,
      tag: '[INFO]',
      message: 'Sincronizando branch principal de produção...',
    ),
    LogEntry(
      level: LogLevel.info,
      tag: '[INFO]',
      message: 'Resolvendo merge genético: 50% Giovani (Papai) + 50% Lara (Mamãe)...',
    ),
    LogEntry(
      level: LogLevel.info,
      tag: '[INFO]',
      message: 'Merge aprovado sem conflitos! Combinação perfeita detectada ❤️',
    ),
    LogEntry(
      level: LogLevel.warn,
      tag: '[WARN]',
      message: "Baixando pacote 'Privação de Sono 24/7' (Tamanho: 100TB)...",
    ),
    LogEntry(
      level: LogLevel.info,
      tag: '[INFO]',
      message: 'Alocando memória RAM da Lara e do Giovani para trocar fralda no escuro...',
    ),
    LogEntry(
      level: LogLevel.info,
      tag: '[INFO]',
      message: 'Instalando drivers de sono leve (qualquer suspiro acorda os pais)...',
    ),
    LogEntry(
      level: LogLevel.warn,
      tag: '[WARN]',
      message: 'Memória RAM do Giovani operando em 10% (Sobrecarga de café)...',
    ),
    LogEntry(
      level: LogLevel.warn,
      tag: '[WARN]',
      message: 'CPU da Lara operando em 100% (Preocupação de mãe checando cada detalhe pela 20ª vez)...',
    ),
    LogEntry(
      level: LogLevel.info,
      tag: '[INFO]',
      message: 'Compilando biblioteca de gargalhadas, bochechas fofas e dobrinhas...',
    ),
    LogEntry(
      level: LogLevel.info,
      tag: '[INFO]',
      message: 'Atualizando firmware do berço e sensor acústico de resmungos...',
    ),
    LogEntry(
      level: LogLevel.error,
      tag: '[ERROR]',
      message: 'Chupeta caiu no chão! Tentando restaurar do backup...',
    ),
    LogEntry(
      level: LogLevel.info,
      tag: '[INFO]',
      message: 'Chupeta esterilizada com sucesso!',
    ),
    LogEntry(
      level: LogLevel.warn,
      tag: '[WARN]',
      message: "Modo 'Dormir a noite toda': Erro 404 (Not Found)...",
    ),
    LogEntry(
      level: LogLevel.info,
      tag: '[INFO]',
      message: 'Calibrando bochechas gordinhas, pezinhos e dedinhos...',
    ),
    LogEntry(
      level: LogLevel.info,
      tag: '[INFO]',
      message: 'Executando testes unitários: Teste do Bocejo Fofo [PASS]...',
    ),
    LogEntry(
      level: LogLevel.info,
      tag: '[INFO]',
      message: 'Aplicando boas práticas: muito colinho, carinho e denguinho...',
    ),
    LogEntry(
      level: LogLevel.info,
      tag: '[INFO]',
      message: 'Carregando roupinhas tamanho RN e sapatinhos minúsculos...',
    ),
    LogEntry(
      level: LogLevel.info,
      tag: '[INFO]',
      message: 'Configurando rotina de banho quentinho com patinho de borracha...',
    ),
    LogEntry(
      level: LogLevel.info,
      tag: '[INFO]',
      message: 'Verificando integridade dos pacotes de saúde, bênçãos e amor infinito...',
    ),
    LogEntry(
      level: LogLevel.warn,
      tag: '[WARN]',
      message: 'Descriptografando o resultado final... Segurem a ansiedade!',
    ),
  ];

  static const LogEntry suspenseLog = LogEntry(
    level: LogLevel.warn,
    tag: '[SUSPENSE]',
    message: 'Travado em 99%! Giovani e Lara, o grande momento chegou...',
  );
  static const LogEntry successLog = LogEntry(
    level: LogLevel.success,
    tag: '[SUCCESS]',
    message: 'Bebê compilado com 100% de sucesso! Deploy em Produção liberado!',
  );
}
