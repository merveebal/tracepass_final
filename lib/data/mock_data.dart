import '../models/product_model.dart';

final Map<String, Product> productDatabase = {
  "Tshirt123": Product(
    id: "Tshirt123",
    name: "Organik Pamuk Tişört",
    ecoScore: 0.85,
    carbon: "1.2 kg CO2e",
    material: "%100 Organik Pamuk",
    location: "İzmir, Türkiye",
    history: [
      {"date": "10.10.2025", "event": "Pamuk Hasadı", "place": "Aydın"},
      {"date": "15.10.2025", "event": "İplik Üretimi", "place": "Denizli"},
      {"date": "01.11.2025", "event": "Ürün Dikimi", "place": "İzmir"},
      {"date": "15.11.2025", "event": "Mağaza Teslim", "place": "İstanbul"},
    ],
  ),
};