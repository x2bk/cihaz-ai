class SettingsService {
  static const String _languageKey = 'language';
  static const String _themeKey = 'theme';
  static const String _subscriptionTypeKey = 'subscription_type';

  // Theme change callback
  static Function(String)? onThemeChanged;

  // Dil ayarlarını getir
  static Future<String> getLanguage() async {
    return 'tr'; // Geçici olarak sabit değer
  }

  // Dil ayarlarını kaydet
  static Future<void> setLanguage(String language) async {
    // Geçici olarak hiçbir şey yapma
  }

  // Tema ayarlarını getir
  static Future<String> getTheme() async {
    return 'system'; // Geçici olarak sabit değer
  }

  // Tema ayarlarını kaydet
  static Future<void> setTheme(String theme) async {
    // Geçici olarak hiçbir şey yapma
    
    // Tema değişikliği callback'ini çağır
    if (onThemeChanged != null) {
      onThemeChanged!(theme);
    }
  }

  // Abonelik türünü getir
  static Future<String> getSubscriptionType() async {
    return 'free'; // Geçici olarak sabit değer
  }

  // Abonelik türünü kaydet
  static Future<void> setSubscriptionType(String subscriptionType) async {
    // Geçici olarak hiçbir şey yapma
  }

  // Mevcut dil seçenekleri
  static List<Map<String, String>> getLanguageOptions() {
    return [
      {'code': 'tr', 'name': 'Türkçe', 'native': 'Türkçe'},
      {'code': 'en', 'name': 'English', 'native': 'English'},
      {'code': 'de', 'name': 'Deutsch', 'native': 'Deutsch'},
      {'code': 'fr', 'name': 'Français', 'native': 'Français'},
      {'code': 'es', 'name': 'Español', 'native': 'Español'},
    ];
  }

  // Mevcut tema seçenekleri
  static List<Map<String, String>> getThemeOptions() {
    return [
      {'code': 'dark', 'name': 'Koyu Tema', 'icon': '🌙'},
      {'code': 'light', 'name': 'Açık Tema', 'icon': '☀️'},
      {'code': 'system', 'name': 'Sistem', 'icon': '⚙️'},
    ];
  }

  // Mevcut abonelik türleri
  static List<Map<String, dynamic>> getSubscriptionOptions() {
    return [
      {
        'code': 'free',
        'name': 'Ücretsiz',
        'description': 'Temel özellikler',
        'price': '0₺',
        'features': ['Günlük 5 teşhis', 'Temel araç desteği', 'Reklamlar']
      },
      {
        'code': 'premium',
        'name': 'Premium',
        'description': 'Gelişmiş özellikler',
        'price': '29.99₺/ay',
        'features': ['Sınırsız teşhis', 'Gelişmiş AI', 'Reklamsız', 'Öncelikli destek']
      },
      {
        'code': 'pro',
        'name': 'Pro',
        'description': 'Profesyonel kullanım',
        'price': '99.99₺/ay',
        'features': ['Tüm Premium özellikler', 'API erişimi', 'Özel destek', 'Gelişmiş raporlar']
      },
    ];
  }
} 