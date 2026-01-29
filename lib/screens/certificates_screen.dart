import 'package:flutter/material.dart';

class CertificatesScreen extends StatelessWidget {
  const CertificatesScreen({super.key});

  final Color forestGreen = const Color(0xFF4F6D30);
  final Color clayBrown = const Color(0xFF8D6E63);
  final Color creamBeige = const Color(0xFFE5D9C3);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: creamBeige,
      appBar: AppBar(
        title: const Text("Sertifika Koleksiyonu"),
        backgroundColor: forestGreen,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildCertCard(
            "GOTS Organik Sertifikası",
            "Bu sertifika, okuttuğun %100 pamuklu ürünlerin organik olduğunu kanıtlar.",
            "12.01.2026",
            Icons.verified,
          ),
          _buildCertCard(
            "Karbon Ayak İzi Onayı",
            "Yıllık karbon salınımını %20 azalttığın için düzenlenmiştir.",
            "05.01.2026",
            Icons.cloud_done,
          ),
          _buildCertCard(
            "Fair Trade (Adil Ticaret)",
            "Etik üretim yapan markaları desteklediğin için teşekkürler.",
            "28.12.2025",
            Icons.handshake,
          ),
        ],
      ),
    );
  }

  Widget _buildCertCard(String title, String desc, String date, IconData icon) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: forestGreen.withOpacity(0.2), width: 2),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Row(
        children: [
          Icon(icon, color: forestGreen, size: 40),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 5),
                Text(desc, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 10),
                Text("Tarih: $date", style: TextStyle(fontSize: 10, color: forestGreen, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}