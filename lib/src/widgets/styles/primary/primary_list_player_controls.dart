import 'package:flutter/material.dart';
import 'package:flutter_meedu/rx/rx_builder.dart';
import '../../../../meedu_player.dart';
import '../controls_container.dart';
import 'bottom_controls.dart';
import 'primary_player_controls.dart';

class PrimaryListVideoPlayerControls extends PrimaryVideoPlayerControls {
  const PrimaryListVideoPlayerControls({super.key, required super.responsive});

  @override
  Widget build(BuildContext context) {
    final p = MeeduPlayerController.of(context);
    final size = responsive.buttonSize();

    return ControlsContainer(
      responsive: responsive,
      preventHorizontalDrag: true,
      preventVerticalDrag: true,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PlayerTopControls(responsive: responsive),
          SizedBox(height: responsive.height, width: responsive.width),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (p.enabledButtons.rewindAndfastForward) ...[
                PlayerButton(
                  onPressed: p.rewind,
                  size: size,
                  glass: true,
                  icon: Icons.replay_10_rounded,
                  iconColor: Colors.white,
                  customIcon: p.customIcons.rewind,
                ),
                SizedBox(width: size * 0.35),
              ],
              if (p.enabledButtons.playPauseAndRepeat)
                RxBuilder((_) {
                  p.dataStatus.status.value;
                  if (!p.showSwipeDuration.value &&
                      !p.dataStatus.error &&
                      !p.dataStatus.loading &&
                      !p.isBuffering.value) {
                    return PlayPauseButton(size: size);
                  }
                  return SizedBox(width: size, height: size);
                }),
              if (p.enabledButtons.rewindAndfastForward) ...[
                SizedBox(width: size * 0.35),
                PlayerButton(
                  onPressed: p.fastForward,
                  glass: true,
                  icon: Icons.forward_10_rounded,
                  iconColor: Colors.white,
                  size: size,
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
