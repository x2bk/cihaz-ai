import 'package:flutter/material.dart';
import '../models/device.dart';

class DeviceDetailScreen extends StatelessWidget {
  final Device device;
  const DeviceDetailScreen({super.key, required this.device});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF101624) : const Color(0xFFF6F8FC),
      appBar: AppBar(
        title: const Text('Cihaz Detayları'),
        centerTitle: true,
        backgroundColor: isDark ? const Color(0xFF19213A) : Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black),
        titleTextStyle: TextStyle(
          color: isDark ? Colors.white : Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Üstte büyük cihaz ikonu ve başlık
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF19213A) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: isDark ? Colors.black.withValues(alpha: 0.3) : Colors.blue.withValues(alpha: 0.08),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Icon(Icons.devices_other, size: 56, color: const Color(0xFF3B82F6)),
                    const SizedBox(height: 12),
                    Text(
                      device.brand,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      device.model,
                      style: TextStyle(
                        fontSize: 18,
                        color: isDark ? Colors.white70 : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              // Bilgi kartları
              _infoCard(
                context,
                icon: Icons.category,
                label: 'Kategori',
                value: device.category.isNotEmpty ? device.category : 'Bilinmiyor',
              ),
              _infoCard(
                context,
                icon: Icons.calendar_today,
                label: 'Yıl',
                value: device.year.toString(),
              ),
              _infoCard(
                context,
                icon: Icons.memory,
                label: 'İşlemci',
                value: (device.cpu != null && device.cpu!.isNotEmpty) ? device.cpu! : 'Bilinmiyor',
                highlight: true,
              ),
              _infoCard(
                context,
                icon: Icons.sd_storage,
                label: 'Depolama',
                value: (device.disk != null && device.disk!.isNotEmpty) ? device.disk! : 'Bilinmiyor',
                highlight: true,
              ),
              _infoCard(
                context,
                icon: Icons.memory,
                label: 'RAM',
                value: (device.ram != null && device.ram!.isNotEmpty) ? device.ram! : 'Bilinmiyor',
                highlight: true,
              ),
              if (device.imei != null && device.imei!.isNotEmpty)
                _infoCard(
                  context,
                  icon: Icons.confirmation_number,
                  label: 'IMEI',
                  value: device.imei!,
                ),
              if (device.batteryHealth != null && device.batteryHealth!.isNotEmpty)
                _infoCard(
                  context,
                  icon: Icons.battery_full,
                  label: 'Batarya Sağlığı',
                  value: device.batteryHealth!,
                ),
              if (device.storageStatus != null && device.storageStatus!.isNotEmpty)
                _infoCard(
                  context,
                  icon: Icons.storage,
                  label: 'Depolama Durumu',
                  value: device.storageStatus!,
                ),
              _infoCard(
                context,
                icon: Icons.info_outline,
                label: 'Not',
                value: (device.notes != null && device.notes!.isNotEmpty) ? device.notes! : 'Yok',
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoCard(BuildContext context, {required IconData icon, required String label, required String value, bool highlight = false}) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: highlight
            ? (isDark ? const Color(0xFF243B55) : const Color(0xFFEFF6FF))
            : (isDark ? const Color(0xFF19213A) : Colors.white),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withValues(alpha: 0.18) : Colors.blue.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: highlight
            ? Border.all(color: const Color(0xFF3B82F6), width: 1.2)
            : null,
      ),
      child: Row(
        children: [
          Icon(icon, color: highlight ? const Color(0xFF3B82F6) : (isDark ? Colors.white70 : Colors.blueGrey), size: 28),
          const SizedBox(width: 18),
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 17,
                color: highlight ? const Color(0xFF3B82F6) : (isDark ? Colors.white70 : Colors.black87),
                fontWeight: highlight ? FontWeight.bold : FontWeight.normal,
              ),
              textAlign: TextAlign.right,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
} 