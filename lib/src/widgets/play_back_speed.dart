import 'package:flutter/material.dart';
import 'package:flutter_meedu/rx/rx_builder.dart';
import '../../meedu_player.dart';

class PlayBackSpeedButton extends StatelessWidget {
  final Responsive responsive;
  final TextStyle textStyle;
  const PlayBackSpeedButton({
    super.key,
    required this.responsive,
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final p = MeeduPlayerController.of(context);
    return RxBuilder(
      //observables: [_.fullscreen],
      (_) {
        return TextButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.all(responsive.buttonSize() * 0.25),
          ),
          onPressed: () {
            p.customDebugPrint("s");
            p.togglePlaybackSpeed();

            p.controls = true;
          },
          child: Text(p.playbackSpeed.toString(), style: textStyle),
        );
      },
    );
  }
}
