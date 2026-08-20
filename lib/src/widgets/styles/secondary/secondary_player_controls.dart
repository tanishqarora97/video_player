import 'package:flutter/material.dart';
import '../../../../meedu_player.dart';
import '../controls_container.dart';
import 'secondary_bottom_controls.dart';

class SecondaryVideoPlayerControls extends StatelessWidget {
  final Responsive responsive;
  const SecondaryVideoPlayerControls({super.key, required this.responsive});

  @override
  Widget build(BuildContext context) {
    return ControlsContainer(
      responsive: responsive,
      child: Stack(
        children: [
          PlayerTopControls(responsive: responsive),
          SecondaryBottomControls(responsive: responsive),
        ],
      ),
    );
  }
}
