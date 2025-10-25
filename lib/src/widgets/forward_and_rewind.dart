import 'package:flutter/material.dart';
import '../helpers/responsive.dart';
import 'rewind_and_forward_layout.dart';
import 'ripple_side.dart';
import 'transitions.dart';

class VideoCoreForwardAndRewind extends StatelessWidget {
  const VideoCoreForwardAndRewind({
    super.key,
    required this.showRewind,
    required this.showForward,
    required this.forwardSeconds,
    required this.rewindSeconds,
    required this.responsive,
  });

  final bool showRewind, showForward;
  final int rewindSeconds, forwardSeconds;
  final Responsive responsive;
  @override
  Widget build(BuildContext context) {
    return VideoCoreForwardAndRewindLayout(
      responsive: responsive,
      rewind: CustomOpacityTransition(
        visible: showRewind,
        child: ForwardAndRewindRippleSide(
          text: "$rewindSeconds Sec",
          side: RippleSide.left,
        ),
      ),
      forward: CustomOpacityTransition(
        visible: showForward,
        child: ForwardAndRewindRippleSide(
          text: "$forwardSeconds Sec",
          side: RippleSide.right,
        ),
      ),
    );
  }
}
