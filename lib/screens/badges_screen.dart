import 'package:flutter/material.dart';

class BadgesScreen extends StatelessWidget {
  const BadgesScreen({super.key});

  final Color forestGreen = const Color(0xFF4F6D30);
  final Color clayBrown = const Color(0xFF8D6E63);
  final Color creamBeige = const Color(0xFFE5D9C3);

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : creamBeige,
      appBar: AppBar(
        title: const Text("Rozet Koleksiyonum"),
        backgroundColor: forestGreen,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            color: forestGreen,
            width: double.infinity,
            child: const Column(
              children: [
                Text("12 / 24 Rozet Açıldı", style: TextStyle(color: Colors.white70, fontSize: 14)),
                SizedBox(height: 10),
                LinearProgressIndicator(
                  value: 0.5,
                  backgroundColor: Colors.white24,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          
          Expanded(
            child: GridView.count(
              padding: const EdgeInsets.all(20),
              crossAxisCount: 3,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              children: [
                _buildBadgeItem("Doğa Dostu", Icons.eco, true),
                _buildBadgeItem("Su Koruyucu", Icons.water_drop, true),
                _buildBadgeItem("Blockchain", Icons.verified_user, true),
                _buildBadgeItem("Hızlı Tarayıcı", Icons.qr_code_scanner, true),
                _buildBadgeItem("Geri Dönüşüm", Icons.recycling, false),
                _buildBadgeItem("Karbon Avcısı", Icons.cloud_off, false),
                _buildBadgeItem("Orman Dostu", Icons.forest, false),
                _buildBadgeItem("Gece Kuşu", Icons.dark_mode, false),
                _buildBadgeItem("Eko Elçi", Icons.campaign, false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadgeItem(String name, IconData icon, bool isUnlocked) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: isUnlocked ? Colors.white : Colors.grey.withOpacity(0.2),
            shape: BoxShape.circle,
            boxShadow: isUnlocked 
              ? [BoxShadow(color: forestGreen.withOpacity(0.2), blurRadius: 10)] 
              : null,
            border: isUnlocked 
              ? Border.all(color: forestGreen, width: 2) 
              : Border.all(color: Colors.grey.withOpacity(0.5), width: 1),
          ),
          child: Icon(
            icon, 
            color: isUnlocked ? forestGreen : Colors.grey, 
            size: 35
          ),
        ),
        const SizedBox(height: 8),
        Text(
          name, 
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 10, 
            fontWeight: isUnlocked ? FontWeight.bold : FontWeight.normal,
            color: isUnlocked ? Colors.black87 : Colors.grey,
          ),
        ),
      ],
    );
  }
}