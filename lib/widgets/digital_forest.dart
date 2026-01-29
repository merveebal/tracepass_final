import 'package:flutter/material.dart';
import '../main.dart';

class DigitalForest extends StatelessWidget {
  const DigitalForest({super.key});

  @override
  Widget build(BuildContext context) {
    int totalTrees = (HomePage.scanCount / 5).floor();
    
    int pineTrees = totalTrees ~/ 2;
    int oakTrees = totalTrees - pineTrees;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.withOpacity(0.2), Colors.teal.withOpacity(0.1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.green.withOpacity(0.3), width: 1.5),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Dijital Ormanın",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2D3E1A)),
                  ),
                  Text(
                    "Dünyayı güzelleştiriyorsun...",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  "$totalTrees Ağaç",
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          Container(
            height: 120,
            width: double.infinity,
            alignment: Alignment.center,
            child: totalTrees == 0
                ? _buildEmptyState()
                : SingleChildScrollView(
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      alignment: WrapAlignment.center,
                      children: [
                        ...List.generate(pineTrees, (index) => 
                          const Icon(Icons.park, color: Color(0xFF1B5E20), size: 35)),
                        ...List.generate(oakTrees, (index) => 
                          const Icon(Icons.forest, color: Color(0xFF43A047), size: 35)),
                      ],
                    ),
                  ),
          ),
          
          const SizedBox(height: 15),
          
          _buildProgressBar(context),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.eco_outlined, color: Colors.green.withOpacity(0.5), size: 40),
        const SizedBox(height: 8),
        const Text(
          "Henüz hiç ağacın yok.\nİlk ağacın için 5 ürün okutmalısın!",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey, fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildProgressBar(BuildContext context) {
    double progress = (HomePage.scanCount % 5) / 5;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Yeni ağaca hazırlık", style: TextStyle(fontSize: 11, color: Colors.grey)),
            Text("${(progress * 100).toInt()}%", style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 5),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.white,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
            minHeight: 6,
          ),
        ),
      ],
    );
  }
}