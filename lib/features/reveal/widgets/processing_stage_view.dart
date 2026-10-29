import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../controllers/reveal_controller.dart';

class ProcessingStageView extends StatefulWidget {
  final RevealController controller;

  const ProcessingStageView({
    super.key,
    required this.controller,
  });

  @override
  State<ProcessingStageView> createState() => _ProcessingStageViewState();
}

class _ProcessingStageViewState extends State<ProcessingStageView>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  int _lastLogCount = 0;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _lastLogCount = widget.controller.logHistory.length;
    widget.controller.addListener(_onControllerUpdate);
  }

  void _onControllerUpdate() {
    if (widget.controller.logHistory.length != _lastLogCount) {
      _lastLogCount = widget.controller.logHistory.length;
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void didUpdateWidget(ProcessingStageView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller.removeListener(_onControllerUpdate);
      widget.controller.addListener(_onControllerUpdate);
    }
    _scrollToBottom();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerUpdate);
    _scrollController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    final percent = (controller.progress * 100).toInt();
    final isSuspense = controller.isSuspensePaused;
    final logs = controller.logHistory;

    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      child: Column(
        children: [
          // Título de Status da Pipeline (30px - Visível à distância)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSuspense ? AppColors.logWarn : AppColors.neonCyan,
                  boxShadow: [
                    BoxShadow(
                      color: (isSuspense ? AppColors.logWarn : AppColors.neonCyan)
                          .withValues(alpha: 0.9),
                      blurRadius: 22,
                      spreadRadius: 6,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Flexible(
                child: Text(
                  isSuspense
                      ? '⚠️ SUSPENSE: COMPILANDO O ÚLTIMO BYTE GENÉTICO...'
                      : '🍼 COMPILANDO NOSSO MAIOR PROJETO...',
                  style: TextStyle(
                    color: isSuspense ? AppColors.logWarn : AppColors.neonCyan,
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2.0,
                    fontFamily: 'monospace',
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Barra de Progresso Ampla e Alta com Percentual
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxWidth: 1500),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      isSuspense
                          ? '⚠️ Segurem a ansiedade! Finalizando deploy...'
                          : 'Progresso da Compilação:',
                      style: TextStyle(
                        color: isSuspense ? AppColors.logWarn : AppColors.terminalMuted,
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'monospace',
                      ),
                    ),
                    isSuspense
                        ? ScaleTransition(
                            scale: _pulseAnimation,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.logWarn.withValues(alpha: 0.25),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: AppColors.logWarn,
                                  width: 2.0,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.logWarn.withValues(alpha: 0.4),
                                    blurRadius: 18,
                                  ),
                                ],
                              ),
                              child: const Text(
                                '99% (HOLDING)',
                                style: TextStyle(
                                  color: AppColors.logWarn,
                                  fontSize: 34,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.5,
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ),
                          )
                        : Text(
                            '$percent%',
                            style: TextStyle(
                              color: percent == 100
                                  ? AppColors.logSuccess
                                  : AppColors.terminalText,
                              fontSize: 44,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.5,
                              fontFamily: 'monospace',
                            ),
                          ),
                  ],
                ),
                const SizedBox(height: 12),

                // Barra iluminada com 26px de altura
                Container(
                  height: 26,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(13),
                    boxShadow: [
                      BoxShadow(
                        color: (isSuspense ? AppColors.logWarn : AppColors.neonCyan)
                            .withValues(alpha: 0.45),
                        blurRadius: 22,
                        spreadRadius: 3,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(13),
                    child: LinearProgressIndicator(
                      value: controller.progress,
                      backgroundColor: const Color(0xFF161B22),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isSuspense
                            ? AppColors.logWarn
                            : (percent == 100
                                ? AppColors.logSuccess
                                : AppColors.neonCyan),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Console de Logs em tamanho extra grande para leitura perfeita à distância
          Expanded(
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(maxWidth: 1500),
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
              decoration: BoxDecoration(
                color: const Color(0xFF05070A),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isSuspense
                      ? AppColors.logWarn.withValues(alpha: 0.85)
                      : AppColors.windowBorder,
                  width: 2.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.9),
                    blurRadius: 28,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Console Top Header
                  Row(
                    children: [
                      const Icon(
                        Icons.terminal,
                        size: 24,
                        color: AppColors.terminalMuted,
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'STDOUT / COMPILER CONSOLE OUTPUT',
                        style: TextStyle(
                          color: AppColors.terminalMuted,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                          fontFamily: 'monospace',
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${logs.length} logs emitidos',
                        style: const TextStyle(
                          color: AppColors.terminalMuted,
                          fontSize: 16,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                  const Divider(color: AppColors.windowBorder, height: 22),

                  // Lista completa de logs ampliados preenchendo a tela
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.only(top: 8, bottom: 20),
                      itemCount: logs.length,
                      itemBuilder: (context, index) {
                        final log = logs[index];
                        final isLast = index == logs.length - 1;

                        if (isLast) {
                          // LOG ATIVO HERO: Destaque gigante (34px) com borda neon vibrante
                          return Container(
                            margin: const EdgeInsets.only(top: 12, bottom: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 22,
                              vertical: 18,
                            ),
                            decoration: BoxDecoration(
                              color: log.tagColor.withValues(alpha: 0.14),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: log.tagColor.withValues(alpha: 0.9),
                                width: 2.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: log.tagColor.withValues(alpha: 0.3),
                                  blurRadius: 22,
                                  spreadRadius: 3,
                                ),
                              ],
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(top: 4),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: log.tagColor.withValues(alpha: 0.3),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: log.tagColor,
                                      width: 1.8,
                                    ),
                                  ),
                                  child: Text(
                                    log.tag,
                                    style: TextStyle(
                                      color: log.tagColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 1.0,
                                      fontFamily: 'monospace',
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 18),
                                Expanded(
                                  child: Text(
                                    log.message,
                                    softWrap: true,
                                    style: const TextStyle(
                                      color: AppColors.terminalText,
                                      fontSize: 34,
                                      fontWeight: FontWeight.w800,
                                      height: 1.35,
                                      fontFamily: 'monospace',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        // LOGS ANTERIORES: Ampliados para 28px, nítidos e fáceis de ler de longe
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 4),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: log.tagColor.withValues(alpha: 0.16),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: log.tagColor.withValues(alpha: 0.5),
                                    width: 1.2,
                                  ),
                                ),
                                child: Text(
                                  log.tag,
                                  style: TextStyle(
                                    color: log.tagColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'monospace',
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  log.message,
                                  softWrap: true,
                                  style: const TextStyle(
                                    color: Color(0xFFE6EDF3),
                                    fontSize: 28,
                                    fontWeight: FontWeight.w600,
                                    height: 1.35,
                                    fontFamily: 'monospace',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
