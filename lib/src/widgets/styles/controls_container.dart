import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_meedu/rx/rx_builder.dart';
import '../../../meedu_player.dart';
import '../lock_button.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:window_manager/window_manager.dart';

class ControlsContainer extends StatefulWidget {
  final Widget child;
  final Responsive responsive;
  final bool preventVerticalDrag;
  final bool preventHorizontalDrag;
  //Duration swipeDuration=Duration(seconds: 0);
  const ControlsContainer({
    super.key,
    required this.child,
    required this.responsive,
    this.preventHorizontalDrag = false,
    this.preventVerticalDrag = false,
  });

  @override
  State<ControlsContainer> createState() => _ControlsContainerState();
}

class _ControlsContainerState extends State<ControlsContainer> {
  bool playing = false;

  bool gettingNotification = false;

  late Offset horizontalDragStartOffset;

  Offset _dragInitialDelta = Offset.zero;

  Offset _verticalDragStartOffset = Offset.zero;

  //Offset _mouseMoveInitial = Offset.zero;
  Offset _horizontalDragStartOffset = Offset.zero;

  final ValueNotifier<double> _currentVolume = ValueNotifier<double>(1.0);

  double _onDragStartVolume = 1;

  double _onDragStartBrightness = 1;

  bool isVolume = false;

  //bool gettingNotification = false;
  final int _defaultSeekAmount = -10;

  Timer? _doubleTapToSeekTimer;

  Timer? _tappedOnce;

  bool tappedTwice = false;

  final ValueNotifier<double> _currentBrightness = ValueNotifier<double>(1.0);

  //------------------------------------//
  void _forwardDragStart(
    Offset localPosition,
    MeeduPlayerController controller,
  ) async {
    playing = controller.playerStatus.playing;
    controller.pause();
    //_initialForwardPosition = controller.position.value;
    _horizontalDragStartOffset = localPosition;
    controller.showSwipeDuration.value = true;
  }

  void tappedOnce(MeeduPlayerController p, bool secondTap) {
    if (!secondTap) {
      //   // _tappedOnce?.cancel();
      //   _.controls = false;
      // } else {
      tappedTwice = true;
      p.controls = !p.showControls.value;
      _tappedOnce?.cancel();
      _tappedOnce = Timer(const Duration(milliseconds: 300), () {
        p.customDebugPrint("set tapped twice to false");
        tappedTwice = false;
        //_dragInitialDelta = Offset.zero;
      });
    }
  }

  void _rewind(BuildContext context, MeeduPlayerController controller) =>
      _showRewindAndForward(context, 0, controller);

  void _forward(BuildContext context, MeeduPlayerController controller) =>
      _showRewindAndForward(context, 1, controller);

  void _showRewindAndForward(
    BuildContext context,
    int index,
    MeeduPlayerController controller,
  ) async {
    //controller.videoSeekToNextSeconds(amount);
    if (index == 0) {
      controller.doubleTapCount.value += 1;
    } else {
      controller.doubleTapCount.value -= 1;
    }

    if (controller.doubleTapCount.value < 0) {
      controller.rewindIcons.value = false;
      controller.forwardIcons.value = true;
    } else {
      if (controller.doubleTapCount.value > 0) {
        controller.rewindIcons.value = true;
        controller.forwardIcons.value = false;
      } else {
        controller.rewindIcons.value = false;
        controller.forwardIcons.value = false;
      }
    }

    _doubleTapToSeekTimer?.cancel();
    _doubleTapToSeekTimer = Timer(const Duration(milliseconds: 500), () {
      playing = controller.playerStatus.playing;
      controller.videoSeekToNextSeconds(
        _defaultSeekAmount * controller.doubleTapCount.value,
        playing,
      );
      controller.customDebugPrint("set tapped Twice to false");
      tappedTwice = false;
      controller.rewindIcons.value = false;
      controller.forwardIcons.value = false;
      controller.doubleTapCount.value = 0;
    });
  }

  void _forwardDragUpdate(
    Offset localPosition,
    MeeduPlayerController controller,
  ) {
    final double diff = _horizontalDragStartOffset.dx - localPosition.dx;
    final int duration = controller.duration.value.inSeconds;
    final int position = controller.position.value.inSeconds;
    final int seconds = -(diff * duration / 5000).round();
    final int relativePosition = position + seconds;
    if (relativePosition <= duration && relativePosition >= 0) {
      controller.swipeDuration.value = seconds;
    }
  }

  void _forwardDragEnd(MeeduPlayerController controller) async {
    _dragInitialDelta = Offset.zero;
    if (controller.swipeDuration.value != 0) {
      await controller.videoSeekToNextSeconds(
        controller.swipeDuration.value,
        playing,
      );
    }
    controller.showSwipeDuration.value = false;
  }

  //----------------------------//
  void _volumeDragUpdate(
    Offset localPosition,
    MeeduPlayerController controller,
  ) {
    double diff = _verticalDragStartOffset.dy - localPosition.dy;
    double volume = (diff / 500) + _onDragStartVolume;
    if (volume >= 0 &&
        volume <= 1 &&
        differenceOfExists(
          (controller.volume.value * 100).round(),
          (volume * 100).round(),
          2,
        )) {
      controller.customDebugPrint("Volume $volume");
      //customDebugPrint("current ${(controller.volume.value*100).round()}");
      //customDebugPrint("new ${(volume*100).round()}");
      controller.setVolume(volume);
    }
  }

  void _volumeDragStart(
    Offset localPosition,
    MeeduPlayerController controller,
  ) {
    controller.showVolumeStatus.value = true;
    controller.showBrightnessStatus.value = false;
    isVolume = true;
    _currentVolume.value = controller.volume.value;
    _onDragStartVolume = _currentVolume.value;
    _verticalDragStartOffset = localPosition;
  }

  void _volumeDragEnd(MeeduPlayerController controller) {
    _dragInitialDelta = Offset.zero;
    isVolume = false;
    controller.showVolumeStatus.value = false;
  }

  bool differenceOfExists(
    int originalValue,
    int valueToCompareTo,
    int difference,
  ) {
    bool plus =
        originalValue + difference < valueToCompareTo ||
        valueToCompareTo == 0 ||
        valueToCompareTo == 100;
    bool minus = originalValue - difference > valueToCompareTo;
    //customDebugPrint("originalValue"+(originalValue).toString());
    //customDebugPrint("valueToCompareTo"+(valueToCompareTo).toString());
    //customDebugPrint("originalValue+difference"+(originalValue+difference).toString());
    //customDebugPrint("originalValue-difference"+(originalValue-difference).toString());
    //customDebugPrint("plus "+plus.toString());
    //customDebugPrint("minus "+minus.toString());
    //customDebugPrint("______________________________________");
    if (plus || minus) {
      return true;
    } else {
      return false;
    }
  }

  void _brightnessDragUpdate(
    Offset localPosition,
    MeeduPlayerController controller,
  ) {
    double diff = _verticalDragStartOffset.dy - localPosition.dy;
    double brightness = (diff / 500) + _onDragStartBrightness;
    //customDebugPrint("New");
    //customDebugPrint((controller.brightness.value*100).round());
    //customDebugPrint((brightness*100).round());
    if (brightness >= 0 &&
        brightness <= 1 &&
        differenceOfExists(
          (controller.brightness.value * 100).round(),
          (brightness * 100).round(),
          2,
        )) {
      controller.customDebugPrint("brightness $brightness");
      //brightness
      controller.setBrightness(brightness);
    }
  }

  void _brightnessDragStart(
    Offset localPosition,
    MeeduPlayerController controller,
  ) async {
    controller.showBrightnessStatus.value = true;
    controller.showVolumeStatus.value = false;

    _currentBrightness.value = controller.brightness.value;
    _onDragStartBrightness = _currentBrightness.value;
    _verticalDragStartOffset = localPosition;
  }

  void _brightnessDragEnd(MeeduPlayerController controller) {
    _dragInitialDelta = Offset.zero;
    controller.showBrightnessStatus.value = false;
    isVolume = false;
  }

  Widget controlsUI(MeeduPlayerController p, BuildContext context) {
    return Stack(
      children: [
        RxBuilder((_) {
          if (!p.mobileControls) {
            return MouseRegion(
              cursor: p.showControls.value
                  ? SystemMouseCursors.basic
                  : SystemMouseCursors.none,
              onHover: (___) {
                //customDebugPrint(___.delta);
                if (p.mouseMoveInitial < const Offset(75, 75).distance) {
                  p.mouseMoveInitial = p.mouseMoveInitial + ___.delta.distance;
                } else {
                  p.controls = true;
                }
              },
              child: videoControls(p, context),
            );
          } else {
            return videoControls(p, context);
          }
        }),
        if (p.enabledControls.doubleTapToSeek && (p.mobileControls))
          RxBuilder(
            //observables: [_.showControls],
            (_) => IgnorePointer(
              ignoring: true,
              child: VideoCoreForwardAndRewind(
                responsive: widget.responsive,
                showRewind: p.rewindIcons.value,
                showForward: p.forwardIcons.value,
                rewindSeconds: _defaultSeekAmount * p.doubleTapCount.value,
                forwardSeconds: _defaultSeekAmount * p.doubleTapCount.value,
              ),
            ),
          ),
        if (p.enabledOverlays.volume)
          RxBuilder(
            //observables: [_.volume],
            (_) => AnimatedOpacity(
              duration: p.durations.volumeOverlayDuration,
              opacity: p.showVolumeStatus.value ? 1 : 0,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox(
                      height: widget.responsive.height / 2,
                      width: 35,
                      child: Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: [
                          Container(color: Colors.black38),
                          Container(
                            height:
                                p.volume.value * widget.responsive.height / 2,
                            color: Colors.blue,
                          ),
                          Container(
                            padding: const EdgeInsets.all(5),
                            child: const Icon(
                              Icons.music_note,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        if (p.enabledOverlays.brightness)
          RxBuilder(
            //observables: [_.volume],
            (_) => AnimatedOpacity(
              duration: p.durations.brightnessOverlayDuration,
              opacity: p.showBrightnessStatus.value ? 1 : 0,
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox(
                      height: widget.responsive.height / 2,
                      width: 35,
                      child: Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: [
                          Container(color: Colors.black38),
                          Container(
                            height:
                                p.brightness.value *
                                widget.responsive.height /
                                2,
                            color: Colors.blue,
                          ),
                          Container(
                            padding: const EdgeInsets.all(5),
                            child: const Icon(
                              Icons.wb_sunny,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        RxBuilder(
          //observables: [_.showSwipeDuration],
          //observables: [_.swipeDuration],
          (_) => Align(
            alignment: Alignment.center,
            child: AnimatedOpacity(
              duration: p.durations.seekDuration,
              opacity: p.showSwipeDuration.value ? 1 : 0,
              child: Visibility(
                visible: p.showSwipeDuration.value,
                child: Container(
                  color: Colors.grey[900],
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      p.swipeDuration.value > 0
                          ? "+ ${printDuration(Duration(seconds: p.swipeDuration.value))}"
                          : "- ${printDuration(Duration(seconds: p.swipeDuration.value))}",
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        RxBuilder(
          //observables: [_.showSwipeDuration],
          //observables: [_.swipeDuration],
          (_) => Align(
            alignment: Alignment.center,
            child: AnimatedOpacity(
              duration: p.durations.videoFitOverlayDuration,
              opacity: p.videoFitChanged.value ? 1 : 0,
              child: Visibility(
                visible: p.videoFitChanged.value,
                child: Container(
                  color: Colors.grey[900],
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      p.videoFit.value.name[0].toUpperCase() +
                          p.videoFit.value.name.substring(1),
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        RxBuilder(
          //observables: [_.showControls],
          (_) {
            p.dataStatus.status.value;
            if (p.dataStatus.error) {
              return Center(
                child: Text(
                  p.errorText!,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              );
            } else {
              return Container();
            }
          },
        ),
        RxBuilder(
          //observables: [_.showControls],
          (_) {
            p.dataStatus.status.value;
            if (p.dataStatus.loading || p.isBuffering.value) {
              return Center(child: p.loadingWidget);
            } else {
              return Container();
            }
          },
        ),
      ],
    );
  }

  //----------------------------//
  bool checkMobileLock(MeeduPlayerController p) {
    if (!UniversalPlatform.isDesktopOrWeb && !p.lockedControls.value) {
      // reminds the user that the UI is locked
      // showLockIcon();
    }
    return p.lockedControls.value && !UniversalPlatform.isDesktopOrWeb;
  }

  void windowDrag(MeeduPlayerController p) {
    if (p.isInPipMode.value) {
      windowManager.startDragging();
    }
  }

  void onTap(MeeduPlayerController p) {
    if (!p.mobileControls) {
      if (tappedTwice) {
        if (p.enabledControls.desktopDoubleTapToFullScreen) {
          p.toggleFullScreen(context);
        }

        tappedOnce(p, true);
      } else {
        if (p.enabledControls.desktopTapToPlayAndPause) {
          p.togglePlay();
        }
        tappedOnce(p, false);
      }
    }
    p.controls = !p.showControls.value;
    _dragInitialDelta = Offset.zero;
  }

  void onHorizontalDragUpdate(
    DragUpdateDetails details,
    MeeduPlayerController p,
  ) {
    if (checkMobileLock(p)) return;

    if (p.enabledControls.seekSwipes) {
      //if (!_.videoPlayerController!.value.isInitialized) {
      //return;
      //}

      //_.controls=true;
      final Offset position = details.localPosition;
      if (_dragInitialDelta == Offset.zero) {
        final Offset delta = details.delta;
        if (details.localPosition.dx > widget.responsive.width * 0.1 &&
            ((widget.responsive.width - details.localPosition.dx) >
                    widget.responsive.width * 0.1 &&
                !gettingNotification)) {
          _forwardDragStart(position, p);
          _dragInitialDelta = delta;
        } else {
          p.customDebugPrint("##############out###############");
          gettingNotification = true;
        }
      } else {
        if (!gettingNotification) {
          _forwardDragUpdate(position, p);
        }
      }
    }
  }

  void onHorizontalDragEnd(DragEndDetails details, MeeduPlayerController p) {
    if (checkMobileLock(p)) return;

    if (p.enabledControls.seekSwipes) {
      //if (!_.videoPlayerController!.value.isInitialized) {
      //return;
      //}
      gettingNotification = false;
      _forwardDragEnd(p);
    }
  }

  void onVerticalDragUpdate(
    DragUpdateDetails details,
    MeeduPlayerController p,
  ) {
    if (checkMobileLock(p)) return;

    if (p.mobileControls) {
      //if (!_.videoPlayerController!.value.isInitialized) {
      //return;
      //}
      //_.controls=true;

      final Offset position = details.localPosition;
      if (_dragInitialDelta == Offset.zero) {
        p.customDebugPrint(details.localPosition.dy);
        if (details.localPosition.dy > widget.responsive.height * 0.1 &&
            ((widget.responsive.height - details.localPosition.dy) >
                widget.responsive.height * 0.1) &&
            !gettingNotification) {
          final Offset delta = details.delta;
          //if(details.localPosition.dy<30){
          if (details.localPosition.dx >= widget.responsive.width / 2) {
            if (p.enabledControls.volumeSwipes) {
              _volumeDragStart(position, p);
            }
            _dragInitialDelta = delta;
            //customDebugPrint("right");
          } else {
            if (p.mobileControls && p.enabledControls.brightnessSwipes) {
              _brightnessDragStart(position, p);
            }
            _dragInitialDelta = delta;
            //customDebugPrint("left");
          }
        } else {
          p.customDebugPrint("getting Notification");
          gettingNotification = true;
        }
        //}
      } else {
        if (!gettingNotification) {
          if (isVolume && p.enabledControls.volumeSwipes) {
            _volumeDragUpdate(position, p);
          } else {
            if (p.mobileControls && p.enabledControls.brightnessSwipes) {
              _brightnessDragUpdate(position, p);
            }
          }
        }
      }

      //_.videoPlayerController!.seekTo(position);
    }
  }

  void onVerticalDragEnd(DragEndDetails details, MeeduPlayerController p) {
    if (checkMobileLock(p)) return;

    if (p.mobileControls) {
      //if (!_.videoPlayerController!.value.isInitialized) {
      // return;
      //}
      gettingNotification = false;
      if (isVolume && p.enabledControls.volumeSwipes) {
        _volumeDragEnd(p);
      } else {
        if (p.mobileControls && p.enabledControls.brightnessSwipes) {
          _brightnessDragEnd(p);
        }
      }
    }
  }

  Widget videoControls(MeeduPlayerController p, BuildContext context) {
    return GestureDetector(
      onPanStart: UniversalPlatform.isDesktop ? (_) => windowDrag(p) : null,
      onTap: () => onTap(p),
      onLongPressStart:
          (p.mobileControls && p.enabledControls.onLongPressSpeedUp)
          ? (details) {
              if (p.customCallbacks.onLongPressStartedCallback != null) {
                p.customCallbacks.onLongPressStartedCallback!(p);
              } else {
                p.setPlaybackSpeed(2);
              }
            }
          : null,
      onLongPressEnd: (p.mobileControls && p.enabledControls.onLongPressSpeedUp)
          ? (details) {
              if (p.customCallbacks.onLongPressEndedCallback != null) {
                p.customCallbacks.onLongPressEndedCallback!(p);
              } else {
                p.setPlaybackSpeed(1);
              }
            }
          : null,
      onHorizontalDragUpdate: (p.mobileControls && !widget.preventVerticalDrag)
          ? (details) => onHorizontalDragUpdate(details, p)
          : null,
      onHorizontalDragEnd: (p.mobileControls && !widget.preventVerticalDrag)
          ? (details) => onHorizontalDragEnd(details, p)
          : null,
      onVerticalDragUpdate: (p.mobileControls && !widget.preventVerticalDrag)
          ? (details) => onVerticalDragUpdate(details, p)
          : null,
      onVerticalDragEnd: (p.mobileControls && !widget.preventVerticalDrag)
          ? (details) => onVerticalDragEnd(details, p)
          : null,
      child: AnimatedContainer(
        duration: p.durations.controlsDuration,
        color: p.showControls.value ? Colors.black26 : Colors.transparent,
        child: Stack(
          children: [
            if (p.enabledControls.doubleTapToSeek &&
                (p.mobileControls) &&
                !p.lockedControls.value)
              Positioned.fill(
                bottom: widget.responsive.height * 0.20,
                top: widget.responsive.height * 0.20,
                child: VideoCoreForwardAndRewindLayout(
                  responsive: widget.responsive,
                  rewind: GestureDetector(
                    // behavior: HitTestBehavior.translucent,
                    onTap: () {
                      if (p.doubleTapCount.value != 0 || tappedTwice) {
                        _rewind(context, p);
                        tappedOnce(p, true);
                      } else {
                        tappedOnce(p, false);
                      }
                    },
                  ),
                  forward: GestureDetector(
                    // behavior: HitTestBehavior.translucent,
                    onTap: () {
                      if (p.doubleTapCount.value != 0 || tappedTwice) {
                        _forward(context, p);
                        tappedOnce(p, true);
                      } else {
                        tappedOnce(p, false);
                      }
                    },
                    //behavior: HitTestBehavior.,
                  ),
                ),
              ),
            AnimatedOpacity(
              opacity: (!p.showControls.value || p.lockedControls.value)
                  ? 0
                  : 1,
              duration: p.durations.controlsDuration,
              child: IgnorePointer(
                ignoring: (!p.showControls.value || p.lockedControls.value),
                child: widget.child,
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: AnimatedOpacity(
                opacity: !(p.showControls.value && p.lockedControls.value)
                    ? 0
                    : 1,
                duration: p.durations.controlsDuration,
                child: IgnorePointer(
                  ignoring: !(p.showControls.value && p.lockedControls.value),
                  child: LockButton(responsive: p.responsive),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    //_.videoPlayerController!.seekTo(position);
  }

  @override
  Widget build(BuildContext context) {
    final p = MeeduPlayerController.of(context);

    return Positioned.fill(child: controlsUI(p, context));
  }
}
