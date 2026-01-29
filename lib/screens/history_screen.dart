import 'package:flutter/material.dart';
import '../models/product_model.dart';
import 'passport_detail_screen.dart';

class HistoryScreen extends StatelessWidget {
  final List<Product> products;

  const HistoryScreen({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Okutma Geçmişi"),
        centerTitle: true,
      ),
      body: products.isEmpty
          ? const Center(child: Text("Henüz bir ürün okutmadınız."))
          : ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final p = products.reversed.toList()[index];
                return ListTile(
                  leading: const Icon(Icons.eco, color: Color(0xFF4F6D30)),
                  title: Text(p.name),
                  subtitle: Text("Puan: ${p.ecoScore}"),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PassportDetailScreen(product: p)),
                  ),
                );
              },
            ),
    );
  }
}