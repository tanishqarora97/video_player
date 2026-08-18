import 'package:flutter/material.dart';
import 'package:flutter_meedu/rx/rx_builder.dart';
import '../../meedu_player.dart';

class FullscreenButton extends StatelessWidget {
  final double size;
  const FullscreenButton({super.key, this.size = 30});

  @override
  Widget build(BuildContext context) {
    final p = MeeduPlayerController.of(context);
    return RxBuilder((_) {
      final isFullscreen = p.fullscreen.value;
      return PlayerButton(
        size: size,
        icon: isFullscreen
            ? Icons.fullscreen_exit_rounded
            : Icons.fullscreen_rounded,
        iconColor: Colors.white,
        customIcon: isFullscreen
            ? p.customIcons.minimize
            : p.customIcons.fullscreen,
        onPressed: () {
          p.toggleFullScreen(context);
        },
      );
    });
  }
}
