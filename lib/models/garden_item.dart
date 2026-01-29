class GardenItem {
  final String id;
  final String type; // 'oak', 'pine', 'flower'
  int growthLevel; // 1: Tohum, 2: Fidan, 3: Ağaç
  
  // 'final' kaldırıldı, böylece sürükleyince yeni yerini kaydedebiliyoruz
  double xPosition;
  double yPosition;

  GardenItem({
    required this.id,
    required this.type,
    this.growthLevel = 1,
    required this.xPosition,
    required this.yPosition,
  });
}