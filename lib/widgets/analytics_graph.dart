// 📁 lib/widgets/analytics_graph.dart
import 'package:flutter/material.dart';

class AnalyticsGraph extends StatelessWidget {
  final List<int> weeklyData;

  const AnalyticsGraph({Key? key, required this.weeklyData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      padding: const EdgeInsets.all(16),
      child: CustomPaint(
        painter: GraphPainter(weeklyData),
        size: const Size(double.infinity, 80),
      ),
    );
  }
}

class GraphPainter extends CustomPainter {
  final List<int> data;

  GraphPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF8B1538)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    if (data.isEmpty) return;

    final path = Path();
    final maxValue = data.reduce((a, b) => a > b ? a : b);
    final stepX = size.width / (data.length - 1);

    for (int i = 0; i < data.length; i++) {
      final x = i * stepX;
      final y = size.height - (data[i] / maxValue) * size.height;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}