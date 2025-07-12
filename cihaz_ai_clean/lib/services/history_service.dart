import '../models/diagnosis_request.dart';

class HistoryService {
  static const _historyKey = 'diagnosis_history';

  static Future<void> saveDiagnosis(DiagnosisRequest request) async {
    // Geçici olarak hiçbir şey yapma
  }

  static Future<List<DiagnosisRequest>> getHistory() async {
    return []; // Geçici olarak boş liste
  }

  static Future<void> addToHistory(DiagnosisRequest request) async {
    // Geçici olarak hiçbir şey yapma
  }

  static Future<List<DiagnosisRequest>> getAllRecords() async {
    return await getHistory();
  }

  static Future<void> addRecord(DiagnosisRequest request) async {
    await addToHistory(request);
  }

  static Future<void> deleteRecord(String id) async {
    // Geçici olarak hiçbir şey yapma
  }
}
