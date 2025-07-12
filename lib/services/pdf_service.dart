import '../models/device.dart';
import '../models/service_record.dart';

class PdfService {
  static Future<void> generateAndShareReport(Device device, List<ServiceRecord> records) async {
    // PDF oluşturma ve paylaşım işlemleri burada yapılacak
    // Şimdilik basit bir placeholder
    print('${device.brand} ${device.model} cihazı için rapor oluşturuldu');
  }
} 