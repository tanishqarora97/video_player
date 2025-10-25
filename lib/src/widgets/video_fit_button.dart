import 'package:flutter/material.dart';
import '../../meedu_player.dart';

class VideoFitButton extends StatelessWidget {
  final Responsive responsive;
  const VideoFitButton({super.key, required this.responsive});

  @override
  Widget build(BuildContext context) {
    final p = MeeduPlayerController.of(context);
    String iconPath = 'assets/icons/fit.png';
    Widget? customIcon = p.customIcons.videoFit;

    return PlayerButton(
      size: responsive.buttonSize(),
      circle: false,
      backgroundColor: Colors.transparent,
      iconColor: Colors.white,
      iconPath: iconPath,
      customIcon: customIcon,
      onPressed: () {
        p.customDebugPrint("toggleVideoFit");
        p.toggleVideoFit();
      },
    );
  }
}
