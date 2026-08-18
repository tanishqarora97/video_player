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
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: TextButton(
            style: TextButton.styleFrom(
              minimumSize: Size.zero,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: Colors.white.withValues(alpha: 0.35)),
              ),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              p.togglePlaybackSpeed();
              p.controls = true;
            },
            child: Text(
              '${p.playbackSpeed}x',
              style: textStyle.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        );
      },
    );
  }
}
