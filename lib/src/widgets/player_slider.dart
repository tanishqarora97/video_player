import 'package:flutter/material.dart';
import 'package:flutter_meedu/rx/rx_builder.dart';
import '../../meedu_player.dart';

class PlayerSlider extends StatelessWidget {
  const PlayerSlider({super.key});

  @override
  Widget build(BuildContext context) {
    final p = MeeduPlayerController.of(context);
    return LayoutBuilder(
      builder: (ctx, constraints) {
        return RxBuilder((_) {
          final double maxMs = p.duration.value.inMilliseconds.toDouble();
          final double value = p.sliderPosition.value.inMilliseconds
              .toDouble()
              .clamp(0, maxMs <= 0 ? 0 : maxMs);

          return SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 3,
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
              thumbShape: const RoundSliderThumbShape(
                enabledThumbRadius: 6,
                elevation: 0,
              ),
              trackShape: const _NetflixTrackShape(),
              activeTrackColor: p.colorTheme,
              inactiveTrackColor: Colors.white.withValues(alpha: 0.28),
              thumbColor: p.colorTheme,
              overlayColor: p.colorTheme.withValues(alpha: 0.18),
            ),
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: FractionallySizedBox(
                    widthFactor: p.bufferedPercent.value.clamp(0.0, 1.0),
                    child: Container(
                      height: 3,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.38),
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                  ),
                ),
                Slider(
                  min: 0,
                  max: maxMs <= 0 ? 1 : maxMs,
                  value: maxMs <= 0 ? 0 : value,
                  onChangeStart: (_) => p.onChangedSliderStart(),
                  onChangeEnd: (v) {
                    p.onChangedSliderEnd();
                    p.seekTo(Duration(milliseconds: v.floor()));
                  },
                  onChanged: p.onChangedSlider,
                ),
              ],
            ),
          );
        });
      },
    );
  }
}

class _NetflixTrackShape extends RoundedRectSliderTrackShape {
  const _NetflixTrackShape();

  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    SliderThemeData? sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme?.trackHeight ?? 3;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    return Rect.fromLTWH(
      trackLeft,
      trackTop,
      parentBox.size.width,
      trackHeight,
    );
  }
}
