import 'package:flutter/material.dart';
import 'package:flutter_meedu/rx/rx_builder.dart';
import '../../../../meedu_player.dart';
import '../controls_container.dart';
import 'bottom_controls.dart';

class PrimaryVideoPlayerControls extends StatelessWidget {
  final Responsive responsive;
  const PrimaryVideoPlayerControls({super.key, required this.responsive});

  @override
  Widget build(BuildContext context) {
    final p = MeeduPlayerController.of(context);

    return ControlsContainer(
      responsive: responsive,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // RENDER A CUSTOM HEADER
          if (p.header != null)
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: p.header!,
              ),
            ),
          SizedBox(height: responsive.height, width: responsive.width),

          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (p.enabledButtons.rewindAndfastForward) ...[
                PlayerButton(
                  onPressed: p.rewind,
                  size: responsive.iconSize(),
                  iconColor: Colors.white,
                  backgroundColor: Colors.transparent,
                  iconPath: 'assets/icons/rewind.png',
                  customIcon: p.customIcons.rewind,
                ),
                const SizedBox(width: 10),
              ],
              if (p.enabledButtons.playPauseAndRepeat)
                RxBuilder(
                  //observables: [_.showSwipeDuration],
                  //observables: [_.swipeDuration],
                  (_) {
                    p.dataStatus.status.value;
                    if (!p.showSwipeDuration.value &&
                        !p.dataStatus.error &&
                        !p.dataStatus.loading &&
                        !p.isBuffering.value) {
                      return PlayPauseButton(size: responsive.iconSize());
                    } else {
                      return Padding(
                        padding: EdgeInsets.all(responsive.iconSize() * 0.25),
                        child: SizedBox(
                          width: responsive.iconSize(),
                          height: responsive.iconSize(),
                        ),
                      );
                    }
                  },
                ),
              if (p.enabledButtons.rewindAndfastForward) ...[
                const SizedBox(width: 10),
                PlayerButton(
                  onPressed: p.fastForward,
                  iconColor: Colors.white,
                  backgroundColor: Colors.transparent,
                  size: responsive.iconSize(),
                  iconPath: 'assets/icons/fast-forward.png',
                  customIcon: p.customIcons.fastForward,
                ),
              ],
            ],
          ),

          PrimaryBottomControls(responsive: responsive),
        ],
      ),
    );
  }
}
