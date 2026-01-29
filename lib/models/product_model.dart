class Product {
  final String id;
  final String name;
  final String material;
  final String carbon;
  final double ecoScore;
  final String location;
  final List<dynamic> history;

  Product({
    required this.id,
    required this.name,
    required this.material,
    required this.carbon,
    required this.ecoScore,
    required this.location,
    this.history = const [],
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      material: json['material'] ?? '',
      carbon: json['carbon'] ?? '',
      ecoScore: (json['ecoScore'] ?? 0).toDouble(),
      location: json['location'] ?? '',
      history: json['history'] ?? [],
    );
  }
}