import 'package:flutter/material.dart';
import 'package:flutter_meedu/rx/rx_builder.dart';
import '../../../../meedu_player.dart';
import '../../lock_button.dart';
import 'package:universal_platform/universal_platform.dart';

class PrimaryBottomControls extends StatelessWidget {
  final Responsive responsive;
  const PrimaryBottomControls({super.key, required this.responsive});

  String _format(Duration duration, Duration total) {
    return total.inMinutes >= 60
        ? printDurationWithHours(duration)
        : printDuration(duration);
  }

  @override
  Widget build(BuildContext context) {
    final p = MeeduPlayerController.of(context);
    final textStyle = TextStyle(
      color: Colors.white.withValues(alpha: 0.92),
      fontSize: responsive.fontSize(),
      fontWeight: FontWeight.w600,
      letterSpacing: 0.2,
      shadows: const [
        Shadow(color: Colors.black54, blurRadius: 8, offset: Offset(0, 1)),
      ],
    );

    final otherControls = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (p.bottomRight != null) ...[
          p.bottomRight!,
          const SizedBox(width: 4),
        ],
        if (p.enabledButtons.pip) PipButton(responsive: responsive),
        if (!UniversalPlatform.isDesktopOrWeb && p.enabledButtons.lockControls)
          LockButton(responsive: responsive),
        if (p.enabledButtons.videoFit) VideoFitButton(responsive: responsive),
        if (p.enabledButtons.playBackSpeed)
          PlayBackSpeedButton(responsive: responsive, textStyle: textStyle),
        if (p.enabledButtons.muteAndSound)
          MuteSoundButton(responsive: responsive),
        if (p.enabledButtons.fullscreen)
          FullscreenButton(size: responsive.buttonSize()),
      ],
    );

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const PlayerSlider(),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 4, 4),
              child: (responsive.height / responsive.width > 1)
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RxBuilder((_) {
                          final remaining = p.duration.value - p.position.value;
                          return Text(
                            '${_format(p.position.value, p.duration.value)}  ·  -${_format(remaining, p.duration.value)}',
                            style: textStyle,
                          );
                        }),
                        Align(
                          alignment: Alignment.centerRight,
                          child: otherControls,
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        RxBuilder((_) {
                          final remaining = p.duration.value - p.position.value;
                          return Text(
                            '${_format(p.position.value, p.duration.value)}  ·  -${_format(remaining, p.duration.value)}',
                            style: textStyle,
                          );
                        }),
                        const Spacer(),
                        otherControls,
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
