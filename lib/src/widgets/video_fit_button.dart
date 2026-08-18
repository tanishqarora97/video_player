import 'package:flutter/material.dart';
import 'package:flutter_meedu/rx/rx_builder.dart';

import '../../meedu_player.dart';

class VideoFitButton extends StatelessWidget {
  final Responsive responsive;
  const VideoFitButton({super.key, required this.responsive});

  @override
  Widget build(BuildContext context) {
    final p = MeeduPlayerController.of(context);

    return RxBuilder((_) {
      p.videoFit.value;
      return PlayerButton(
        size: responsive.buttonSize(),
        icon: Icons.fit_screen_rounded,
        iconColor: Colors.white,
        customIcon: p.customIcons.videoFit,
        onPressed: () {
          p.customDebugPrint("toggleVideoFit");
          p.toggleVideoFit();
        },
      );
    });
  }
}
