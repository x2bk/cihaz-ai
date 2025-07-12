class DeepSeekService {
  static Future<String> getDiagnosis(String input) async {
    // API çağrısı yerine sahte veri döndür
    await Future.delayed(const Duration(seconds: 1));
    return '''
- Olası sorunlar ve nedenleri
Cihazınızda güç kaynağı problemi, yazılım hatası veya donanım arızası olabilir.

- Aciliyet seviyesi (Düşük/Orta/Yüksek)
Orta

- Önerilen çözümler
Cihazı yeniden başlatın, güncellemeleri kontrol edin, gerekirse teknik servise başvurun.

- Tahmini maliyet aralığı
500₺ - 3.000₺

- Güvenlik uyarıları (varsa)
Verilerinizi yedekleyin, sıvı teması varsa cihazı kullanmayın.

- Önerilen servisler (yakınınızdaki)
En yakın yetkili teknik servis: Örnek Elektronik Servis
''';
  }
}
