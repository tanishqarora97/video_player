import 'package:flutter/material.dart';

import '../../meedu_player.dart';

class PlayerButton extends StatelessWidget {
  final double size;
  final String? iconPath;
  final VoidCallback onPressed;
  final Color backgroundColor, iconColor;
  final bool circle;
  final bool glass;
  final Widget? customIcon;

  const PlayerButton({
    super.key,
    this.size = 40,
    this.iconPath,
    required this.onPressed,
    this.circle = true,
    this.backgroundColor = Colors.transparent,
    this.iconColor = Colors.white,
    this.glass = false,
    this.customIcon,
  });

  @override
  Widget build(BuildContext context) {
    final child =
        customIcon ??
        Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: glass
                ? Colors.white.withValues(alpha: 0.12)
                : backgroundColor,
            shape: circle ? BoxShape.circle : BoxShape.rectangle,
            border: glass
                ? Border.all(color: Colors.white.withValues(alpha: 0.28))
                : null,
          ),
          child: Image.asset(
            iconPath!,
            color: iconColor,
            width: size * 0.48,
            height: size * 0.48,
            package: 'universal_videoplayer',
          ),
        );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        customBorder: circle ? const CircleBorder() : null,
        onTap: () {
          onPressed();
          MeeduPlayerController.of(context).controls = true;
        },
        child: child,
      ),
    );
  }
}
