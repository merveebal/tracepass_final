import 'package:flutter/material.dart';

class ArchiveScreen extends StatelessWidget {
  const ArchiveScreen({super.key});

  final List<Map<String, dynamic>> myCollection = const [
    {
      "name": "TracePass Premium Denim #08",
      "date": "12 Ocak 2026",
      "image": "https://images.unsplash.com/photo-1542272604-787c3835535d?q=80&w=1000",
      "score": 96
    },
    {
      "name": "Heritage Wool Coat",
      "date": "05 Ocak 2026",
      "image": "https://images.unsplash.com/photo-1539533018447-63fcce2678e3?q=80&w=1000",
      "score": 92
    }
  ];

  final Color forestGreen = const Color(0xFF1B3022);
  final Color luxuryGold = const Color(0xFFD4AF37);
  final Color creamBeige = const Color(0xFFF2EFE9);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: creamBeige,
      appBar: AppBar(
        title: const Text("THE ARCHIVE", 
          style: TextStyle(color: Colors.white, letterSpacing: 4, fontSize: 14, fontWeight: FontWeight.w300)),
        backgroundColor: forestGreen,
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildArchiveHeader(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: myCollection.length,
              itemBuilder: (context, index) => _buildCollectionItem(myCollection[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArchiveHeader() {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("SİZİN KOLEKSİYONUNUZ", 
            style: TextStyle(color: forestGreen.withOpacity(0.5), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2)),
          const SizedBox(height: 8),
          const Text("Dijital Gardırobunuz", 
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87)),
        ],
      ),
    );
  }

  Widget _buildCollectionItem(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15)],
      ),
      child: Row(
        children: [
          Container(
            width: 100,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(25)),
              image: DecorationImage(image: NetworkImage(item['image']), fit: BoxFit.cover),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(item['date'], style: TextStyle(color: luxuryGold, fontSize: 9, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Text(item['name'], 
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: forestGreen, fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.eco, color: forestGreen, size: 12),
                      const SizedBox(width: 5),
                      Text("EcoScore: ${item['score']}", style: const TextStyle(fontSize: 10, color: Colors.black45)),
                    ],
                  )
                ],
              ),
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.black12),
          const SizedBox(width: 15),
        ],
      ),
    );
  }
}