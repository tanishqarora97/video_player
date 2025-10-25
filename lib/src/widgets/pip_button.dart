import 'package:flutter/material.dart';
import 'package:flutter_meedu/rx/rx_builder.dart';
import '../../meedu_player.dart';

class PipButton extends StatelessWidget {
  final Responsive responsive;
  const PipButton({super.key, required this.responsive});

  @override
  Widget build(BuildContext context) {
    final p = MeeduPlayerController.of(context);
    return RxBuilder(
      // observables: [
      //   _.pipAvailable,
      //   _.fullscreen,
      // ],
      (_) {
        if (!p.pipAvailable.value) return Container();
        String iconPath = 'assets/icons/picture-in-picture.png';
        Widget? customIcon = p.customIcons.pip;
        if (p.isInPipMode.value) {
          iconPath = 'assets/icons/exit_picture-in-picture.png';
          customIcon = p.customIcons.exitPip;
        }
        return PlayerButton(
          size: responsive.buttonSize(),
          circle: false,
          backgroundColor: Colors.transparent,
          iconColor: Colors.white,
          iconPath: iconPath,
          customIcon: customIcon,
          onPressed: () =>
              p.isInPipMode.value ? p.closePip(context) : p.enterPip(context),
        );
      },
    );
  }
}
