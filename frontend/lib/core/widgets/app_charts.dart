import 'package:flutter/material.dart';

import '../../models/app_models.dart';

class AppBarChart extends StatelessWidget {
  const AppBarChart({super.key, required this.points, this.height = 180});

  final List<AnalyticsPoint> points;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: CustomPaint(
        painter: _BarChartPainter(
          points: points,
          color: Theme.of(context).colorScheme.primary,
          labelColor: Theme.of(context).colorScheme.onSurfaceVariant,
          gridColor: Theme.of(context).colorScheme.outlineVariant,
        ),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class AppLineChart extends StatelessWidget {
  const AppLineChart({super.key, required this.points, this.height = 180});

  final List<AnalyticsPoint> points;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: CustomPaint(
        painter: _LineChartPainter(
          points: points,
          color: Theme.of(context).colorScheme.tertiary,
          labelColor: Theme.of(context).colorScheme.onSurfaceVariant,
          gridColor: Theme.of(context).colorScheme.outlineVariant,
        ),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _BarChartPainter extends CustomPainter {
  _BarChartPainter({
    required this.points,
    required this.color,
    required this.labelColor,
    required this.gridColor,
  });

  final List<AnalyticsPoint> points;
  final Color color;
  final Color labelColor;
  final Color gridColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;
    final paint = Paint()..color = color;
    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 1;
    final maxValue = points.map((p) => p.value).reduce((a, b) => a > b ? a : b);
    final chartHeight = size.height - 28;
    final barWidth = (size.width / points.length) * 0.56;
    for (var i = 0; i < 4; i++) {
      final y = chartHeight * (i / 3);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
    for (var i = 0; i < points.length; i++) {
      final point = points[i];
      final x =
          (size.width / points.length) * i +
          (size.width / points.length - barWidth) / 2;
      final barHeight = chartHeight * (point.value / maxValue);
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, chartHeight - barHeight, barWidth, barHeight),
        const Radius.circular(6),
      );
      canvas.drawRRect(rect, paint);
      _drawLabel(
        canvas,
        point.label,
        Offset(x + barWidth / 2, chartHeight + 14),
      );
    }
  }

  void _drawLabel(Canvas canvas, String label, Offset center) {
    final painter = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(color: labelColor, fontSize: 11),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(
      canvas,
      center - Offset(painter.width / 2, painter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant _BarChartPainter oldDelegate) =>
      oldDelegate.points != points ||
      oldDelegate.color != color ||
      oldDelegate.labelColor != labelColor;
}

class _LineChartPainter extends CustomPainter {
  _LineChartPainter({
    required this.points,
    required this.color,
    required this.labelColor,
    required this.gridColor,
  });

  final List<AnalyticsPoint> points;
  final Color color;
  final Color labelColor;
  final Color gridColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;
    final maxValue = points.map((p) => p.value).reduce((a, b) => a > b ? a : b);
    final chartHeight = size.height - 28;
    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 1;
    for (var i = 0; i < 4; i++) {
      final y = chartHeight * (i / 3);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
    final path = Path();
    for (var i = 0; i < points.length; i++) {
      final x = (size.width / (points.length - 1)) * i;
      final y = chartHeight - chartHeight * (points[i].value / maxValue);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
      _drawLabel(canvas, points[i].label, Offset(x, chartHeight + 14));
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round,
    );
    for (var i = 0; i < points.length; i++) {
      final x = (size.width / (points.length - 1)) * i;
      final y = chartHeight - chartHeight * (points[i].value / maxValue);
      canvas.drawCircle(Offset(x, y), 5, Paint()..color = color);
    }
  }

  void _drawLabel(Canvas canvas, String label, Offset center) {
    final painter = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(color: labelColor, fontSize: 11),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(
      canvas,
      center - Offset(painter.width / 2, painter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter oldDelegate) =>
      oldDelegate.points != points ||
      oldDelegate.color != color ||
      oldDelegate.labelColor != labelColor;
}
