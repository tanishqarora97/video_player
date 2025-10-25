import 'package:flutter/material.dart';
import 'package:flutter_meedu/rx/rx_builder.dart';
import '../../meedu_player.dart';

class PlayerSlider extends StatelessWidget {
  const PlayerSlider({super.key});

  @override
  Widget build(BuildContext context) {
    final p = MeeduPlayerController.of(context);
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        LayoutBuilder(
          builder: (ctx, constraints) {
            return RxBuilder(
              //observables: [_.buffered, _.duration],
              (_) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  color: Colors.white30,
                  width: constraints.maxWidth * p.bufferedPercent.value,
                  height: 3,
                );
              },
            );
          },
        ),
        RxBuilder(
          //observables: [_.sliderPosition, _.duration],
          (_) {
            final double value = p.sliderPosition.value.inMilliseconds
                .toDouble();
            final double max = p.duration.value.inMilliseconds.toDouble();
            // if (value > max || max <= 0) {
            //   return Container();
            // }
            return Container(
              constraints: const BoxConstraints(maxHeight: 30),
              padding: const EdgeInsets.only(bottom: 8),
              alignment: Alignment.center,
              child: SliderTheme(
                data: SliderThemeData(
                  trackShape: MSliderTrackShape(),
                  thumbColor: p.colorTheme,
                  activeTrackColor: p.colorTheme,
                  trackHeight: 10,
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 4.0,
                  ),
                ),
                child: Slider(
                  min: 0,
                  divisions: null,
                  value: value,
                  onChangeStart: (v) {
                    p.onChangedSliderStart();
                  },
                  onChangeEnd: (v) {
                    p.onChangedSliderEnd();
                    p.seekTo(Duration(milliseconds: v.floor()));
                  },
                  label: printDuration(p.sliderPosition.value),
                  max: max,
                  onChanged: p.onChangedSlider,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class MSliderTrackShape extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    SliderThemeData? sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    const double trackHeight = 1;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2 + 4;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
