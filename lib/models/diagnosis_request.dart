class DiagnosisRequest {
  final String id;
  final String brand;
  final String model;
  final String year;
  final String problem;
  final DateTime createdAt;

  DiagnosisRequest({
    required this.id,
    required this.brand,
    required this.model,
    required this.year,
    required this.problem,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'brand': brand,
      'model': model,
      'year': year,
      'problem': problem,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory DiagnosisRequest.fromMap(Map<String, dynamic> map) {
    return DiagnosisRequest(
      id: map['id'] ?? '',
      brand: map['brand'] ?? '',
      model: map['model'] ?? '',
      year: map['year'] ?? '',
      problem: map['problem'] ?? '',
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : null,
    );
  }
}
