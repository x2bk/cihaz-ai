import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart';

class LocationService {
  static Future<Position?> getCurrentLocation() async {
    try {
      // Konum izni kontrolü
      final permission = await Permission.location.request();
      if (permission != PermissionStatus.granted) {
        throw Exception('Konum izni verilmedi');
      }

      // Konum servislerinin açık olup olmadığını kontrol et
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Konum servisleri kapalı');
      }

      // Mevcut konumu al
      return await Geolocator.getCurrentPosition();
    } catch (e) {
      debugPrint('Konum alınamadı: $e');
      return null;
    }
  }

  static Future<String?> getAddressFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    try {
      final placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        return '${place.street}, ${place.locality}, ${place.administrativeArea}';
      }
      return null;
    } catch (e) {
      debugPrint('Adres alınamadı: $e');
      return null;
    }
  }

  static Future<List<Map<String, dynamic>>> getNearbyServices(
    double latitude,
    double longitude,
  ) async {
    // Gerçek uygulamada burada Google Places API kullanılabilir
    // Şimdilik mock data döndürüyoruz
    await Future.delayed(const Duration(seconds: 1));

    return [
      {
        'name': 'ABC Oto Servis',
        'address': 'Atatürk Caddesi No:123',
        'distance': '0.5 km',
        'rating': 4.5,
        'phone': '+90 212 555 0123',
        'latitude': latitude + 0.001,
        'longitude': longitude + 0.001,
      },
      {
        'name': 'XYZ Motor',
        'address': 'İnönü Sokak No:45',
        'distance': '1.2 km',
        'rating': 4.2,
        'phone': '+90 212 555 0456',
        'latitude': latitude - 0.002,
        'longitude': longitude + 0.002,
      },
      {
        'name': 'Teknik Oto',
        'address': 'Cumhuriyet Bulvarı No:78',
        'distance': '2.1 km',
        'rating': 4.8,
        'phone': '+90 212 555 0789',
        'latitude': latitude + 0.003,
        'longitude': longitude - 0.001,
      },
    ];
  }
}
