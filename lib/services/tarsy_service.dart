class TarsyService {
  static String getTarsyImage(int scanCount, int streak) {
    // Fotoğraflarının uzantısı .jpg olduğu için isimleri buna göre güncelledim
    const String path = 'assets/images/tarsy/tarsy/'; 

    if (scanCount == 0) return '${path}tarsy_egg.png.jpg';
    if (scanCount < 5) return '${path}tarsy_hatch.png.jpg';
    
    if (streak == 0) {
      return '${path}tarsy_sad.png.jpg';
    } else if (scanCount > 20) {
      return '${path}tarsy_happy.png.jpg'; // Daha gelişmiş hali için teen eklenebilir
    } else {
      return '${path}tarsy_happy.png.jpg';
    }
  }
}