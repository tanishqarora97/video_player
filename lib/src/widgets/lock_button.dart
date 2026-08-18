import 'package:flutter/material.dart';
import 'package:flutter_meedu/rx/rx_builder.dart';
import '../../meedu_player.dart';
import 'package:universal_platform/universal_platform.dart';

class LockButton extends StatelessWidget {
  final Responsive responsive;
  const LockButton({super.key, required this.responsive});

  @override
  Widget build(BuildContext context) {
    final p = MeeduPlayerController.of(context);
    return RxBuilder((_) {
      p.lockedControls.value;
      if (UniversalPlatform.isDesktopOrWeb) return const SizedBox.shrink();
      final locked = p.lockedControls.value;
      return PlayerButton(
        size: responsive.buttonSize(),
        glass: locked,
        icon: locked ? Icons.lock_rounded : Icons.lock_open_rounded,
        iconColor: Colors.white,
        customIcon: locked ? p.customIcons.lock : p.customIcons.unlock,
        onPressed: p.toggleLockScreenMobile,
      );
    });
  }
}
