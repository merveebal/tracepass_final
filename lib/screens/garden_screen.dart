import 'dart:math';
import 'package:flutter/material.dart';
import '../models/garden_item.dart';
import '../main.dart';

class GardenScreen extends StatefulWidget {
  const GardenScreen({super.key});

  @override
  State<GardenScreen> createState() => _GardenScreenState();
}

class _GardenScreenState extends State<GardenScreen> {
  List<GardenItem> get myGarden => HomePage.myGardenData;
  static bool hasSquirrel = false;

  double? acornX;
  double? acornY;

  @override
  void initState() {
    super.initState();
    if (hasSquirrel) {
      _generateNewAcorn();
    }
  }

  void _generateNewAcorn() {
    setState(() {
      acornX = 50.0 + Random().nextInt(200);
      acornY = 150.0 + Random().nextInt(300);
    });
  }

  void _collectAcorn() {
    setState(() {
      HomePage.totalPoints += 15;
      _generateNewAcorn();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Sincap palamudu kaptı! +15 Puan"),
        duration: Duration(milliseconds: 800),
        backgroundColor: Colors.orange,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dijital Ormanım"),
        backgroundColor: const Color(0xFF4F6D30),
        foregroundColor: Colors.white,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF87CEEB), Color(0xFFB9F6CA)],
          ),
        ),
        child: Stack(
          children: [
            // Puan Tablosu
            Positioned(
              top: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.stars, color: Colors.orange),
                    const SizedBox(width: 8),
                    Text("${HomePage.totalPoints} Puan",
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
              ),
            ),

            // Palamut
            if (hasSquirrel && acornX != null)
              Positioned(
                left: acornX,
                top: acornY,
                child: GestureDetector(
                  onTap: _collectAcorn,
                  child: const Text("🌰", style: TextStyle(fontSize: 35)),
                ),
              ),

            // Sincap
            if (hasSquirrel)
              Positioned(
                bottom: 150,
                right: 50,
                child: Column(
                  children: [
                    const Text("🐿️", style: TextStyle(fontSize: 55)),
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.orangeAccent),
                      ),
                      child: const Text("Palamutları topla!",
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
              ),

            // Sürüklenebilir Fidanlar
            ...myGarden.map((item) => Positioned(
                  left: item.xPosition,
                  top: item.yPosition,
                  child: Draggable(
                    feedback: Opacity(
                      opacity: 0.7,
                      child: Material(
                        color: Colors.transparent,
                        child: _buildTreeWidget(item),
                      ),
                    ),
                    childWhenDragging: const SizedBox.shrink(), // Sürüklenirken eski yeri boş kalsın
                    onDragEnd: (details) {
                      setState(() {
                        // Sürükleme bittiğinde koordinatları güncelle
                        final RenderBox renderBox = context.findRenderObject() as RenderBox;
                        final localOffset = renderBox.globalToLocal(details.offset);
                        
                        // İkonun merkezini ayarlamak için küçük bir ofset çıkarıyoruz
                        item.xPosition = localOffset.dx - 40; 
                        item.yPosition = localOffset.dy - 80;
                      });
                    },
                    child: GestureDetector(
                      onTap: () => _upgradeTree(item),
                      child: _buildTreeWidget(item),
                    ),
                  ),
                )),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (!hasSquirrel)
            FloatingActionButton.extended(
              heroTag: "btn1",
              onPressed: _buySquirrel,
              label: const Text("Sincap Al (100 Puan)"),
              icon: const Icon(Icons.pets),
              backgroundColor: Colors.orangeAccent,
            ),
          const SizedBox(height: 10),
          FloatingActionButton.extended(
            heroTag: "btn2",
            onPressed: _addNewPlant,
            label: const Text("Fidan Dik (50 Puan)",
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            icon: const Icon(Icons.add_circle, color: Colors.black),
            backgroundColor: const Color(0xFF00E676),
          ),
        ],
      ),
    );
  }

  Widget _buildTreeWidget(GardenItem item) {
    double size = item.growthLevel == 1 ? 50.0 : (item.growthLevel == 2 ? 80.0 : 110.0);
    IconData icon = item.growthLevel == 1
        ? Icons.grass
        : (item.growthLevel == 2 ? Icons.park : Icons.forest);
    Color color = item.growthLevel == 1
        ? Colors.lightGreenAccent[700]!
        : (item.growthLevel == 2 ? Colors.green[600]! : const Color(0xFF2E7D32));

    return Column(
      children: [
        Icon(icon, size: size, color: color),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(10)),
          child: Text("Lv ${item.growthLevel}",
              style: const TextStyle(color: Colors.white, fontSize: 10)),
        )
      ],
    );
  }

  void _addNewPlant() {
    if (HomePage.totalPoints >= 50) {
      setState(() {
        HomePage.totalPoints -= 50;
        myGarden.add(GardenItem(
          id: DateTime.now().toString(),
          type: "oak",
          growthLevel: 1,
          xPosition: 100.0, // Yeni fidan artık sabit bir yerde başlar, sen sürükler ayırırsın
          yPosition: 200.0,
        ));
      });
    } else {
      _showError("Yeterli puanın yok!");
    }
  }

  void _buySquirrel() {
    if (HomePage.totalPoints >= 100) {
      setState(() {
        HomePage.totalPoints -= 100;
        hasSquirrel = true;
        _generateNewAcorn();
      });
    } else {
      _showError("100 Puan lazım!");
    }
  }

  void _upgradeTree(GardenItem item) {
    if (item.growthLevel < 3 && HomePage.totalPoints >= 30) {
      setState(() {
        HomePage.totalPoints -= 30;
        item.growthLevel++;
      });
    } else if (item.growthLevel >= 3) {
      _showError("Bu ağaç zaten maksimum seviyede!");
    } else {
      _showError("Büyütmek için 30 puan lazım!");
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: Colors.redAccent,
      duration: const Duration(seconds: 1),
    ));
  }
}