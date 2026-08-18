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
      IconData icon = Icons.replay_rounded;
      Widget? customIcon = p.customIcons.repeat;
      if (p.playerStatus.playing) {
        icon = Icons.pause_rounded;
        customIcon = p.customIcons.pause;
      } else if (p.playerStatus.paused) {
        icon = Icons.play_arrow_rounded;
        customIcon = p.customIcons.play;
      }
      return PlayerButton(
        glass: true,
        icon: icon,
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
        customIcon: customIcon,
      );
    });
  }
}
