import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  static const String _groqApiKey = "";

  Future<Map<String, dynamic>> getAirQuality(double lat, double lon) async {
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
              "content": "Sen bir ekoloji uzmanısın. Sana verilen koordinatlar için (İstanbul/Türkiye varsayarak) gerçekçi bir hava kalitesi durumu ve tavsiyesi üret. SADECE şu JSON formatında cevap ver: {'status': 'Hava temiz/Kirli vb.', 'aqi': 1-5 arası sayı, 'tip': 'Kısa tavsiye'}"
            },
            {
              "role": "user",
              "content": "Koordinatlar: $lat, $lon. Bugün hava nasıl görünüyor?"
            }
          ],
          "response_format": {"type": "json_object"}
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final String content = data['choices'][0]['message']['content'];
        return jsonDecode(content);
      } else {
        return {"status": "Veri alınamadı", "aqi": 3, "tip": "Lütfen internetini kontrol et."};
      }
    } catch (e) {
      return {"status": "Bağlantı Hatası", "aqi": 3, "tip": "Hava durumu şu an belirsiz."};
    }
  }
}