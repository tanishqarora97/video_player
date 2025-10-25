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
    return RxBuilder(
      // observables: [
      //   _.lockAvailable,
      // ],
      (_) {
        p
            .lockedControls
            .value; // this is the value that the rxbuilder will listen to (for updates)
        if (UniversalPlatform.isDesktopOrWeb) return Container();
        String iconPath = 'assets/icons/lock-screen.png';
        Widget? customIcon = p.customIcons.lock;
        if (!p.lockedControls.value) {
          iconPath = 'assets/icons/exit_lock-screen.png';
          customIcon = p.customIcons.unlock;
        }
        return PlayerButton(
          size: responsive.buttonSize(),
          circle: false,
          backgroundColor: Colors.transparent,
          iconColor: Colors.white,
          iconPath: iconPath,
          customIcon: customIcon,
          onPressed: () => p.lockedControls.value
              ? p.toggleLockScreenMobile()
              : p.toggleLockScreenMobile(),
        );
      },
    );
  }
}
