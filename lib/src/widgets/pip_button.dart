import 'package:flutter/material.dart';
import 'package:flutter_meedu/rx/rx_builder.dart';
import '../../meedu_player.dart';

class PipButton extends StatelessWidget {
  final Responsive responsive;
  const PipButton({super.key, required this.responsive});

  @override
  Widget build(BuildContext context) {
    final p = MeeduPlayerController.of(context);
    return RxBuilder((_) {
      if (!p.pipAvailable.value) return const SizedBox.shrink();
      final inPip = p.isInPipMode.value;
      return PlayerButton(
        size: responsive.buttonSize(),
        icon: inPip
            ? Icons.picture_in_picture_alt_rounded
            : Icons.picture_in_picture_outlined,
        iconColor: Colors.white,
        customIcon: inPip ? p.customIcons.exitPip : p.customIcons.pip,
        onPressed: () =>
            inPip ? p.closePip(context) : p.enterPip(context),
      );
    });
  }
}
