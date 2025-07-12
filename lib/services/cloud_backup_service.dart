import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/device.dart';
import '../models/diagnosis_request.dart';

class CloudBackupService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Cihazları yedekle
  static Future<bool> backupDevices(List<Device> devices) async {
    try {
      final devicesData = devices.map((device) => device.toJson()).toList();
      
      await _firestore
          .collection('users')
          .doc('user_id') // Gerçek kullanıcı ID'si kullanılacak
          .collection('backups')
          .doc('devices')
          .set({
        'devices': devicesData,
        'timestamp': FieldValue.serverTimestamp(),
      });
      
      return true;
    } catch (e) {
      print('Cihaz yedekleme hatası: $e');
      return false;
    }
  }

  // Cihaz geçmişini yedekle
  static Future<bool> backupServiceRecords(List<DiagnosisRequest> records) async {
    try {
      final recordsData = records.map((record) => record.toMap()).toList();
      
      await _firestore
          .collection('users')
          .doc('user_id') // Gerçek kullanıcı ID'si kullanılacak
          .collection('backups')
          .doc('service_records')
          .set({
        'service_records': recordsData,
        'timestamp': FieldValue.serverTimestamp(),
      });
      
      return true;
    } catch (e) {
      print('Cihaz geçmişi yedekleme hatası: $e');
      return false;
    }
  }

  // Cihazları geri yükle
  static Future<List<Device>> restoreDevices() async {
    try {
      final doc = await _firestore
          .collection('users')
          .doc('user_id') // Gerçek kullanıcı ID'si kullanılacak
          .collection('backups')
          .doc('devices')
          .get();
      
      if (!doc.exists) {
        return [];
      }
      
      final data = doc.data() as Map<String, dynamic>;
      final devicesData = data['devices'] as List;
      return devicesData
          .map((json) => Device.fromJson(json))
          .toList();
    } catch (e) {
      print('Cihaz geri yükleme hatası: $e');
      return [];
    }
  }

  // Cihaz geçmişini geri yükle
  static Future<List<DiagnosisRequest>> restoreServiceRecords() async {
    try {
      final doc = await _firestore
          .collection('users')
          .doc('user_id') // Gerçek kullanıcı ID'si kullanılacak
          .collection('backups')
          .doc('service_records')
          .get();
      
      if (!doc.exists) {
        return [];
      }
      
      final data = doc.data() as Map<String, dynamic>;
      final recordsData = data['service_records'] as List;
      return recordsData
          .map((json) => DiagnosisRequest.fromMap(json))
          .toList();
    } catch (e) {
      print('Cihaz geçmişi geri yükleme hatası: $e');
      return [];
    }
  }

  // Tüm verileri yedekle
  static Future<bool> backupAllData(List<Device> devices, List<DiagnosisRequest> records) async {
    try {
      final batch = _firestore.batch();
      
      // Cihazları yedekle
      final devicesRef = _firestore
          .collection('users')
          .doc('user_id')
          .collection('backups')
          .doc('devices');
      
      batch.set(devicesRef, {
        'devices': devices.map((device) => device.toJson()).toList(),
        'timestamp': FieldValue.serverTimestamp(),
      });
      
      // Cihaz geçmişini yedekle
      final recordsRef = _firestore
          .collection('users')
          .doc('user_id')
          .collection('backups')
          .doc('service_records');
      
      batch.set(recordsRef, {
        'service_records': records.map((record) => record.toMap()).toList(),
        'timestamp': FieldValue.serverTimestamp(),
      });
      
      await batch.commit();
      return true;
    } catch (e) {
      print('Tüm veri yedekleme hatası: $e');
      return false;
    }
  }

  // Yedekleme durumunu kontrol et
  static Future<bool> hasBackup() async {
    try {
      final devicesDoc = await _firestore
          .collection('users')
          .doc('user_id')
          .collection('backups')
          .doc('devices')
          .get();
      
      final recordsDoc = await _firestore
          .collection('users')
          .doc('user_id')
          .collection('backups')
          .doc('service_records')
          .get();
      
      return devicesDoc.exists || recordsDoc.exists;
    } catch (e) {
      print('Yedekleme durumu kontrol hatası: $e');
      return false;
    }
  }
} 