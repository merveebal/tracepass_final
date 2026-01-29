import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'services/api_service.dart';
import 'services/haptic_service.dart'; 
import 'services/weather_service.dart'; 
import 'services/database_service.dart'; 
import 'screens/passport_detail_screen.dart';
import 'screens/settings_screen.dart'; 
import 'screens/splash_screen.dart'; 
import 'screens/collection_screen.dart'; 
import 'screens/ai_detective_screen.dart'; 
import 'screens/garden_screen.dart';
import 'screens/login_screen.dart'; 
import 'widgets/edu_cards.dart';
import 'models/product_model.dart'; 
import 'models/garden_item.dart';
import 'widgets/impact_dashboard.dart';

void main() {
  runApp(const TracePassApp());
}

class TracePassApp extends StatefulWidget {
  const TracePassApp({super.key});

  static String userDisplayName = "Misafir Kullanıcı";
  static String userEmail = "misafir@tracepass.com";
  static String userPassword = ""; 

  static _TracePassAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_TracePassAppState>()!;

  @override
  State<TracePassApp> createState() => _TracePassAppState();
}

class _TracePassAppState extends State<TracePassApp> {
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get currentThemeMode => _themeMode;

  void changeTheme(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TracePass',
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF4F6D30),
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFE5D9C3),
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: const Color(0xFF4F6D30),
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
      ),
      themeMode: _themeMode,
      home: const SplashScreen(), 
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static int scanCount = 0;
  static int totalPoints = 0;
  static List<Product> recentProducts = [];
  static List<GardenItem> myGardenData = []; 

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _lunaController = TextEditingController();
  final TextEditingController _fridgeController = TextEditingController(); 
  final ScrollController _chatScrollController = ScrollController();
  bool _isLunaLoading = false;

  static final List<Map<String, dynamic>> _messages = [
    {"isUser": false, "text": "Merhaba! Ben Luna. Sürdürülebilirlik yolculuğunda sana rehberlik etmek için buradayım. Bana her şeyi sorabilirsin!"}
  ];

  @override
  void initState() {
    super.initState();
    _loadDatabaseData(); 
  }

  // Tarsy'nin hangi durumda nasıl görüneceğini belirleyen mantık
  String _getTarsyImage() {
    const String path = 'assets/images/tarsy/tarsy/';
    
    // 1. Hiç ürün okutulmadıysa: Yumurta
    if (HomePage.scanCount == 0) return '${path}tarsy_egg.png.jpg';
    
    // 2. İlk adımlar: Çatlama (Örn: 1-5 arası)
    if (HomePage.scanCount > 0 && HomePage.scanCount <= 5) return '${path}tarsy_hatch.png.jpg';
    
    // 3. İleri Seviye (Örn: 20+): Genç Ejderha
    if (HomePage.scanCount > 20) return '${path}tarsy_teen.png.jpg';

    // 4. Varsayılan: Mutlu Bebek
    return '${path}tarsy_happy.png.jpg';
  }

  Future<void> _loadDatabaseData() async {
    final List<Map<String, dynamic>> productsData = await DatabaseService.instance.fetchProducts();
    
    setState(() {
      HomePage.recentProducts = productsData.map((item) => Product(
        id: item['id'].toString(), 
        name: item['name'] ?? "Bilinmeyen Ürün",
        ecoScore: (item['ecoScore'] as num? ?? 0.0).toDouble(),
        material: item['material'] ?? "Geri Dönüştürülebilir", 
        carbon: (item['carbon'] as num? ?? 0.0).toString(), 
        location: item['location'] ?? "Konum Bilgisi Yok",
      )).toList().cast<Product>(); 
      
      HomePage.scanCount = HomePage.recentProducts.length;
      HomePage.totalPoints = HomePage.recentProducts.fold(0, (sum, p) => sum + p.ecoScore.toInt());
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_chatScrollController.hasClients) {
        _chatScrollController.animateTo(
          _chatScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showFridgeAnalyzer() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        title: const Row(
          children: [Icon(Icons.kitchen, color: Colors.cyan), SizedBox(width: 10), Text("Sıfır Atık Mutfağı")],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Dolapta kalan malzemeleri yaz, Luna sana israfı önleyecek bir tarif versin!"),
            const SizedBox(height: 15),
            TextField(
              controller: _fridgeController,
              decoration: InputDecoration(
                hintText: "Örn: Domates, bayat ekmek, peynir...",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Vazgeç")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4F6D30), foregroundColor: Colors.white),
            onPressed: () async {
              String ingredients = _fridgeController.text;
              if (ingredients.isEmpty) return;
              Navigator.pop(context);
              _showLunaChat();
              setState(() => _isLunaLoading = true);
              final recipe = await ApiService().getZeroWasteRecipe(ingredients.split(','));
              setState(() {
                _messages.add({"isUser": true, "text": "Elimde şunlar var: $ingredients"});
                _messages.add({"isUser": false, "text": recipe});
                _isLunaLoading = false;
                _fridgeController.clear();
              });
              _scrollToBottom();
            },
            child: const Text("Tarif Al"),
          ),
        ],
      ),
    );
  }

  void _showLunaChat() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[400], borderRadius: BorderRadius.circular(10))),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    const CircleAvatar(backgroundColor: Color(0xFF4F6D30), child: Icon(Icons.auto_awesome, color: Colors.white, size: 20)),
                    const SizedBox(width: 15),
                    const Text("Luna AI Asistan", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const Spacer(),
                    IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView.builder(
                  controller: _chatScrollController,
                  padding: const EdgeInsets.all(20),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final msg = _messages[index];
                    bool isUser = msg["isUser"];
                    return Align(
                      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                        decoration: BoxDecoration(
                          color: isUser ? const Color(0xFF4F6D30) : Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(20),
                            topRight: const Radius.circular(20),
                            bottomLeft: Radius.circular(isUser ? 20 : 0),
                            bottomRight: Radius.circular(isUser ? 0 : 20),
                          ),
                          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
                        ),
                        child: Text(
                          msg["text"],
                          style: TextStyle(color: isUser ? Colors.white : Colors.black87, fontSize: 14),
                        ),
                      ),
                    );
                  },
                ),
              ),
              if (_isLunaLoading) const LinearProgressIndicator(color: Color(0xFF4F6D30), backgroundColor: Colors.transparent),
              Container(
                padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: MediaQuery.of(context).viewInsets.bottom + 20),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _lunaController,
                        decoration: InputDecoration(
                          hintText: "Luna'ya sor...",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: BorderSide.none),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    CircleAvatar(
                      backgroundColor: const Color(0xFF4F6D30),
                      child: IconButton(
                        icon: const Icon(Icons.send, color: Colors.white, size: 20),
                        onPressed: () async {
                          if (_lunaController.text.trim().isEmpty) return;
                          String query = _lunaController.text;
                          setModalState(() {
                            _messages.add({"isUser": true, "text": query});
                            _isLunaLoading = true;
                          });
                          _lunaController.clear();
                          _scrollToBottom();
                          final response = await ApiService().askLuna(query);
                          setModalState(() {
                            _messages.add({"isUser": false, "text": response});
                            _isLunaLoading = false;
                          });
                          _scrollToBottom();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    const Color forestGreen = Color(0xFF4F6D30);
    const Color clayBrown = Color(0xFF8D6E63);
    final Color textColor = isDark ? Colors.white : forestGreen;

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 100.0), 
        child: FloatingActionButton(
          mini: true,
          backgroundColor: forestGreen,
          onPressed: _showLunaChat,
          child: const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('TracePass', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: textColor, letterSpacing: -1)),
                          Text("Hoş geldin, ${TracePassApp.userDisplayName.split(' ')[0]}!", style: TextStyle(fontSize: 12, color: textColor.withOpacity(0.7))),
                        ],
                      ),
                    ),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 4,
                      children: [
                        IconButton(onPressed: _showFridgeAnalyzer, icon: const Icon(Icons.kitchen, color: Colors.cyan)), 
                        IconButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const GardenScreen())), icon: const Icon(Icons.yard_outlined, color: Colors.green)),
                        IconButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AIDetectiveScreen())), icon: const Icon(Icons.camera_alt_outlined, color: Colors.orangeAccent)), 
                        IconButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CollectionScreen())), icon: const Icon(Icons.inventory_2_outlined, color: forestGreen)),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen())),
                          child: CircleAvatar(
                            radius: 18,
                            backgroundColor: forestGreen,
                            backgroundImage: SettingsScreen.profileImagePath != null ? FileImage(File(SettingsScreen.profileImagePath!)) : null,
                            child: SettingsScreen.profileImagePath == null ? const Icon(Icons.person, color: Colors.white, size: 18) : null,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              FutureBuilder<Map<String, dynamic>>(
                future: WeatherService().getAirQuality(41.0082, 28.9784),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final status = snapshot.data!['status'] ?? "Bilinmiyor";
                    final aqi = snapshot.data!['aqi'] ?? 0;
                    return _buildWeatherCard(status, aqi <= 2 ? Colors.blue : Colors.orange, textColor);
                  }
                  return _buildWeatherCard("Hava durumu hazırlanıyor...", forestGreen.withOpacity(0.5), textColor);
                },
              ),
              const Padding(padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10), child: Text('Sürdürülebilir İpuçları', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
              EduCards(), 
              const SizedBox(height: 20),
              
              // --- 🐉 TARSY BURADA BAŞLIYOR ---
              Center(
                child: Column(
                  children: [
                    Image.asset(
                      _getTarsyImage(),
                      height: 160,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.pets, size: 100, color: Colors.grey),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: forestGreen.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        HomePage.scanCount == 0 ? "Tarsy uyanmak için seni bekliyor!" : "Tarsy seninle büyüyor!",
                        style: const TextStyle(fontWeight: FontWeight.bold, color: forestGreen),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              // --- 🐉 TARSY BURADA BİTTİ ---

              ImpactDashboard(
                totalScans: HomePage.scanCount, 
                totalPoints: HomePage.totalPoints, 
                savedCO2: HomePage.scanCount * 0.3
              ),
              const SizedBox(height: 20),
              if (HomePage.recentProducts.isNotEmpty) ...[
                const Padding(padding: EdgeInsets.symmetric(horizontal: 25), child: Text('Son Okutulanlar', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: HomePage.recentProducts.length > 3 ? 3 : HomePage.recentProducts.length,
                  itemBuilder: (context, index) {
                    final p = HomePage.recentProducts.reversed.toList()[index];
                    return ListTile(
                      title: Text(p.name),
                      leading: const Icon(Icons.history, color: Colors.grey),
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PassportDetailScreen(product: p))),
                    );
                  },
                ),
              ],
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: SizedBox(
                  width: double.infinity,
                  height: 65,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => const ScannerPage()));
                      if (result != null && result is Product) {
                        await DatabaseService.instance.addProduct(result.name, result.ecoScore);
                        
                        setState(() {
                          HomePage.scanCount++;
                          HomePage.totalPoints += result.ecoScore.toInt();
                          HomePage.recentProducts.add(result);
                        });
                      }
                    },
                    icon: const Icon(Icons.qr_code_scanner),
                    label: const Text('ÜRÜNÜ KEŞFET', style: TextStyle(fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(backgroundColor: clayBrown, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                  ),
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherCard(String status, Color cardColor, Color textColor) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: cardColor.withOpacity(0.1), borderRadius: BorderRadius.circular(20), border: Border.all(color: cardColor.withOpacity(0.3))),
      child: Row(children: [Icon(Icons.air, color: cardColor), const SizedBox(width: 15), Text(status, style: TextStyle(color: cardColor, fontWeight: FontWeight.bold))]),
    );
  }
}

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});
  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  MobileScannerController controller = MobileScannerController();
  bool isScanning = false;

  @override
  void dispose() {
    controller.dispose(); 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ürün Kodunu Okutun'), backgroundColor: const Color(0xFF4F6D30), foregroundColor: Colors.white),
      body: Stack(
        children: [
          MobileScanner(
            controller: controller,
            onDetect: (capture) async {
              if (isScanning) return;
              final code = capture.barcodes.first.rawValue;
              if (code != null) {
                setState(() => isScanning = true);
                await controller.stop(); 
                
                final product = await ApiService().getProduct(code);
                if (mounted) {
                  if (product != null) {
                    Navigator.pop(context, product);
                  } else {
                    setState(() => isScanning = false);
                    await controller.start(); 
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ürün bulunamadı!')));
                  }
                }
              }
            },
          ),
          if (isScanning) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}