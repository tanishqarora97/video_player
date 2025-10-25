import 'package:flutter/material.dart';
import 'package:flutter_meedu/rx/rx_builder.dart';
import '../../../../meedu_player.dart';
import '../../lock_button.dart';
import 'package:universal_platform/universal_platform.dart';

class PrimaryBottomControls extends StatelessWidget {
  final Responsive responsive;
  const PrimaryBottomControls({super.key, required this.responsive});

  @override
  Widget build(BuildContext context) {
    final p = MeeduPlayerController.of(context);
    final textStyle = TextStyle(
      color: Colors.white,
      fontSize: responsive.fontSize(),
    );
    Widget durationControls = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.min,
        children: [
          RxBuilder(
            //observables: [_.duration, _.position],
            (_) {
              return Text(
                p.duration.value.inMinutes >= 60
                    ? printDurationWithHours(p.position.value)
                    : printDuration(p.position.value),
                style: textStyle,
              );
            },
          ),
          // END VIDEO POSITION
          const SizedBox(width: 10),
          const Expanded(child: PlayerSlider()),
          const SizedBox(width: 10),
          // START VIDEO DURATION
          RxBuilder(
            //observables: [_.duration],
            (_) => Text(
              p.duration.value.inMinutes >= 60
                  ? printDurationWithHours(p.duration.value)
                  : printDuration(p.duration.value),
              style: textStyle,
            ),
          ),
        ],
      ),
    );
    // END VIDEO DURATION
    Widget otherControls = Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        if (p.bottomRight != null) ...[
          p.bottomRight!,
          const SizedBox(width: 5),
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
      left: 5,
      right: 0,
      bottom: 20,
      child: (responsive.height / responsive.width > 1)
          ? Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              runAlignment: WrapAlignment.spaceAround,
              children: [durationControls, otherControls],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: durationControls),
                otherControls,
              ],
            ),
    );
  }
}
