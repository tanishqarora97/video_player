import 'package:flutter/material.dart';
import '../../../../meedu_player.dart';
import '../controls_container.dart';
import 'secondary_bottom_controls.dart';

class SecondaryVideoPlayerControls extends StatelessWidget {
  final Responsive responsive;
  const SecondaryVideoPlayerControls({super.key, required this.responsive});

  @override
  Widget build(BuildContext context) {
    final p = MeeduPlayerController.of(context);
    return ControlsContainer(
      responsive: responsive,
      child: Stack(
        children: [
          // RENDER A CUSTOM HEADER
          if (p.header != null)
            Positioned(left: 0, right: 0, top: 0, child: p.header!),
          SecondaryBottomControls(responsive: responsive),
        ],
      ),
    );
  }
}
