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
    final centerSize = responsive.iconSize();

    return ControlsContainer(
      responsive: responsive,
      preventHorizontalDrag: true,
      preventVerticalDrag: true,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (p.header != null)
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 12, 8, 0),
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
                  size: centerSize * 0.78,
                  glass: true,
                  icon: Icons.replay_10_rounded,
                  iconColor: Colors.white,
                  customIcon: p.customIcons.rewind,
                ),
                SizedBox(width: centerSize * 0.35),
              ],
              if (p.enabledButtons.playPauseAndRepeat)
                RxBuilder((_) {
                  p.dataStatus.status.value;
                  if (!p.showSwipeDuration.value &&
                      !p.dataStatus.error &&
                      !p.dataStatus.loading &&
                      !p.isBuffering.value) {
                    return PlayPauseButton(size: centerSize);
                  }
                  return SizedBox(width: centerSize, height: centerSize);
                }),
              if (p.enabledButtons.rewindAndfastForward) ...[
                SizedBox(width: centerSize * 0.35),
                PlayerButton(
                  onPressed: p.fastForward,
                  glass: true,
                  icon: Icons.forward_10_rounded,
                  iconColor: Colors.white,
                  size: centerSize * 0.78,
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
