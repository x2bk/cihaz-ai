class OfflineService {
  static final Map<String, List<String>> _commonProblems = {
    'motor': [
      'Motor çalışmıyor: Akü, yakıt pompası, ateşleme sistemi veya marş motoru kontrol edilmeli',
      'Motor sarsıntılı çalışıyor: Buji, yakıt filtresi, hava filtresi veya enjektör kontrol edilmeli',
      'Motor ısınıyor: Soğutma sistemi, termostat, fan, su pompası veya radyatör kontrol edilmeli',
      'Motor sesi yapıyor: Yağ seviyesi, eksantrik, piston, supap veya timing kayışı kontrol edilmeli',
      'Motor güçsüz: Hava filtresi, yakıt filtresi, enjektör veya turbo kontrol edilmeli',
      'Motor stop ediyor: Yakıt pompası, ateşleme sistemi, hava filtresi veya enjektör kontrol edilmeli',
    ],
    'fren': [
      'Fren pedalı yumuşak: Fren hidroliği, fren balataları, fren diskleri veya fren hortumları kontrol edilmeli',
      'Fren sesi yapıyor: Fren balataları, fren diskleri veya fren kaliperleri değiştirilmeli',
      'Fren tutmuyor: Fren sistemi acil kontrol edilmeli, fren hidroliği ve balatalar kontrol edilmeli',
      'Fren pedalı sert: Fren servo ünitesi veya vakum hortumu kontrol edilmeli',
      'ABS ışığı yanıyor: ABS sensörleri, ABS pompası veya fren hidroliği kontrol edilmeli',
    ],
    'elektrik': [
      'Far yanmıyor: Ampul, sigorta, kablo, far anahtarı veya far ayarı kontrol edilmeli',
      'Silecek çalışmıyor: Silecek motoru, silecek kolu, sigorta veya kablo kontrol edilmeli',
      'Klima çalışmıyor: Klima gazı, kompresör, evaporatör, kondenser veya fan kontrol edilmeli',
      'Radyo çalışmıyor: Sigorta, kablo, anten veya radyo ünitesi kontrol edilmeli',
      'Elektrikli cam çalışmıyor: Cam motoru, anahtar, sigorta veya kablo kontrol edilmeli',
      'Akü boşalıyor: Şarj dinamosu, akü, kablo bağlantıları veya kaçak akım kontrol edilmeli',
    ],
    'süspansiyon': [
      'Araç sallanıyor: Amortisör, yay, burç veya süspansiyon bağlantıları kontrol edilmeli',
      'Direksiyon titriyor: Lastik balansı, lastik basıncı, rot, direksiyon kutusu veya jant kontrol edilmeli',
      'Ses geliyor: Burç, rulman, süspansiyon bağlantıları veya stabilizatör kontrol edilmeli',
      'Araç bir tarafa çekiyor: Lastik basıncı, rot ayarı, fren balataları veya süspansiyon kontrol edilmeli',
      'Direksiyon boşluk yapıyor: Direksiyon kutusu, rot, direksiyon mili veya direksiyon bağlantıları kontrol edilmeli',
    ],
    'şanzıman': [
      'Vites geçmiyor: Debriyaj, şanzıman yağı, vites kutusu veya debriyaj pedalı kontrol edilmeli',
      'Vites sesi yapıyor: Şanzıman yağı, vites kutusu, debriyaj veya şanzıman bağlantıları kontrol edilmeli',
      'Otomatik vites geçmiyor: Şanzıman yağı, şanzıman filtresi, şanzıman sensörleri veya şanzıman kontrol ünitesi kontrol edilmeli',
      'Debriyaj kayıyor: Debriyaj balatası, debriyaj diski, debriyaj baskısı veya debriyaj pedalı kontrol edilmeli',
    ],
    'yakıt': [
      'Yakıt tüketimi yüksek: Hava filtresi, yakıt filtresi, enjektör, lastik basıncı veya sürüş tarzı kontrol edilmeli',
      'Yakıt kokusu geliyor: Yakıt deposu, yakıt hortumları, yakıt pompası veya enjektör kontrol edilmeli',
      'Yakıt göstergesi çalışmıyor: Yakıt seviye sensörü, gösterge paneli veya kablo kontrol edilmeli',
    ],
    'lastik': [
      'Lastik patladı: Lastik değiştirilmeli, yedek lastik kontrol edilmeli',
      'Lastik aşınıyor: Lastik rotasyonu, balans, rot ayarı veya süspansiyon kontrol edilmeli',
      'Lastik basıncı düşüyor: Lastik deliği, supap, jant veya lastik kontrol edilmeli',
    ],
    'yağ': [
      'Yağ seviyesi düşük: Yağ eklenmeli, yağ kaçağı kontrol edilmeli',
      'Yağ basıncı düşük: Yağ pompası, yağ filtresi, yağ sensörü veya motor kontrol edilmeli',
      'Yağ kaçağı var: Conta, segman, yağ tapası veya yağ hortumları kontrol edilmeli',
    ],
  };

  static String getOfflineDiagnosis(String problem) {
    final problemLower = problem.toLowerCase();

    // Anahtar kelimelere göre öneriler
    for (final entry in _commonProblems.entries) {
      if (problemLower.contains(entry.key)) {
        final suggestions = entry.value;
        return '''
🔧 **Offline Teşhis Önerisi**

📋 **Sorun:** $problem

💡 **Olası Çözümler:**
${suggestions.map((s) => '• $s').join('\n')}

🔍 **Kontrol Listesi:**
• Motor ışıkları kontrol edildi mi?
• Yağ seviyesi normal mi?
• Lastik basınçları doğru mu?
• Akü bağlantıları sağlam mı?
• Yakıt seviyesi yeterli mi?

⚠️ **Önemli Not:**
Bu öneriler genel bilgilerdir. Kesin teşhis için servise başvurun.

🚨 **Acil Durum:**
- Güvenlik riski varsa aracı kullanmayın
- Gerekirse çekici çağırın (sigorta şirketinizle iletişime geçin)
- **Tüm acil durumlar için 112'yi arayabilirsiniz**

📞 **Servis Önerileri:**
- Yetkili servise başvurun
- Detaylı diagnostik test yaptırın
- Parça değişimi için orijinal parça kullanın
        ''';
      }
    }

    // Genel öneriler
    return '''
🔧 **Offline Teşhis Önerisi**

📋 **Sorun:** $problem

💡 **Genel Kontrol Listesi:**
• Yağ seviyesi kontrol edildi mi?
• Lastik basınçları normal mi?
• Akü bağlantıları sağlam mı?
• Yakıt seviyesi yeterli mi?
• Motor ışıkları var mı?
• Soğutma suyu seviyesi normal mi?
• Fren hidroliği seviyesi normal mi?

🔍 **Önerilen Adımlar:**
1. Aracı güvenli bir yere çekin
2. Motor ışıklarını kontrol edin
3. Basit kontrolleri yapın
4. Sorunun detaylarını not edin
5. Gerekirse servise başvurun

⚠️ **Önemli Not:**
Bu öneriler genel bilgilerdir. Kesin teşhis için servise başvurun.

🚨 **Acil Durum:**
- Güvenlik riski varsa aracı kullanmayın
- Gerekirse çekici çağırın (sigorta şirketinizle iletişime geçin)
- **Tüm acil durumlar için 112'yi arayabilirsiniz**

📞 **Servis Önerileri:**
- Yetkili servise başvurun
- Detaylı diagnostik test yaptırın
- Parça değişimi için orijinal parça kullanın
    ''';
  }

  static List<String> getMaintenanceTips() {
    return [
      'Düzenli yağ değişimi yapın (her 10.000 km)',
      'Hava filtresini kontrol edin (her 15.000 km)',
      'Yakıt filtresini değiştirin (her 30.000 km)',
      'Fren balatalarını kontrol edin (her 20.000 km)',
      'Lastik rotasyonu yapın (her 10.000 km)',
      'Soğutma suyunu kontrol edin (her ay)',
      'Akü bağlantılarını temizleyin (her 6 ay)',
      'Fren hidroliğini kontrol edin (her ay)',
      'Lastik basınçlarını kontrol edin (her hafta)',
      'Motor yağ seviyesini kontrol edin (her hafta)',
    ];
  }

  static String getMaintenanceSchedule() {
    return '''
🔧 **Bakım Programı**

📅 **Günlük Kontroller:**
• Motor yağ seviyesi
• Soğutma suyu seviyesi
• Lastik basınçları
• Motor ışıkları

📅 **Haftalık Kontroller:**
• Fren hidroliği seviyesi
• Cam suyu seviyesi
• Genel temizlik

📅 **Aylık Kontroller:**
• Akü bağlantıları
• Yağ kaçakları
• Genel ses kontrolü

📅 **10.000 km:**
• Motor yağı değişimi
• Yağ filtresi değişimi
• Lastik rotasyonu

📅 **20.000 km:**
• Hava filtresi değişimi
• Fren balataları kontrolü
• Fren diskleri kontrolü

📅 **30.000 km:**
• Yakıt filtresi değişimi
• Şanzıman yağı kontrolü
• Süspansiyon kontrolü

📅 **60.000 km:**
• Timing kayışı değişimi
• Su pompası değişimi
• Termostat değişimi
    ''';
  }
}
