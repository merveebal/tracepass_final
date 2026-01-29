import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../main.dart';

class ProfileDetailScreen extends StatefulWidget {
  const ProfileDetailScreen({super.key});

  @override
  State<ProfileDetailScreen> createState() => _ProfileDetailScreenState();
}

class _ProfileDetailScreenState extends State<ProfileDetailScreen> {
  final Color forestGreen = const Color(0xFF4F6D30);
  final Color clayBrown = const Color(0xFF8D6E63);
  final Color creamBeige = const Color(0xFFE5D9C3);

  final TextEditingController _chatController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;
  List<Map<String, String>> chatMessages = [];

  @override
  void initState() {
    super.initState();
    chatMessages.add({
      "role": "ai",
      "text": "Merhaba ${TracePassApp.userDisplayName}! Profil detayların ve ekolojik verilerin hakkında soruların varsa buradayım."
    });
  }

  Future<void> _askLuna(String userQuery) async {
    const String apiKey = "AIzaSyDdA4uoj8XlZGPp_zlGjluJ26lRrwcUJjY";
    const String url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey";

    setState(() => _isTyping = true);
    setState(() {
      chatMessages.add({"role": "user", "text": userQuery});
    });

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": [{"parts": [{"text": "Sen Luna'sın. TracePass rehberisin. Kullanıcı adı: ${TracePassApp.userDisplayName}. Kullanıcı e-postası: ${TracePassApp.userEmail}. Samimi ol ve kısa cevaplar ver. Soru: $userQuery"}]}]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String aiResponse = data['candidates'][0]['content']['parts'][0]['text'];
        setState(() {
          chatMessages.add({"role": "ai", "text": aiResponse.trim()});
        });
        _scrollToBottom();
      }
    } finally {
      setState(() => _isTyping = false);
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: creamBeige,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: forestGreen,
        foregroundColor: Colors.white,
        title: const Text("Hesap Detayları", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(),
            Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                children: [
                  _buildLunaSection(),
                  const SizedBox(height: 25),
                  _buildDetailCard("Kişisel Bilgiler", [
                    _detailRow("Kullanıcı Adı", TracePassApp.userDisplayName),
                    _detailRow("E-posta", TracePassApp.userEmail),
                    _detailRow("Üyelik Tarihi", "13.01.2026"),
                  ]),
                  const SizedBox(height: 15),
                  _buildDetailCard("Blockchain Kaydı", [
                    _detailRow("Kimlik Durumu", "Onaylandı"),
                    _detailRow("Cüzdan ID", "0x71${TracePassApp.userDisplayName.length}X...2F4"),
                  ]),
                  const SizedBox(height: 30),
                  _buildBlockchainStatus(),
                  const SizedBox(height: 20),
                  _buildActionButtons(),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 20, bottom: 40),
      decoration: BoxDecoration(color: forestGreen, borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30))),
      child: Column(
        children: [
          const CircleAvatar(radius: 45, backgroundColor: Colors.white24, child: Icon(Icons.person, size: 45, color: Colors.white)),
          const SizedBox(height: 15),
          Text(TracePassApp.userDisplayName, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
          Text("Premium Üye", style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildLunaSection() {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: ExpansionTile(
        leading: Icon(Icons.auto_awesome, color: forestGreen),
        title: const Text("Luna'ya Sor", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        children: [
          Container(
            height: 180,
            padding: const EdgeInsets.all(15),
            child: ListView.builder(
              controller: _scrollController,
              itemCount: chatMessages.length,
              itemBuilder: (context, index) {
                bool isAi = chatMessages[index]['role'] == 'ai';
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    "${isAi ? 'Luna: ' : 'Siz: '}${chatMessages[index]['text']}",
                    style: TextStyle(
                      color: isAi ? forestGreen : Colors.black87,
                      fontWeight: isAi ? FontWeight.bold : FontWeight.normal,
                      fontSize: 13,
                    ),
                  ),
                );
              },
            ),
          ),
          if (_isTyping) const Padding(padding: EdgeInsets.all(8.0), child: LinearProgressIndicator()),
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: _chatController,
              decoration: InputDecoration(
                hintText: "Verilerimi analiz et...",
                suffixIcon: IconButton(icon: const Icon(Icons.send), onPressed: () {
                  if (_chatController.text.isNotEmpty) {
                    _askLuna(_chatController.text);
                    _chatController.clear();
                  }
                }),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard(String title, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: TextStyle(color: forestGreen, fontWeight: FontWeight.bold)),
        const Divider(),
        ...children,
      ]),
    );
  }

  Widget _detailRow(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)), Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13))]),
  );

  Widget _buildBlockchainStatus() {
    return Shimmer.fromColors(
      baseColor: forestGreen,
      highlightColor: Colors.white,
      child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.verified_user, size: 16),
        SizedBox(width: 8),
        Text("Kimlik Blockchain ile Korunuyor", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
      ]),
    );
  }

  Widget _buildActionButtons() {
    return Column(children: [
      ElevatedButton(
        onPressed: _generateProfilePdf,
        style: ElevatedButton.styleFrom(backgroundColor: clayBrown, foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
        child: const Text("DİJİTAL KİMLİĞİ İNDİR"),
      ),
    ]);
  }

  Future<void> _generateProfilePdf() async {
    final pdf = pw.Document();
    pdf.addPage(pw.Page(build: (pw.Context context) => pw.Center(child: pw.Text("TracePass User: ${TracePassApp.userDisplayName}"))));
    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }
}