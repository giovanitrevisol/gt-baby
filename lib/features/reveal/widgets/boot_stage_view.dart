import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class BootStageView extends StatefulWidget {
  final VoidCallback onStartDeploy;

  const BootStageView({
    super.key,
    required this.onStartDeploy,
  });

  @override
  State<BootStageView> createState() => _BootStageViewState();
}

class _BootStageViewState extends State<BootStageView>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.06).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ícone Tech de Inicialização (Ampliado para telão)
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.neonCyan.withValues(alpha: 0.1),
                border: Border.all(
                  color: AppColors.neonCyan.withValues(alpha: 0.5),
                  width: 2.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.neonCyan.withValues(alpha: 0.3),
                    blurRadius: 36,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: const Icon(
                Icons.terminal_rounded,
                size: 80,
                color: AppColors.neonCyan,
              ),
            ),
            const SizedBox(height: 44),

            // Texto animado com efeito Typewriter: "Booting BabyOS v1.0..."
            DefaultTextStyle(
              style: const TextStyle(
                fontSize: 52,
                fontWeight: FontWeight.w800,
                color: AppColors.terminalText,
                letterSpacing: 2.0,
                fontFamily: 'monospace',
              ),
              child: AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText(
                    'Booting BabyOS v1.0...',
                    speed: const Duration(milliseconds: 90),
                    cursor: '█',
                  ),
                ],
                isRepeatingAnimation: false,
              ),
            ),
            const SizedBox(height: 20),

            // Subtexto de console ampliado para o público ler
            Text(
              '> Package gender_reveal ready. All production pipelines standby.',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: AppColors.terminalMuted.withValues(alpha: 0.9),
                letterSpacing: 0.8,
                fontFamily: 'monospace',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 64),

            // Botão Grande Moderno e Chamativo: "INICIAR DEPLOY"
            ScaleTransition(
              scale: _pulseAnimation,
              child: MouseRegion(
                onEnter: (_) => setState(() => _isHovered = true),
                onExit: (_) => setState(() => _isHovered = false),
                cursor: SystemMouseCursors.click,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    gradient: LinearGradient(
                      colors: _isHovered
                          ? [const Color(0xFF00F0FF), const Color(0xFF0070F3)]
                          : [const Color(0xFF00D2FF), const Color(0xFF0052D4)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF00F0FF).withValues(
                          alpha: _isHovered ? 0.7 : 0.45,
                        ),
                        blurRadius: _isHovered ? 36 : 22,
                        spreadRadius: _isHovered ? 4 : 2,
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: widget.onStartDeploy,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 64,
                          vertical: 24,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.rocket_launch_rounded,
                              color: Colors.white,
                              size: 34,
                            ),
                            SizedBox(width: 18),
                            Text(
                              'INICIAR DEPLOY',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2.0,
                                fontFamily: 'monospace',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
