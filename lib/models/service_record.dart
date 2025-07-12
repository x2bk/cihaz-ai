class ServiceRecord {
  final String id;
  final String deviceId;
  final DateTime date;
  final String description;
  final String? serviceCenter;
  final bool isAppointment;

  ServiceRecord({
    required this.id,
    required this.deviceId,
    required this.date,
    required this.description,
    this.serviceCenter,
    this.isAppointment = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'deviceId': deviceId,
      'date': date.toIso8601String(),
      'description': description,
      'serviceCenter': serviceCenter,
      'isAppointment': isAppointment,
    };
  }

  factory ServiceRecord.fromJson(Map<String, dynamic> json) {
    return ServiceRecord(
      id: json['id'],
      deviceId: json['deviceId'],
      date: DateTime.parse(json['date']),
      description: json['description'],
      serviceCenter: json['serviceCenter'],
      isAppointment: json['isAppointment'] ?? false,
    );
  }
} 