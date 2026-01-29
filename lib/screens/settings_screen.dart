import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../main.dart'; 
import 'history_screen.dart'; 
import 'profile_detail_screen.dart'; 
import 'badges_screen.dart'; 
import 'certificates_screen.dart'; 
import 'login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  static String? profileImagePath; 

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          SettingsScreen.profileImagePath = image.path;
        });
      }
    } catch (e) {
      debugPrint("Resim seçme hatası: $e");
    }
  }

  // --- YENİ EKLEME: BİLGİLENDİRME PANELİ FONKSİYONU ---
  void _showInfoSheet(BuildContext context, String title, String content, IconData icon) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.5,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[400], borderRadius: BorderRadius.circular(10))),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                children: [
                  Icon(icon, size: 50, color: const Color(0xFF4F6D30)),
                  const SizedBox(height: 20),
                  Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF4F6D30))),
                  const SizedBox(height: 15),
                  Text(content, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, height: 1.5)),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(25),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4F6D30), foregroundColor: Colors.white),
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Anladım"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = TracePassApp.of(context).currentThemeMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayarlar'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            
            Stack(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: const Color(0xFF4F6D30),
                  backgroundImage: SettingsScreen.profileImagePath != null 
                      ? FileImage(File(SettingsScreen.profileImagePath!)) 
                      : null,
                  child: SettingsScreen.profileImagePath == null
                      ? const Icon(Icons.person, size: 60, color: Colors.white)
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color(0xFF8D6E63),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 15),
            Text(
              TracePassApp.userDisplayName,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              TracePassApp.userEmail,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),

            _buildSectionHeader("HESAP"),
            
            _buildListTile(Icons.person_outline, "Profil Bilgileri", null, onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileDetailScreen()));
            }),
            
            _buildListTile(Icons.history, "Okutma Geçmişi", null, onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => HistoryScreen(products: HomePage.recentProducts)));
            }),
            
            _buildListTile(Icons.workspace_premium, "Rozetlerim", 
              const Text("3 Yeni", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const BadgesScreen()));
              }
            ),

            _buildListTile(Icons.card_membership, "Sertifikalarım", null, onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const CertificatesScreen()));
            }),

            const SizedBox(height: 20),

            _buildSectionHeader("GÖRÜNÜM VE TEMA"),
            _buildThemeSwitcher(context, themeMode),

            const SizedBox(height: 20),

            _buildSectionHeader("HAKKINDA"),
            
            // --- GÜNCELLENEN KISIM: ONTAP FONKSİYONLARI BAĞLANDI ---
            _buildListTile(Icons.info_outline, "TracePass Nedir?", null, onTap: () {
              _showInfoSheet(
                context, 
                "TracePass Nedir?", 
                "TracePass, ürünlerin sürdürülebilirlik hikayesini şeffaf bir şekilde görmenizi sağlayan bir dijital pasaport uygulamasıdır.",
                Icons.auto_awesome
              );
            }),
            _buildListTile(Icons.security, "Blockchain ve Gizlilik", null, onTap: () {
              _showInfoSheet(
                context, 
                "Güvenli ve Şeffaf", 
                "Verileriniz blockchain teknolojisi ile korunur. Ürün geçmişi değiştirilemez, böylece her zaman doğru bilgiye erişirsiniz.",
                Icons.security
              );
            }),
            
            _buildListTile(Icons.logout, "Çıkış Yap", null, isDestructive: true, onTap: () {
              _showLogoutDialog(context);
            }),
            
            const SizedBox(height: 40),
            const Text("Versiyon 1.0.2", style: TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // --- MEVCUT HELPER METODLARIN (DEĞİŞMEDİ) ---

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Çıkış Yap"),
        content: const Text("Hesabınızdan çıkış yapmak istediğinize emin misiniz?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Vazgeç")),
          TextButton(
            onPressed: () {
              TracePassApp.userDisplayName = "Misafir Kullanıcı";
              TracePassApp.userEmail = "misafir@tracepass.com";
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
            child: const Text("Çıkış Yap", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title.toUpperCase(),
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.2),
        ),
      ),
    );
  }

  Widget _buildListTile(IconData icon, String title, Widget? trailing, {bool isDestructive = false, VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: isDestructive ? Colors.red : const Color(0xFF4F6D30)),
      title: Text(title, style: TextStyle(color: isDestructive ? Colors.red : null)),
      trailing: trailing ?? const Icon(Icons.chevron_right, size: 20),
      onTap: onTap,
    );
  }

  Widget _buildThemeSwitcher(BuildContext context, ThemeMode currentMode) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          RadioListTile<ThemeMode>(
            title: const Text("Aydınlık Mod"),
            secondary: const Icon(Icons.light_mode_outlined),
            activeColor: const Color(0xFF4F6D30),
            value: ThemeMode.light,
            groupValue: currentMode,
            onChanged: (mode) => TracePassApp.of(context).changeTheme(mode!),
          ),
          RadioListTile<ThemeMode>(
            title: const Text("Karanlık Mod"),
            secondary: const Icon(Icons.dark_mode_outlined),
            activeColor: const Color(0xFF4F6D30),
            value: ThemeMode.dark,
            groupValue: currentMode,
            onChanged: (mode) => TracePassApp.of(context).changeTheme(mode!),
          ),
          RadioListTile<ThemeMode>(
            title: const Text("Sistem Varsayılanı"),
            secondary: const Icon(Icons.settings_brightness_outlined),
            activeColor: const Color(0xFF4F6D30),
            value: ThemeMode.system,
            groupValue: currentMode,
            onChanged: (mode) => TracePassApp.of(context).changeTheme(mode!),
          ),
        ],
      ),
    );
  }
}