import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';

import '../../meedu_player.dart';

class PlayerTopControls extends StatelessWidget {
  final Responsive responsive;
  const PlayerTopControls({super.key, required this.responsive});

  @override
  Widget build(BuildContext context) {
    final p = MeeduPlayerController.of(context);
    final showLock =
        !UniversalPlatform.isDesktopOrWeb && p.enabledButtons.lockControls;

    if (p.header == null && !showLock) {
      return const SizedBox.shrink();
    }

    return Positioned(
      left: 8,
      right: 8,
      top: 8,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: p.header ?? const SizedBox.shrink()),
          if (showLock) LockButton(responsive: responsive),
        ],
      ),
    );
  }
}
