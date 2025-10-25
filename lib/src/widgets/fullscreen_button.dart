import 'package:flutter/material.dart';
import 'package:flutter_meedu/rx/rx_builder.dart';
import '../../meedu_player.dart';

class FullscreenButton extends StatelessWidget {
  final double size;
  const FullscreenButton({super.key, this.size = 30});

  @override
  Widget build(BuildContext context) {
    final p = MeeduPlayerController.of(context);
    return RxBuilder(
      //observables: [_.fullscreen],
      (_) {
        String iconPath = 'assets/icons/minimize.png';
        Widget? customIcon = p.customIcons.minimize;

        if (!p.fullscreen.value) {
          iconPath = 'assets/icons/fullscreen.png';
          customIcon = p.customIcons.fullscreen;
        }
        return PlayerButton(
          size: size,
          circle: false,
          backgroundColor: Colors.transparent,
          iconColor: Colors.white,
          iconPath: iconPath,
          customIcon: customIcon,
          onPressed: () {
            p.toggleFullScreen(context);
          },
        );
      },
    );
  }
}
