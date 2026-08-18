import 'package:flutter/material.dart';
import 'package:flutter_meedu/rx/rx_builder.dart';
import '../../meedu_player.dart';

class MuteSoundButton extends StatelessWidget {
  final Responsive responsive;
  const MuteSoundButton({super.key, required this.responsive});

  @override
  Widget build(BuildContext context) {
    final p = MeeduPlayerController.of(context);
    return RxBuilder((_) {
      final muted = p.mute.value;
      return PlayerButton(
        size: responsive.buttonSize(),
        icon: muted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
        iconColor: Colors.white,
        customIcon: muted ? p.customIcons.mute : p.customIcons.sound,
        onPressed: () {
          p.setMute(!p.mute.value);
        },
      );
    });
  }
}
