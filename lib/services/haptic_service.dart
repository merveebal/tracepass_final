import 'package:vibration/vibration.dart';

class HapticService {
  // Başarılı tarama bildirimi
  static Future<void> lightImpact() async {
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 50, amplitude: 64);
    }
  }

  // Sertifika kazanma bildirimi
  static Future<void> successNotification() async {
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(pattern: [0, 100, 50, 100]);
    }
  }

  static Future<void> errorFeedback() async {
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 400);
    }
  }
}