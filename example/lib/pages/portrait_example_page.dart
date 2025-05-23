import 'dart:async';

import 'package:flutter/material.dart';
import 'package:universal_videoplayer/meedu_player.dart';

class PortraitExamplePage extends StatefulWidget {
  const PortraitExamplePage({super.key});

  @override
  State<PortraitExamplePage> createState() => _PortraitExamplePageState();
}

class _PortraitExamplePageState extends State<PortraitExamplePage> {
  final _meeduPlayerController = MeeduPlayerController(
      controlsStyle: ControlsStyle.primary,
      enabledControls: const EnabledControls(doubleTapToSeek: false),
      responsive: Responsive(buttonsSizeRelativeToScreen: 6));

  StreamSubscription? _playerEventSubs;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _init();
    });
  }

  @override
  void dispose() {
    _playerEventSubs?.cancel();
    _meeduPlayerController.dispose();
    super.dispose();
  }

  _init() {
    _meeduPlayerController.setDataSource(
      DataSource(
        type: DataSourceType.network,
        source:
            "https://movietrailers.apple.com/movies/paramount/the-spongebob-movie-sponge-on-the-run/the-spongebob-movie-sponge-on-the-run-big-game_h720p.mov",
      ),
      autoplay: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: AspectRatio(
          aspectRatio: 9 / 16,
          child: MeeduVideoPlayer(
            controller: _meeduPlayerController,
          ),
        ),
      ),
    );
  }
}
