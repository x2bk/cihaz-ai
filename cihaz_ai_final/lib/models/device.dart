// Bu dosya artık device.dart olacak
class Device {
  final String id;
  final String category;
  final String brand;
  final String model;
  final int year;
  final String? plateNumber;
  final bool isDefault;
  final DateTime? warrantyEndDate;
  final String? imei;
  final String? ram;
  final String? disk;
  final String? notes;
  final List<String> attachments;
  final String? batteryHealth;
  final String? storageStatus;
  final String? cpu;

  Device({
    required this.id,
    required this.category,
    required this.brand,
    required this.model,
    required this.year,
    this.plateNumber,
    this.isDefault = false,
    this.warrantyEndDate,
    this.imei,
    this.ram,
    this.disk,
    this.notes,
    this.attachments = const [],
    this.batteryHealth,
    this.storageStatus,
    this.cpu,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'brand': brand,
      'model': model,
      'year': year,
      'plateNumber': plateNumber,
      'isDefault': isDefault,
      'warrantyEndDate': warrantyEndDate?.toIso8601String(),
      'imei': imei,
      'ram': ram,
      'disk': disk,
      'notes': notes,
      'attachments': attachments,
      'batteryHealth': batteryHealth,
      'storageStatus': storageStatus,
      'cpu': cpu,
    };
  }

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      id: json['id'],
      category: json['category'] ?? 'Cihaz',
      brand: json['brand'],
      model: json['model'],
      year: json['year'],
      plateNumber: json['plateNumber'],
      isDefault: json['isDefault'] ?? false,
      warrantyEndDate: json['warrantyEndDate'] != null ? DateTime.tryParse(json['warrantyEndDate']) : null,
      imei: json['imei'],
      ram: json['ram'],
      disk: json['disk'],
      notes: json['notes'],
      attachments: List<String>.from(json['attachments'] ?? []),
      batteryHealth: json['batteryHealth'],
      storageStatus: json['storageStatus'],
      cpu: json['cpu'],
    );
  }

  Device copyWith({
    String? id,
    String? category,
    String? brand,
    String? model,
    int? year,
    String? plateNumber,
    bool? isDefault,
    DateTime? warrantyEndDate,
    String? imei,
    String? ram,
    String? disk,
    String? notes,
    List<String>? attachments,
    String? batteryHealth,
    String? storageStatus,
    String? cpu,
  }) {
    return Device(
      id: id ?? this.id,
      category: category ?? this.category,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      year: year ?? this.year,
      plateNumber: plateNumber ?? this.plateNumber,
      isDefault: isDefault ?? this.isDefault,
      warrantyEndDate: warrantyEndDate ?? this.warrantyEndDate,
      imei: imei ?? this.imei,
      ram: ram ?? this.ram,
      disk: disk ?? this.disk,
      notes: notes ?? this.notes,
      attachments: attachments ?? this.attachments,
      batteryHealth: batteryHealth ?? this.batteryHealth,
      storageStatus: storageStatus ?? this.storageStatus,
      cpu: cpu ?? this.cpu,
    );
  }

  @override
  String toString() {
    return '$category $brand $model ($year)';
  }
}
