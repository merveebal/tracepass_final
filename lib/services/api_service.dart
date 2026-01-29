import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';
import '../main.dart'; 

class ApiService {
  final Map<String, dynamic> _localDatabase = {
    "8690504018751": {
      "id": "8690504018751", "name": "Erikli Su 0.5L", "material": "Plastik (PET)",
      "ecoScore": 45, "description": "Geri dönüştürülebilir plastik şişe.", "origin": "Türkiye"
    },
    "8699015750127": {
      "id": "8699015750127", "name": "Abant Su 0.5L", "material": "Plastik (PET)",
      "ecoScore": 48, "description": "Doğal kaynak suyu.", "origin": "Türkiye (Bolu)"
    },
    "8681212063520": {
      "id": "8681212063520", "name": "Sleepy Islak Bebek Havlusu", "material": "Plastik & Fiber",
      "ecoScore": 35, "description": "Ambalajı geri dönüştürülebilir.", "origin": "Türkiye"
    },
  };

  static const String apiUrl = "https://69612491e7aa517cb7982b8c.mockapi.io/api/v1/products";
  
  static const String _groqApiKey = "";
  
  Future<Product?> getProduct(String qrCode) async {
    try {
      if (_localDatabase.containsKey(qrCode)) {
        return Product.fromJson(_localDatabase[qrCode]);
      }
      final response = await http.get(Uri.parse('$apiUrl/$qrCode'));
      if (response.statusCode == 200) {
        return Product.fromJson(json.decode(response.body));
      } 
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<String> askLuna(String userQuery) async {
    const String url = "https://api.groq.com/openai/v1/chat/completions";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $_groqApiKey',
        },
        body: jsonEncode({
          "model": "llama-3.3-70b-versatile",
          "messages": [
            {
              "role": "system", 
              "content": "Sen TracePass rehberi LUNA'sın. Kullanıcının adı: ${TracePassApp.userDisplayName}. Sürdürülebilirlik, geri dönüşüm ve doğa dostu yaşam konusunda uzman, samimi ve zeki bir asistansın. Cevapların kısa, etkileyici ve insancıl olsun."
            },
            {"role": "user", "content": userQuery}
          ],
          "temperature": 0.7,
          "max_tokens": 500
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return data['choices'][0]['message']['content'].toString().trim();
      } else {
        return "Luna şu an dinleniyor (Hata kodu: ${response.statusCode})";
      }
    } catch (e) {
      return "Bağlantı sorunu yaşanıyor.";
    }
  }

  Future<String> getZeroWasteRecipe(List<String> ingredients) async {
    const String url = "https://api.groq.com/openai/v1/chat/completions";
    String ingredientList = ingredients.join(", ");

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $_groqApiKey',
        },
        body: jsonEncode({
          "model": "llama-3.3-70b-versatile",
          "messages": [
            {
              "role": "system", 
              "content": "Sen bir Sıfır Atık Şefisin. Kullanıcının elinde kalan malzemelerle israfı önleyecek yaratıcı, pratik ve çevreci yemek tarifleri verirsin. Tariflerin kısa, adım adım ve iştah açıcı olsun."
            },
            {"role": "user", "content": "Elimde şu malzemeler var: $ingredientList. Bunlarla israfı önleyecek ne yapabilirim?"}
          ],
          "temperature": 0.7
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return data['choices'][0]['message']['content'].toString().trim();
      } else {
        return "Şef Luna şu an mutfakta değil, sonra tekrar dene!";
      }
    } catch (e) {
      return "Bağlantı hatası: Mutfak robotu bozuldu!";
    }
  }

  Future<Map<String, dynamic>> analyzeWithAI(File imageFile) async {
    return {
      "name": "Ürün Tanıma Sistemi",
      "material": "Analiz ediliyor...",
      "ecoScore": 70,
      "recommendation": "Lütfen barkod okutmayı deneyin veya Luna'ya fotoğrafı anlatın."
    };
  }
}