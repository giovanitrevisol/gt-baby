import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class TerminalWindow extends StatelessWidget {
  final Widget child;
  final String title;
  final Color? glowColor;

  const TerminalWindow({
    super.key,
    required this.child,
    this.title = 'baby_os_terminal.sh - bash',
    this.glowColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppColors.terminalBody,
      child: SizedBox.expand(
        child: child,
      ),
    );
  }
}
