import 'package:flutter/material.dart';
import 'package:flutter_meedu/rx/rx_builder.dart';
import '../../meedu_player.dart';

class MuteSoundButton extends StatelessWidget {
  final Responsive responsive;
  const MuteSoundButton({super.key, required this.responsive});

  @override
  Widget build(BuildContext context) {
    final p = MeeduPlayerController.of(context);
    return RxBuilder(
      //observables: [_.mute, _.fullscreen],
      (_) {
        String iconPath = 'assets/icons/mute.png';
        Widget? customIcon = p.customIcons.mute;

        if (!p.mute.value) {
          iconPath = 'assets/icons/sound.png';
          customIcon = p.customIcons.sound;
        }

        return PlayerButton(
          size: responsive.buttonSize(),
          circle: false,
          backgroundColor: Colors.transparent,
          iconColor: Colors.white,
          iconPath: iconPath,
          customIcon: customIcon,
          onPressed: () {
            p.setMute(!p.mute.value);
          },
        );
      },
    );
  }
}
