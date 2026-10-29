import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/gender_result.dart';

class RevealStageView extends StatefulWidget {
  final GenderResult result;
  final VoidCallback onRestart;

  const RevealStageView({
    super.key,
    required this.result,
    required this.onRestart,
  });

  @override
  State<RevealStageView> createState() => _RevealStageViewState();
}

class _RevealStageViewState extends State<RevealStageView>
    with TickerProviderStateMixin {
  late ConfettiController _topConfettiController;
  late ConfettiController _leftConfettiController;
  late ConfettiController _rightConfettiController;

  late AnimationController _mainAnimController;
  late AnimationController _raysController;
  late AnimationController _pulseController;

  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();

    // 1. Canhões de Confetes
    _topConfettiController = ConfettiController(
      duration: const Duration(seconds: 45),
    );
    _leftConfettiController = ConfettiController(
      duration: const Duration(seconds: 45),
    );
    _rightConfettiController = ConfettiController(
      duration: const Duration(seconds: 45),
    );

    _topConfettiController.play();
    _leftConfettiController.play();
    _rightConfettiController.play();

    // 2. Animação de Rotação Suave dos Feixes de Holofote no Fundo
    _raysController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 24),
    )..repeat();

    // 3. Animação de Pulso Neon do Terminal
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // 4. Entrada Hero do Painel de Release
    _mainAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _mainAnimController,
      curve: Curves.easeOutBack,
    );

    _mainAnimController.forward();
  }

  @override
  void dispose() {
    _topConfettiController.dispose();
    _leftConfettiController.dispose();
    _rightConfettiController.dispose();
    _mainAnimController.dispose();
    _raysController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final result = widget.result;
    final themeColor = result.primaryColor;
    final neonColor = result.neonColor;
    final confettiColors = result.confettiColors;

    return Stack(
      children: [
        // FUNDO: Feixes de Luz e Aura Neon
        Positioned.fill(
          child: AnimatedBuilder(
            animation: Listenable.merge([_raysController, _glowAnimation]),
            builder: (context, _) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: Alignment.center,
                        radius: 1.3,
                        colors: [
                          neonColor.withValues(
                            alpha: 0.28 * _glowAnimation.value,
                          ),
                          themeColor.withValues(
                            alpha: 0.12 * _glowAnimation.value,
                          ),
                          AppColors.terminalBody,
                        ],
                      ),
                    ),
                  ),
                  CustomPaint(
                    painter: _StageRaysPainter(
                      color: neonColor.withValues(
                        alpha: 0.08 * _glowAnimation.value,
                      ),
                      rotation: _raysController.value * 2 * pi,
                    ),
                  ),
                ],
              );
            },
          ),
        ),

        // CANHÃO 1: Topo
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _topConfettiController,
            blastDirection: pi / 2,
            maxBlastForce: 14,
            minBlastForce: 4,
            emissionFrequency: 0.12,
            numberOfParticles: 40,
            gravity: 0.14,
            shouldLoop: true,
            colors: confettiColors,
          ),
        ),

        // CANHÃO 2: Esquerda
        Align(
          alignment: Alignment.bottomLeft,
          child: ConfettiWidget(
            confettiController: _leftConfettiController,
            blastDirection: -pi / 3,
            maxBlastForce: 32,
            minBlastForce: 16,
            emissionFrequency: 0.10,
            numberOfParticles: 25,
            gravity: 0.2,
            shouldLoop: true,
            colors: confettiColors,
          ),
        ),

        // CANHÃO 3: Direita
        Align(
          alignment: Alignment.bottomRight,
          child: ConfettiWidget(
            confettiController: _rightConfettiController,
            blastDirection: -2 * pi / 3,
            maxBlastForce: 32,
            minBlastForce: 16,
            emissionFrequency: 0.10,
            numberOfParticles: 25,
            gravity: 0.2,
            shouldLoop: true,
            colors: confettiColors,
          ),
        ),

        // CONTEÚDO PRINCIPAL: PAINEL DE RELEASE AMPLIADO (NERD / TECH)
        Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(maxWidth: 1350),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 48,
                      vertical: 40,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF070B10),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: neonColor.withValues(alpha: 0.85),
                        width: 2.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: neonColor.withValues(alpha: 0.4),
                          blurRadius: 56,
                          spreadRadius: 6,
                        ),
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.9),
                          blurRadius: 36,
                          offset: const Offset(0, 14),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // CABEÇALHO CI/CD / GITHUB RELEASE (AMPLIADO)
                        LayoutBuilder(
                          builder: (context, constraints) {
                            return Wrap(
                              spacing: 16,
                              runSpacing: 12,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              alignment: WrapAlignment.spaceBetween,
                              children: [
                                // Status 200 OK
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.logSuccess.withValues(alpha: 0.18),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: AppColors.logSuccess,
                                      width: 1.8,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 10,
                                        height: 10,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppColors.logSuccess,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      const Text(
                                        '200 OK | DEPLOYED TO PRODUCTION',
                                        style: TextStyle(
                                          color: AppColors.logSuccess,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: 1.0,
                                          fontFamily: 'monospace',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Git Release Tag
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: neonColor.withValues(alpha: 0.14),
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: neonColor.withValues(alpha: 0.6),
                                          width: 1.2,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.sell_rounded,
                                            size: 18,
                                            color: neonColor,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            result.releaseTag,
                                            style: TextStyle(
                                              color: neonColor,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'monospace',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 14),

                                    // Maintainers
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF161B22),
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: AppColors.windowBorder,
                                          width: 1.2,
                                        ),
                                      ),
                                      child: const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.people_alt_rounded,
                                            size: 18,
                                            color: AppColors.terminalMuted,
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            'Maintainers: Lara & Giovani',
                                            style: TextStyle(
                                              color: AppColors.terminalText,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: 'monospace',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),

                        const SizedBox(height: 24),
                        Divider(
                          color: neonColor.withValues(alpha: 0.35),
                          height: 1,
                        ),
                        const SizedBox(height: 36),

                        // TARGET IDENTIFIER
                        Text(
                          '> TARGET RELEASE IDENTIFIED:',
                          style: TextStyle(
                            color: AppColors.terminalMuted.withValues(alpha: 0.85),
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2.0,
                            fontFamily: 'monospace',
                          ),
                        ),
                        const SizedBox(height: 16),

                        // O NOME GIGANTE NEON (HERO SHOWSTOPPER - 102px)
                        Center(
                          child: AnimatedBuilder(
                            animation: _glowAnimation,
                            builder: (context, _) {
                              return Text(
                                result.revealTitle,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 102,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  letterSpacing: 4.0,
                                  fontFamily: 'monospace',
                                  shadows: [
                                    Shadow(
                                      color: neonColor,
                                      blurRadius: 52 * _glowAnimation.value,
                                    ),
                                    Shadow(
                                      color: themeColor,
                                      blurRadius: 100 * _glowAnimation.value,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 36),
                        Divider(
                          color: neonColor.withValues(alpha: 0.35),
                          height: 1,
                        ),
                        const SizedBox(height: 28),

                        // RELEASE NOTES & SPECS AFETUOSAS (AMPLIADAS)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '>',
                              style: TextStyle(
                                color: AppColors.neonCyan,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'monospace',
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Release Notes: ${result.releaseNotes}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 26,
                                      fontWeight: FontWeight.w700,
                                      height: 1.4,
                                      fontFamily: 'monospace',
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 18,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF0F141C),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: AppColors.windowBorder,
                                        width: 1.2,
                                      ),
                                    ),
                                    child: Text(
                                      '\$ baby-core --version=1.0.0 --env=production --status=healthy_and_loved --health=100%',
                                      style: TextStyle(
                                        color: AppColors.terminalMuted,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'monospace',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // BOTÃO DE REINICIAR ESTILO COMANDO DE TERMINAL (AMPLIADO)
                TextButton.icon(
                  onPressed: widget.onRestart,
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.terminalMuted,
                    backgroundColor: const Color(0xFF161B22),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 36,
                      vertical: 18,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(
                        color: AppColors.windowBorder,
                        width: 1.5,
                      ),
                    ),
                  ),
                  icon: const Icon(Icons.terminal_rounded, size: 22),
                  label: const Text(
                    '\$ ./restart_deploy.sh (Reiniciar Deploy)',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.0,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// Pintor de feixes de luz giratórios para efeito de palco triunfal
class _StageRaysPainter extends CustomPainter {
  final Color color;
  final double rotation;

  _StageRaysPainter({
    required this.color,
    required this.rotation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = max(size.width, size.height) * 1.25;
    const numRays = 16;
    const angleStep = (2 * pi) / numRays;
    const rayWidth = angleStep * 0.45;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation);

    for (int i = 0; i < numRays; i++) {
      final startAngle = i * angleStep;
      final path = Path()
        ..moveTo(0, 0)
        ..lineTo(
          radius * cos(startAngle - rayWidth / 2),
          radius * sin(startAngle - rayWidth / 2),
        )
        ..lineTo(
          radius * cos(startAngle + rayWidth / 2),
          radius * sin(startAngle + rayWidth / 2),
        )
        ..close();

      canvas.drawPath(path, paint);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(_StageRaysPainter oldDelegate) {
    return oldDelegate.rotation != rotation || oldDelegate.color != color;
  }
}
