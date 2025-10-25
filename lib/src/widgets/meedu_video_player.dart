import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meedu/rx/rx_builder.dart';
import '../../meedu_player.dart';
import 'styles/controls_container.dart';
import 'styles/primary/primary_list_player_controls.dart';
import 'styles/primary/primary_player_controls.dart';
import 'styles/secondary/secondary_player_controls.dart';
import '../helpers/shortcuts/intent_action_map.dart';

/// An ActionDispatcher that logs all the actions that it invokes.
class LoggingActionDispatcher extends ActionDispatcher {
  @override
  Object? invokeAction(
    covariant Action<Intent> action,
    covariant Intent intent, [
    BuildContext? context,
  ]) {
    // customDebugPrint('Action invoked: $action($intent) from $context');
    super.invokeAction(action, intent, context);

    return null;
  }
}

class MeeduVideoPlayer extends StatefulWidget {
  final MeeduPlayerController controller;

  final Widget Function(
    BuildContext context,
    MeeduPlayerController controller,
    Responsive responsive,
  )?
  header;

  final Widget Function(
    BuildContext context,
    MeeduPlayerController controller,
    Responsive responsive,
  )?
  bottomRight;

  final CustomIcons Function(Responsive responsive)? customIcons;

  ///[customControls] this only needed when controlsStyle is [ControlsStyle.custom]
  final Widget Function(
    BuildContext context,
    MeeduPlayerController controller,
    Responsive responsive,
  )?
  customControls;

  ///[videoOverlay] can be used to wrap the player in any widget, to apply custom gestures, or apply custom watermarks
  final Widget Function(
    BuildContext context,
    MeeduPlayerController controller,
    Responsive responsive,
  )?
  videoOverlay;

  ///[customCaptionView] when a custom view for the captions is needed
  final Widget Function(
    BuildContext context,
    MeeduPlayerController controller,
    Responsive responsive,
    String text,
  )?
  customCaptionView;

  ///[backgroundColor] video background color
  final Color backgroundColor;

  /// The distance from the bottom of the screen to the closed captions text.
  ///
  /// This value represents the vertical position of the closed captions display
  /// from the bottom of the screen. It is measured in logical pixels and can be
  /// used to adjust the positioning of the closed captions within the video player
  /// UI. A higher value will move the closed captions higher on the screen, while
  /// a lower value will move them closer to the bottom.
  ///
  /// By adjusting this distance, you can ensure that the closed captions are
  /// displayed at an optimal position that doesn't obstruct other important
  /// elements of the video player interface.
  final double closedCaptionDistanceFromBottom;
  const MeeduVideoPlayer({
    super.key,
    required this.controller,
    this.header,
    this.bottomRight,
    this.customIcons,
    this.customControls,
    this.customCaptionView,
    this.videoOverlay,
    this.closedCaptionDistanceFromBottom = 40,
    this.backgroundColor = Colors.black,
  });

  @override
  State<MeeduVideoPlayer> createState() => _MeeduVideoPlayerState();
}

class _MeeduVideoPlayerState extends State<MeeduVideoPlayer> {
  // bool oldUIRefresh = false;
  ValueKey _key = const ValueKey(true);
  double videoWidth(VideoPlayerController? controller) {
    double width = controller != null
        ? controller.value.size.width != 0
              ? controller.value.size.width
              : 640
        : 640;
    return width;
    // if (width < max) {
    //   return max;
    // } else {
    //   return width;
    // }
  }

  double videoHeight(VideoPlayerController? controller) {
    double height = controller != null
        ? controller.value.size.height != 0
              ? controller.value.size.height
              : 480
        : 480;
    return height;
    // if (height < max) {
    //   return max;
    // } else {
    //   return height;
    // }
  }

  void refresh() {
    if (!kIsWeb) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _key = ValueKey(!_key.value);

        // your state update logic goes here
      });
      if (widget.controller.playerStatus.playing) {
        widget.controller.play();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: activatorsToCallBacks(widget.controller, context),
      child: Focus(
        autofocus: true,
        child: MeeduPlayerProvider(
          controller: widget.controller,
          child: Container(
            color: widget.backgroundColor,
            child: LayoutBuilder(
              builder: (ctx, constraints) {
                MeeduPlayerController p = widget.controller;
                if (p.controlsEnabled) {
                  p.responsive.setDimensions(
                    constraints.maxWidth,
                    constraints.maxHeight,
                  );
                }

                if (widget.customIcons != null) {
                  p.customIcons = widget.customIcons!(p.responsive);
                }

                if (widget.header != null) {
                  p.header = widget.header!(context, p, p.responsive);
                }

                if (widget.bottomRight != null) {
                  p.bottomRight = widget.bottomRight!(context, p, p.responsive);
                }
                if (widget.videoOverlay != null) {
                  p.videoOverlay = widget.videoOverlay!(
                    context,
                    p,
                    p.responsive,
                  );
                }
                if (widget.customControls != null) {
                  p.customControls = widget.customControls!(
                    context,
                    p,
                    p.responsive,
                  );
                }
                if (widget.customCaptionView != null) {
                  p.customCaptionView = widget.customCaptionView;
                }
                return ExcludeFocus(
                  excluding: p.excludeFocus,
                  child: Stack(
                    // clipBehavior: Clip.hardEdge,
                    // fit: StackFit.,
                    alignment: Alignment.center,
                    children: [
                      RxBuilder(
                        //observables: [_.videoFit],
                        (_) {
                          if (widget
                              .controller
                              .forceUIRefreshAfterFullScreen
                              .value) {
                            log("NEEDS TO REFRASH UI");
                            refresh();
                            widget
                                    .controller
                                    .forceUIRefreshAfterFullScreen
                                    .value =
                                false;
                          }
                          // widget.controller.forceUIRefreshAfterFullScreen
                          //     .value = false;
                          p.dataStatus.status.value;
                          p.customDebugPrint(
                            "Fit is ${widget.controller.videoFit.value}",
                          );
                          // customDebugPrint(
                          //     "constraints.maxWidth ${constraints.maxWidth}");
                          // _.customDebugPrint(
                          //     "width ${videoWidth(_.videoPlayerController, constraints.maxWidth)}");
                          // customDebugPrint(
                          //     "videoPlayerController ${_.videoPlayerController}");
                          return Positioned.fill(
                            child: FittedBox(
                              clipBehavior: Clip.hardEdge,
                              fit: widget.controller.videoFit.value,
                              child: SizedBox(
                                width: videoWidth(p.videoPlayerController),
                                height: videoHeight(p.videoPlayerController),
                                // width: 640,
                                // height: 480,
                                child: p.videoPlayerController != null
                                    ? VideoPlayer(
                                        p.videoPlayerController!,
                                        key: _key,
                                      )
                                    : Container(),
                              ),
                            ),
                          );
                        },
                      ),
                      if (p.videoOverlay != null) p.videoOverlay!,
                      ClosedCaptionView(
                        responsive: p.responsive,
                        distanceFromBottom:
                            widget.closedCaptionDistanceFromBottom,
                        customCaptionView: p.customCaptionView,
                      ),
                      if (p.controlsEnabled &&
                          p.controlsStyle == ControlsStyle.primary)
                        PrimaryVideoPlayerControls(responsive: p.responsive),
                      if (p.controlsEnabled &&
                          p.controlsStyle == ControlsStyle.primaryList)
                        PrimaryListVideoPlayerControls(
                          responsive: p.responsive,
                        ),
                      if (p.controlsEnabled &&
                          p.controlsStyle == ControlsStyle.secondary)
                        SecondaryVideoPlayerControls(responsive: p.responsive),
                      if (p.controlsEnabled &&
                          p.controlsStyle == ControlsStyle.custom &&
                          p.customControls != null)
                        ControlsContainer(
                          responsive: p.responsive,
                          child: p.customControls!,
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class MeeduPlayerProvider extends InheritedWidget {
  final MeeduPlayerController controller;

  const MeeduPlayerProvider({
    super.key,
    required super.child,
    required this.controller,
  });

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }
}
