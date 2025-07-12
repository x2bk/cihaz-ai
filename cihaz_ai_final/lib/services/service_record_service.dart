import '../models/service_record.dart';

class ServiceRecordService {
  static const String _serviceRecordsKey = 'service_records';

  static Future<List<ServiceRecord>> getRecordsForDevice(String deviceId) async {
    return []; // Geçici olarak boş liste
  }

  static Future<void> addRecord(ServiceRecord record) async {
    // Geçici olarak hiçbir şey yapma
  }

  static Future<List<ServiceRecord>> getAllRecords() async {
    return []; // Geçici olarak boş liste
  }

  static Future<void> deleteRecord(String id) async {
    // Geçici olarak hiçbir şey yapma
  }
} 