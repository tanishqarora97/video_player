import 'package:flutter/material.dart';

import '../../meedu_player.dart';

class PlayerButton extends StatelessWidget {
  final double size;
  final String? iconPath;
  final IconData? icon;
  final VoidCallback onPressed;
  final Color backgroundColor, iconColor;
  final bool circle;
  final bool glass;
  final Widget? customIcon;

  const PlayerButton({
    super.key,
    this.size = 40,
    this.iconPath,
    this.icon,
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
                ? Colors.white.withValues(alpha: 0.14)
                : backgroundColor,
            shape: circle ? BoxShape.circle : BoxShape.rectangle,
            borderRadius: circle ? null : BorderRadius.circular(8),
            border: glass
                ? Border.all(color: Colors.white.withValues(alpha: 0.28))
                : null,
          ),
          child: icon != null
              ? Icon(icon, color: iconColor, size: size * (glass ? 0.52 : 0.58))
              : Image.asset(
                  iconPath!,
                  color: iconColor,
                  width: size * 0.5,
                  height: size * 0.5,
                  package: 'universal_videoplayer',
                ),
        );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        customBorder: circle
            ? const CircleBorder()
            : RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        onTap: () {
          onPressed();
          MeeduPlayerController.of(context).controls = true;
        },
        child: child,
      ),
    );
  }
}
