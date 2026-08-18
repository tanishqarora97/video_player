import 'package:flutter/material.dart';
import 'package:flutter_meedu/rx/rx_builder.dart';
import '../../meedu_player.dart';

class PlayPauseButton extends StatelessWidget {
  final double size;
  const PlayPauseButton({super.key, this.size = 40});

  @override
  Widget build(BuildContext context) {
    final p = MeeduPlayerController.of(context);
    return RxBuilder((_) {
      String iconPath = 'assets/icons/repeat.png';
      Widget? customIcon = p.customIcons.repeat;
      if (p.playerStatus.playing) {
        iconPath = 'assets/icons/pause.png';
        customIcon = p.customIcons.pause;
      } else if (p.playerStatus.paused) {
        iconPath = 'assets/icons/play.png';
        customIcon = p.customIcons.play;
      }
      return PlayerButton(
        glass: true,
        backgroundColor: Colors.white.withValues(alpha: 0.12),
        iconColor: Colors.white,
        onPressed: () {
          if (p.playerStatus.playing) {
            p.pause();
          } else if (p.playerStatus.paused) {
            p.play(hideControls: false);
          } else {
            p.play(repeat: true, hideControls: false);
          }
        },
        size: size,
        iconPath: iconPath,
        customIcon: customIcon,
      );
    });
  }
}
