import 'package:flutter/material.dart';
import 'package:flutter_meedu/rx/rx_builder.dart';
import '../../meedu_player.dart';

class ClosedCaptionView extends StatelessWidget {
  final Responsive responsive;
  final double distanceFromBottom;

  ///[customCaptionView] when a custom view for the captions is needed
  final Widget Function(
    BuildContext context,
    MeeduPlayerController controller,
    Responsive responsive,
    String text,
  )?
  customCaptionView;
  const ClosedCaptionView({
    super.key,
    required this.responsive,
    this.distanceFromBottom = 30,
    this.customCaptionView,
  });

  @override
  Widget build(BuildContext context) {
    final p = MeeduPlayerController.of(context);
    return RxBuilder(
      //observables: [_.closedCaptionEnabled],
      (_) {
        if (!p.closedCaptionEnabled.value) return Container();

        return StreamBuilder<Duration>(
          initialData: Duration.zero,
          stream: p.onPositionChanged,
          builder: (_, snapshot) {
            if (snapshot.hasError) {
              return Container();
            }

            final strSubtitle = p.videoPlayerController!.value.caption.text;

            return Positioned(
              left: 60,
              right: 60,
              bottom: distanceFromBottom,
              child: customCaptionView != null
                  ? customCaptionView!(context, p, responsive, strSubtitle)
                  : ClosedCaption(
                      text: strSubtitle,
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: responsive.fontSize(),
                      ),
                    ),
            );
          },
        );
      },
    );
  }
}
