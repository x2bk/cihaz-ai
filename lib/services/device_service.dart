import '../models/device.dart';

class DeviceService {
  static Future<List<Device>> getDevices() async {
    return []; // Geçici olarak boş liste
  }

  static Future<void> addDevice(Device device) async {
    // Geçici olarak hiçbir şey yapma
  }

  static Future<void> updateDevice(Device device) async {
    // Geçici olarak hiçbir şey yapma
  }

  static Future<void> deleteDevice(String deviceId) async {
    // Geçici olarak hiçbir şey yapma
  }

  static Future<String?> getDefaultDeviceId() async {
    return null; // Geçici olarak null
  }

  static Future<void> setDefaultDeviceId(String deviceId) async {
    // Geçici olarak hiçbir şey yapma
  }

  static Future<void> clearDefaultDeviceId() async {
    // Geçici olarak hiçbir şey yapma
  }
}
