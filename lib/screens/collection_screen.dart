import 'package:flutter/material.dart';
import '../main.dart';
import '../widgets/digital_garden.dart';

class CollectionScreen extends StatefulWidget {
  const CollectionScreen({super.key});

  @override
  State<CollectionScreen> createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  final Color forestGreen = const Color(0xFF4F6D30);

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    bool hasBronze = HomePage.scanCount >= 1;
    bool hasSilver = HomePage.scanCount >= 3;
    bool hasGold = (HomePage.scanCount >= 5);
    bool hasEcoFriend = HomePage.scanCount >= 10;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Başarı Koleksiyonu', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: forestGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: Center(child: Text("${HomePage.scanCount} Tarama", style: const TextStyle(fontWeight: FontWeight.bold))),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark 
              ? [const Color(0xFF121212), const Color(0xFF1A1A1A)]
              : [const Color(0xFFF5F5F5), Colors.white],
          ),
        ),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: DigitalGarden(), 
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: Divider(thickness: 1),
            ),

            _buildSectionTitle(isDark, "Kazandığın Sertifikalar"),

            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                padding: const EdgeInsets.all(20),
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                childAspectRatio: 0.85,
                children: [
                  _buildCertificateCard(
                    context,
                    title: "Bronz Elçi",
                    subtitle: "İlk Adım Atıldı",
                    isLocked: !hasBronze,
                    color: Colors.orangeAccent,
                    icon: Icons.emoji_events,
                  ),
                  _buildCertificateCard(
                    context,
                    title: "Gümüş Koruyucu",
                    subtitle: "3 Ürün Onayı",
                    isLocked: !hasSilver,
                    color: Colors.teal,
                    icon: Icons.shield,
                  ),
                  _buildCertificateCard(
                    context,
                    title: "Altın Kahraman",
                    subtitle: "5 Ürün Onayı",
                    isLocked: !hasGold,
                    color: Colors.amber,
                    icon: Icons.workspace_premium,
                  ),
                  _buildCertificateCard(
                    context,
                    title: "Doğa Elçisi",
                    subtitle: "10 Ürün Onayı",
                    isLocked: !hasEcoFriend,
                    color: Colors.green,
                    icon: Icons.forest,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(bool isDark, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: Row(
        children: [
          Icon(Icons.military_tech, color: forestGreen),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 18, 
              fontWeight: FontWeight.bold, 
              color: isDark ? Colors.white : forestGreen
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCertificateCard(BuildContext context, 
      {required String title, required String subtitle, required bool isLocked, required Color color, required IconData icon}) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        if (isLocked) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Bu sertifikayı açmak için daha fazla tarama yapmalısın! 🌿")),
          );
        } else {
          _showCertificateDetail(context, title, color, icon);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        decoration: BoxDecoration(
          color: isLocked 
              ? (isDark ? Colors.white10 : Colors.grey.withOpacity(0.1)) 
              : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isLocked ? Colors.grey.withOpacity(0.3) : color, 
            width: isLocked ? 1 : 2.5
          ),
          boxShadow: isLocked ? [] : [
            BoxShadow(color: color.withOpacity(0.2), blurRadius: 12, spreadRadius: 2)
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isLocked ? Icons.lock_outline : icon,
              size: 48,
              color: isLocked ? Colors.grey : color,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: isLocked ? Colors.grey : (isDark ? Colors.white : Colors.black87),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              isLocked ? "Kilitli" : "Kazanıldı",
              style: TextStyle(
                fontSize: 11, 
                color: isLocked ? Colors.grey : color,
                fontWeight: FontWeight.bold
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCertificateDetail(BuildContext context, String title, Color color, IconData icon) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(30),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 80, color: color),
            const SizedBox(height: 20),
            Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text(
              "Bu sertifika dijital pasaport taramalarınız sonucunda çevreye verdiğiniz destekten dolayı Blockchain üzerinden adınıza tanımlanmıştır.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: const Text("HARİKA!", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}