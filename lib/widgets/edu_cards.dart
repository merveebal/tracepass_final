import 'package:flutter/material.dart';

class EduCards extends StatelessWidget {
  const EduCards({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          _buildTipCard(
            "Su Tasarrufu", 
            "Bir tişört üretimi için tam 2700 litre su harcanır. Bu bir kişinin 3 yıllık içme suyuna bedeldir!", 
            Icons.water_drop, 
            const Color(0xFFBBDEFB)
          ),
          _buildTipCard(
            "Geri Dönüşüm", 
            "Polyester ürünler doğada 200 yıl yok olmaz. Geri dönüştürülmüş kumaşları tercih et!", 
            Icons.recycling, 
            const Color(0xFFC8E6C9)
          ),
          _buildTipCard(
            "Karbon İzi", 
            "Yerel üretim ürünler, nakliye süreci kısalığı sayesinde %30 daha az karbon salınımı yapar.", 
            Icons.co2, 
            const Color(0xFFFFE0B2)
          ),
          _buildTipCard(
            "İkinci Şans", 
            "Kıyafetlerini çöpe atmak yerine bağışla. Tekstil atıkları dünyayı en çok kirleten 2. sektördür.", 
            Icons.volunteer_activism, 
            const Color(0xFFF8BBD0)
          ),
        ],
      ),
    );
  }

  Widget _buildTipCard(String title, String desc, IconData icon, Color color) {
    return Container(
      width: 240,
      margin: const EdgeInsets.only(right: 15),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: Colors.white.withOpacity(0.5),
            radius: 20,
            child: Icon(icon, color: Colors.black87, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            title, 
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87)
          ),
          const SizedBox(height: 6),
          Expanded(
            child: Text(
              desc, 
              style: TextStyle(fontSize: 12, color: Colors.black.withOpacity(0.7)),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}