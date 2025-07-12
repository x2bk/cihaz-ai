class DeviceHealth {
  final int batteryHealth; // 0-100 arası yüzde
  final int storageUsed; // GB cinsinden kullanılan alan
  final int storageTotal; // GB cinsinden toplam alan
  final int systemPerformance; // 0-100 arası performans skoru
  final String lastCheckDate; // Son kontrol tarihi
  final List<String> recommendations; // Öneriler listesi

  DeviceHealth({
    required this.batteryHealth,
    required this.storageUsed,
    required this.storageTotal,
    required this.systemPerformance,
    required this.lastCheckDate,
    this.recommendations = const [],
  });

  double get storagePercentage => (storageUsed / storageTotal) * 100;

  String get batteryHealthStatus {
    if (batteryHealth >= 80) return 'Mükemmel';
    if (batteryHealth >= 60) return 'İyi';
    if (batteryHealth >= 40) return 'Orta';
    return 'Kritik';
  }

  String get storageStatus {
    if (storagePercentage >= 90) return 'Kritik';
    if (storagePercentage >= 80) return 'Dikkat';
    if (storagePercentage >= 60) return 'Orta';
    return 'İyi';
  }

  String get performanceStatus {
    if (systemPerformance >= 80) return 'Mükemmel';
    if (systemPerformance >= 60) return 'İyi';
    if (systemPerformance >= 40) return 'Orta';
    return 'Yavaş';
  }

  Map<String, dynamic> toJson() {
    return {
      'batteryHealth': batteryHealth,
      'storageUsed': storageUsed,
      'storageTotal': storageTotal,
      'systemPerformance': systemPerformance,
      'lastCheckDate': lastCheckDate,
      'recommendations': recommendations,
    };
  }

  factory DeviceHealth.fromJson(Map<String, dynamic> json) {
    return DeviceHealth(
      batteryHealth: json['batteryHealth'] ?? 0,
      storageUsed: json['storageUsed'] ?? 0,
      storageTotal: json['storageTotal'] ?? 0,
      systemPerformance: json['systemPerformance'] ?? 0,
      lastCheckDate: json['lastCheckDate'] ?? '',
      recommendations: List<String>.from(json['recommendations'] ?? []),
    );
  }

  // Simüle edilmiş sağlık durumu oluştur
  factory DeviceHealth.generateMock() {
    final random = DateTime.now().millisecondsSinceEpoch % 100;
    final batteryHealth = 60 + (random % 40); // 60-100 arası
    final storageUsed = 50 + (random % 100); // 50-150 GB
    final storageTotal = 256; // 256 GB
    final systemPerformance = 70 + (random % 30); // 70-100 arası
    
    final recommendations = <String>[];
    if (batteryHealth < 80) {
      recommendations.add('Batarya sağlığınızı korumak için düzenli şarj edin');
    }
    if ((storageUsed / storageTotal) > 0.8) {
      recommendations.add('Depolama alanınızı temizleyin');
    }
    if (systemPerformance < 80) {
      recommendations.add('Gereksiz uygulamaları kapatın');
    }

    return DeviceHealth(
      batteryHealth: batteryHealth,
      storageUsed: storageUsed,
      storageTotal: storageTotal,
      systemPerformance: systemPerformance,
      lastCheckDate: DateTime.now().toString().split(' ')[0],
      recommendations: recommendations,
    );
  }
} 