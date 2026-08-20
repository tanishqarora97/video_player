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
    final size = responsive.buttonSize();
    return RxBuilder((_) {
      return SizedBox(
        height: size,
        child: TextButton(
          style: TextButton.styleFrom(
            minimumSize: Size(size, size),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
            style: textStyle.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: responsive.fontSize(),
              height: 1,
            ),
          ),
        ),
      );
    });
  }
}
