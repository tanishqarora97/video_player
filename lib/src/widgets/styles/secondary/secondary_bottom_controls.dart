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
      color: Colors.white,
      fontSize: responsive.fontSize(),
    );

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Transform.translate(
            offset: const Offset(0, 4),
            child: const PlayerSlider(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const SizedBox(width: 5),
                  PlayPauseButton(size: responsive.buttonSize()),
                  const SizedBox(width: 5),
                  RxBuilder(
                    //observables: [_.duration, _.position],
                    (z) {
                      String text = "";
                      if (p.duration.value.inMinutes >= 60) {
                        // if the duration is >= 1 hour
                        text =
                            "${printDurationWithHours(p.position.value)} / ${printDurationWithHours(p.duration.value)}";
                      } else {
                        text =
                            "${printDuration(p.position.value)} / ${printDuration(p.duration.value)}";
                      }
                      return Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: Text(text, style: textStyle),
                      );
                    },
                  ),
                  // PlayerButton(
                  //   onPressed: _.rewind,
                  //   size: buttonsSize,
                  //   iconColor: Colors.white,
                  //   backgrounColor: Colors.transparent,
                  //   iconPath: 'assets/icons/rewind.png',
                  // ),
                  // PlayerButton(
                  //   onPressed: _.fastForward,
                  //   iconColor: Colors.white,
                  //   backgrounColor: Colors.transparent,
                  //   size: buttonsSize,
                  //   iconPath: 'assets/icons/fast-forward.png',
                  // ),
                  const SizedBox(width: 5),
                ],
              ),
              Row(
                children: [
                  if (p.bottomRight != null) ...[
                    p.bottomRight!,
                    const SizedBox(width: 10),
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
                    const SizedBox(width: 5),
                  ],
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
