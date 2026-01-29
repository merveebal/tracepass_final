import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/product_model.dart';

class PassportDetailScreen extends StatefulWidget {
  final Product product;
  const PassportDetailScreen({super.key, required this.product});

  @override
  State<PassportDetailScreen> createState() => _PassportDetailScreenState();
}

class _PassportDetailScreenState extends State<PassportDetailScreen> {
  final Color forestGreen = const Color(0xFF4F6D30);
  final Color clayBrown = const Color(0xFF8D6E63);
  final Color creamBeige = const Color(0xFFE5D9C3);
  final Color softWhite = Colors.white.withOpacity(0.9);

  final TextEditingController _chatController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _showLuna = false;
  bool _isTyping = false;
  List<Map<String, String>> chatMessages = [];

  @override
  void initState() {
    super.initState();
    chatMessages.add({
      "role": "ai",
      "text": "Merhaba! Ben Luna. Bu sürdürülebilir yolculuğun detaylarını keşfetmeye hazır mısın?"
    });
  }

  Future<void> _askLuna(String userQuery) async {
    const String apiKey = "AIzaSyDdA4uoj8XlZGPp_zlGjluJ26lRrwcUJjY";
    const String url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey";

    setState(() => _isTyping = true);
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": [{"parts": [{"text": "Senin adın Luna. TracePass uygulamasının doğa dostu rehberisin. Samimi, bilgili ve sürdürülebilirlik odaklı konuş. Ürün: ${widget.product.name}. Malzeme: ${widget.product.material}. Soru: $userQuery"}]}]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String aiResponse = data['candidates'][0]['content']['parts'][0]['text'];
        setState(() {
          chatMessages.add({"role": "ai", "text": aiResponse.trim()});
        });
      }
    } finally {
      setState(() => _isTyping = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: creamBeige,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: forestGreen,
        foregroundColor: Colors.white,
        title: Text(widget.product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: const Icon(Icons.file_download_outlined), onPressed: _generatePdf),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildEcoHeader(),

            Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                children: [
                  _buildLunaSection(),
                  const SizedBox(height: 25),

                  _buildJourneyMap(),
                  const SizedBox(height: 25),

                  _buildDetailCard("Malzeme İçeriği", [
                    _detailRow("Ana Kumaş", widget.product.material),
                    _detailRow("Sertifika", "GOTS Organic"),
                  ]),
                  const SizedBox(height: 15),
                  
                  _buildDetailCard("Fiyat Şeffaflığı", [
                    _detailRow("Ham Madde", "%25"),
                    _detailRow("İşçilik", "%20"),
                    _detailRow("TracePass Puanı", "+${widget.product.ecoScore}"),
                  ]),
                  const SizedBox(height: 30),

                  _buildBlockchainStatus(),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildEcoHeader() {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: forestGreen,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Eco-Score", style: TextStyle(color: Colors.white70, fontSize: 14)),
              Text("%${widget.product.ecoScore}", style: const TextStyle(color: Colors.white, fontSize: 42, fontWeight: FontWeight.bold)),
            ],
          ),
          const Icon(Icons.eco, color: Colors.white54, size: 60),
        ],
      ),
    );
  }

  Widget _buildLunaSection() {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: ExpansionTile(
        leading: Icon(Icons.auto_awesome, color: forestGreen),
        title: const Text("Luna'ya Sor", style: TextStyle(fontWeight: FontWeight.bold)),
        children: [
          Container(
            height: 200,
            padding: const EdgeInsets.all(15),
            child: ListView.builder(
              controller: _scrollController,
              itemCount: chatMessages.length,
              itemBuilder: (context, index) => Text(
                "${chatMessages[index]['role'] == 'ai' ? 'Luna: ' : 'Siz: '}${chatMessages[index]['text']}",
                style: TextStyle(color: chatMessages[index]['role'] == 'ai' ? forestGreen : clayBrown, height: 1.5),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: _chatController,
              decoration: InputDecoration(
                hintText: "Bu ürün nasıl üretildi?",
                suffixIcon: IconButton(icon: const Icon(Icons.send), onPressed: () {
                  _askLuna(_chatController.text);
                  _chatController.clear();
                }),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJourneyMap() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: clayBrown.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          const Text("ÜRETİM ROTASI", style: TextStyle(letterSpacing: 1, fontWeight: FontWeight.bold, fontSize: 12)),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _step("Hasat"),
              const Icon(Icons.arrow_forward, size: 16, color: Colors.grey),
              _step("Üretim"),
              const Icon(Icons.arrow_forward, size: 16, color: Colors.grey),
              _step("Sizde"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard(String title, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: forestGreen, fontWeight: FontWeight.bold)),
          const Divider(),
          ...children,
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(label), Text(value, style: const TextStyle(fontWeight: FontWeight.bold))]),
  );

  Widget _buildBlockchainStatus() {
    return Shimmer.fromColors(
      baseColor: forestGreen,
      highlightColor: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.verified_user, size: 18),
          SizedBox(width: 10),
          Text("Blockchain ile Doğrulanmıştır", style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Future<void> _generatePdf() async {
    final pdf = pw.Document();
    pdf.addPage(pw.Page(build: (pw.Context context) => pw.Center(child: pw.Text("TracePass Passport: ${widget.product.name}"))));
    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  Widget _step(String t) => Column(children: [const Icon(Icons.circle, size: 10), Text(t, style: const TextStyle(fontSize: 10))]);
}