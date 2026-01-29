import 'package:flutter/material.dart';
import 'dart:math' as math;

class ImpactDashboard extends StatelessWidget {
  final int totalScans;
  final int totalPoints;
  final double savedCO2;

  const ImpactDashboard({
    super.key,
    required this.totalScans,
    required this.totalPoints,
    required this.savedCO2,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color forestGreen = const Color(0xFF4F6D30);
    final Color textColor = isDark ? Colors.white : forestGreen;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[900] : forestGreen.withOpacity(0.9),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: forestGreen.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              'Çevresel Etkin',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 200,
              height: 200,
              child: CustomPaint(
                painter: ImpactRingPainter(
                  scanProgress: totalScans / 100.0,
                  pointProgress: totalPoints / 500.0,
                  co2Progress: savedCO2 / 10.0,
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${(totalScans * 0.3).toStringAsFixed(1)} kg',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const Text(
                        'CO2 Tasarrufu',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildRingLegend(
              context,
              color: Colors.lightGreenAccent,
              label: 'Okutma Adedi: $totalScans',
              icon: Icons.qr_code_scanner,
              isDark: isDark
            ),
            _buildRingLegend(
              context,
              color: Colors.tealAccent,
              label: 'Toplam Puan: $totalPoints',
              icon: Icons.eco,
              isDark: isDark
            ),
            _buildRingLegend(
              context,
              color: Colors.blueAccent,
              label: 'CO2 Tasarrufu: ${savedCO2.toStringAsFixed(1)} kg',
              icon: Icons.cloud_done,
              isDark: isDark
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRingLegend(BuildContext context, {required Color color, required String label, required IconData icon, required bool isDark}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class ImpactRingPainter extends CustomPainter {
  final double scanProgress;
  final double pointProgress;
  final double co2Progress;

  ImpactRingPainter({
    required this.scanProgress,
    required this.pointProgress,
    required this.co2Progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    const strokeWidth = 12.0;

    final bgPaint = Paint()
      ..color = Colors.white.withOpacity(0.15)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: size.width / 2 - strokeWidth / 2),
      -math.pi / 2,
      2 * math.pi * co2Progress,
      false,
      Paint()
        ..color = Colors.blueAccent
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawCircle(center, size.width / 2 - strokeWidth / 2, bgPaint);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: size.width / 2 - strokeWidth * 1.5 - strokeWidth / 2),
      -math.pi / 2,
      2 * math.pi * pointProgress,
      false,
      Paint()
        ..color = Colors.tealAccent
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawCircle(center, size.width / 2 - strokeWidth * 1.5 - strokeWidth / 2, bgPaint);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: size.width / 2 - strokeWidth * 3 - strokeWidth / 2),
      -math.pi / 2,
      2 * math.pi * scanProgress,
      false,
      Paint()
        ..color = Colors.lightGreenAccent
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawCircle(center, size.width / 2 - strokeWidth * 3 - strokeWidth / 2, bgPaint);
  }

  @override
  bool shouldRepaint(covariant ImpactRingPainter oldDelegate) {
    return oldDelegate.scanProgress != scanProgress ||
           oldDelegate.pointProgress != pointProgress ||
           oldDelegate.co2Progress != co2Progress;
  }
}