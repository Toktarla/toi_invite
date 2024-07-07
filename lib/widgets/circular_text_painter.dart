import 'package:flutter/material.dart';
import 'dart:math' as math;

class CircularTextPainter extends CustomPainter {
  final String text;
  final TextStyle textStyle;

  CircularTextPainter({required this.text, required this.textStyle});

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width / 2 - 10; // Adjust radius to be closer to the circle
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: textStyle),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    final textLength = text.length;
    final anglePerLetter = 2 * math.pi / textLength;

    for (int i = 0; i < textLength; i++) {
      final letter = text[i];
      final angle = i * anglePerLetter;

      final offset = Offset(
        radius * math.cos(angle) + size.width / 2,
        radius * math.sin(angle) + size.height / 2,
      );

      canvas.save();
      canvas.translate(offset.dx, offset.dy);
      canvas.rotate(angle + math.pi / 2);
      textPainter.text = TextSpan(text: letter, style: textStyle);
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          -textPainter.width / 2,
          -textPainter.height / 2,
        ),
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}