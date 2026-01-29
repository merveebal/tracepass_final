import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/haptic_service.dart';
import '../services/api_service.dart';
import '../main.dart';

class AIDetectiveScreen extends StatefulWidget {
  const AIDetectiveScreen({super.key});

  @override
  State<AIDetectiveScreen> createState() => _AIDetectiveScreenState();
}

class _AIDetectiveScreenState extends State<AIDetectiveScreen> {
  File? _image;
  bool _isAnalyzing = false;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _isAnalyzing = true;
      });

      HapticService.lightImpact();

      try {
        final result = await ApiService().analyzeWithAI(_image!);
        
        if (mounted) {
          setState(() {
            _isAnalyzing = false;
            HomePage.scanCount++;
            HomePage.totalPoints += (result['ecoScore'] as int? ?? 0);
          });
          
          _showResultSheet(result);
        }
      } catch (e) {
        debugPrint("AI Hatası: $e");
        setState(() => _isAnalyzing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("AI ürünü tanıyamadı, lütfen tekrar dene.")),
        );
      }
    }
  }

  void _showResultSheet(Map<String, dynamic> data) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.auto_awesome, color: Colors.amber, size: 60),
            const SizedBox(height: 15),
            Text(
              data['name'] ?? "Bilinmeyen Ürün",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Chip(
              label: Text(data['material'] ?? "Belirlenemedi"),
              backgroundColor: Colors.green.withOpacity(0.1),
            ),
            const SizedBox(height: 15),
            Text(
              "Sürdürülebilirlik Puanı: ${data['ecoScore']}",
              style: const TextStyle(
                fontSize: 18, 
                fontWeight: FontWeight.bold, 
                color: Color(0xFF4F6D30)
              ),
            ),
            const SizedBox(height: 10),
            Text(
              data['recommendation'] ?? "Bu ürün için geri dönüşüm tavsiyesi bulunamadı.",
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4F6D30),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: const Text("Koleksiyonuma Ekle", style: TextStyle(fontSize: 16)),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Yeşil Dedektif'),
        backgroundColor: const Color(0xFF4F6D30),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_image != null)
              Container(
                width: 250,
                height: 250,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 2)
                  ],
                  image: DecorationImage(image: FileImage(_image!), fit: BoxFit.cover),
                ),
              )
            else
              const Icon(Icons.auto_awesome, size: 100, color: Colors.amber),
            
            const SizedBox(height: 20),
            
            if (_isAnalyzing)
              Column(
                children: [
                  const CircularProgressIndicator(color: Colors.green),
                  const SizedBox(height: 15),
                  Text(
                    "AI Ürünü Analiz Ediyor...",
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green[800]),
                  ),
                ],
              )
            else
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  children: [
                    const Text(
                      "Barkodu olmayan bir ürünün fotoğrafını çekin, sürdürülebilirlik puanını yapay zeka belirlesin.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _actionButton(Icons.camera_alt, "Kamera", () => _pickImage(ImageSource.camera)),
                        _actionButton(Icons.photo_library, "Galeri", () => _pickImage(ImageSource.gallery)),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _actionButton(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 35,
              backgroundColor: const Color(0xFF4F6D30),
              child: Icon(icon, color: Colors.white, size: 30),
            ),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}