import 'package:flutter/material.dart';

enum RippleSide { left, right }

class ForwardAndRewindRippleSide extends StatelessWidget {
  const ForwardAndRewindRippleSide({
    super.key,
    required this.side,
    required this.text,
  });

  final RippleSide side;
  final String text;

  @override
  Widget build(BuildContext context) {
    //final style = VideoViewerStyle();
    //final ripple = style.forwardAndRewindStyle.ripple;
    final ripple = Colors.black.withValues(alpha: 0.45);
    return CustomPaint(
      size: Size.infinite,
      painter: side == RippleSide.left
          ? _RippleLeftPainter(ripple)
          : _RippleRightPainter(ripple),
      child: Padding(
        padding: side == RippleSide.left
            ? const EdgeInsets.only(right: 10)
            : const EdgeInsets.only(left: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            side == RippleSide.left
                ? const Icon(Icons.replay_10, color: Colors.white, size: 36)
                : const Icon(Icons.forward_10, color: Colors.white, size: 36),
            const SizedBox(height: 6),
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RippleLeftPainter extends CustomPainter {
  _RippleLeftPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawPath(
      Path()
        ..arcTo(
          Offset(size.width * 0.75, 0.0) & Size(size.width / 4, size.height),
          -1.5,
          3,
          false,
        )
        ..lineTo(0.0, size.height)
        ..lineTo(0.0, 0.0),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class _RippleRightPainter extends CustomPainter {
  _RippleRightPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawPath(
      Path()
        ..arcTo(
          Offset.zero & Size(size.width / 4, size.height),
          -1.5,
          -3.3,
          false,
        )
        ..lineTo(size.width, size.height)
        ..lineTo(size.width, 0.0),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
