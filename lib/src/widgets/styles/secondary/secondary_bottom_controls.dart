import 'package:flutter/material.dart';
import 'package:flutter_meedu/rx/rx_builder.dart';
import '../../../../meedu_player.dart';

class SecondaryBottomControls extends StatelessWidget {
  final Responsive responsive;
  const SecondaryBottomControls({super.key, required this.responsive});

  String _format(Duration duration, Duration total) {
    return total.inMinutes >= 60
        ? printDurationWithHours(duration)
        : printDuration(duration);
  }

  @override
  Widget build(BuildContext context) {
    final p = MeeduPlayerController.of(context);
    final iconSize = responsive.buttonSize();
    final textStyle = TextStyle(
      color: Colors.white.withValues(alpha: 0.92),
      fontSize: responsive.fontSize(),
      fontWeight: FontWeight.w600,
      shadows: const [
        Shadow(color: Colors.black54, blurRadius: 8, offset: Offset(0, 1)),
      ],
    );

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RxBuilder((_) {
              return Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 4),
                    child: Text(
                      _format(p.position.value, p.duration.value),
                      style: textStyle,
                    ),
                  ),
                  const Expanded(child: PlayerSlider()),
                  Padding(
                    padding: const EdgeInsets.only(left: 4, right: 8),
                    child: Text(
                      _format(p.duration.value, p.duration.value),
                      style: textStyle,
                    ),
                  ),
                ],
              );
            }),
            Row(
              children: [
                PlayPauseButton(size: iconSize),
                const Spacer(),
                if (p.bottomRight != null) ...[
                  p.bottomRight!,
                  const SizedBox(width: 4),
                ],
                if (p.enabledButtons.pip) PipButton(responsive: responsive),
                if (p.enabledButtons.videoFit)
                  VideoFitButton(responsive: responsive),
                if (p.enabledButtons.muteAndSound)
                  MuteSoundButton(responsive: responsive),
                if (p.enabledButtons.fullscreen)
                  FullscreenButton(size: iconSize),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
