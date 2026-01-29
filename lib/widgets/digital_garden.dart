import 'package:flutter/material.dart';
import '../main.dart';

class DigitalGarden extends StatelessWidget {
  const DigitalGarden({super.key});

  @override
  Widget build(BuildContext context) {
    int scanCount = HomePage.scanCount;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.05),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.green.withOpacity(0.2), width: 2),
      ),
      child: Column(
        children: [
          Text(
            "DİJİTAL ORMANIN",
            style: TextStyle(
              fontSize: 10, 
              fontWeight: FontWeight.bold, 
              color: Colors.green.shade800, 
              letterSpacing: 1.2
            ),
          ),
          const SizedBox(height: 15),
          scanCount == 0 
            ? _buildEmptyState()
            : _buildGardenContent(scanCount),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const SizedBox(
      height: 80,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("🔭", style: TextStyle(fontSize: 30)),
            SizedBox(height: 5),
            Text(
              "Henüz bir ağacın yok, tarama yap ve ormanını büyüt!",
              style: TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGardenContent(int count) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: List.generate(count, (index) {
        return TweenAnimationBuilder(
          duration: Duration(milliseconds: 500 + (index * 100)),
          tween: Tween<double>(begin: 0, end: 1),
          builder: (context, double value, child) {
            return Transform.scale(
              scale: value,
              child: Icon(
                index < 2 ? Icons.eco : Icons.forest, 
                color: Colors.green.shade600, 
                size: 35
              ),
            );
          },
        );
      }),
    );
  }
}