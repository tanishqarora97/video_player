import 'package:flutter/material.dart';
import 'package:flutter_meedu/rx/rx_builder.dart';
import '../../../../meedu_player.dart';
import '../../lock_button.dart';
import 'package:universal_platform/universal_platform.dart';

class SecondaryBottomControls extends StatelessWidget {
  final Responsive responsive;
  const SecondaryBottomControls({super.key, required this.responsive});

  @override
  Widget build(BuildContext context) {
    final p = MeeduPlayerController.of(context);
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
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const PlayerSlider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const SizedBox(width: 8),
                    PlayPauseButton(size: responsive.buttonSize()),
                    const SizedBox(width: 8),
                    RxBuilder((z) {
                      final remaining = p.duration.value - p.position.value;
                      final useHours = p.duration.value.inMinutes >= 60;
                      final current = useHours
                          ? printDurationWithHours(p.position.value)
                          : printDuration(p.position.value);
                      final left = useHours
                          ? printDurationWithHours(remaining)
                          : printDuration(remaining);
                      return Text('$current  ·  -$left', style: textStyle);
                    }),
                  ],
                ),
                Row(
                  children: [
                    if (p.bottomRight != null) ...[
                      p.bottomRight!,
                      const SizedBox(width: 4),
                    ],
                    if (p.enabledButtons.pip) PipButton(responsive: responsive),
                    if (!UniversalPlatform.isDesktopOrWeb &&
                        p.enabledButtons.lockControls)
                      LockButton(responsive: responsive),
                    if (p.enabledButtons.videoFit)
                      VideoFitButton(responsive: responsive),
                    if (p.enabledButtons.muteAndSound)
                      MuteSoundButton(responsive: responsive),
                    if (p.enabledButtons.fullscreen) ...[
                      FullscreenButton(size: responsive.buttonSize()),
                      const SizedBox(width: 4),
                    ],
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
