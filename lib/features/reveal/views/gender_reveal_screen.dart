import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../controllers/reveal_controller.dart';
import '../widgets/boot_stage_view.dart';
import '../widgets/processing_stage_view.dart';
import '../widgets/reveal_stage_view.dart';
import '../widgets/terminal_window.dart';

class GenderRevealScreen extends StatefulWidget {
  const GenderRevealScreen({super.key});

  @override
  State<GenderRevealScreen> createState() => _GenderRevealScreenState();
}

class _GenderRevealScreenState extends State<GenderRevealScreen> {
  late final RevealController _controller;

  @override
  void initState() {
    super.initState();
    _controller = RevealController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: ListenableBuilder(
        listenable: _controller,
        builder: (context, _) {
          Color? currentGlow;
          String terminalTitle = 'baby_os_terminal.sh - bash';

          if (_controller.stage == RevealStage.reveal &&
              _controller.result != null) {
            final res = _controller.result!;
            currentGlow = res.neonColor;
            terminalTitle = res.isBoy
                ? 'production_release_boy.sh - [SUCCESS 💙]'
                : 'production_release_girl.sh - [SUCCESS 💖]';
          } else if (_controller.isSuspensePaused) {
            currentGlow = AppColors.logWarn;
          }

          return TerminalWindow(
            title: terminalTitle,
            glowColor: currentGlow,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              child: _buildCurrentStageView(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCurrentStageView() {
    switch (_controller.stage) {
      case RevealStage.boot:
        return BootStageView(
          key: const ValueKey('boot_stage'),
          onStartDeploy: () => _controller.startDeploy(),
        );

      case RevealStage.processing:
        return ProcessingStageView(
          key: const ValueKey('processing_stage'),
          controller: _controller,
        );

      case RevealStage.reveal:
        final result = _controller.result;
        if (result == null) {
          return const SizedBox.shrink();
        }
        return RevealStageView(
          key: const ValueKey('reveal_stage'),
          result: result,
          onRestart: () => _controller.restart(),
        );
    }
  }
}
