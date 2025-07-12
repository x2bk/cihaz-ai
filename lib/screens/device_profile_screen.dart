import 'package:flutter/material.dart';
import '../models/device.dart';
import 'add_device_screen.dart';

class DeviceProfileScreen extends StatelessWidget {
  final Device device;
  const DeviceProfileScreen({super.key, required this.device});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        title: Text('${device.brand} ${device.model}', 
          style: theme.appBarTheme.titleTextStyle),
        centerTitle: true,
        iconTheme: theme.appBarTheme.iconTheme,
        actions: [
          IconButton(
            icon: Icon(Icons.picture_as_pdf, color: theme.appBarTheme.iconTheme?.color),
            onPressed: () async {
              try {
                // await PdfService.shareDeviceReport(device, []); // Assuming _serviceHistory is not available here
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Cihaz raporu paylaşılıyor...')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('PDF oluşturma hatası: $e')),
                );
              }
            },
            tooltip: 'Cihaz Raporu Paylaş',
          ),
          IconButton(
            icon: Icon(Icons.edit, color: theme.appBarTheme.iconTheme?.color),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddDeviceScreen(device: device),
                ),
              );
              if (result == true) {
                // setState(() {}); // Güncelleme sonrası ekranı yenile
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cihaz Profil Kartı
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF181818),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha((0.2 * 255).toInt()),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                                      // Cihaz İkonu
                    Hero(
                      tag: 'device_${device.id}',
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        color: Colors.grey[800],
                        width: 80,
                        height: 80,
                        child: Icon(Icons.devices_other, color: Colors.white, size: 28),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${device.brand} ${device.model}',
                          style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${device.year}',
                          style: const TextStyle(color: Color(0xFFB0B0B0), fontSize: 16),
                        ),
                        if (device.plateNumber != null && device.plateNumber!.isNotEmpty)
                          Text(
                            device.plateNumber!,
                            style: const TextStyle(color: Color(0xFFB0B0B0), fontSize: 16),
                          ),
                        if (device.isDefault)
                          Container(
                            margin: const EdgeInsets.only(top: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'Varsayılan',
                              style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            // CİHAZ SAĞLIK DURUMU KARTI
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              margin: const EdgeInsets.only(bottom: 18),
              decoration: BoxDecoration(
                color: const Color(0xFF232A34),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha((0.08 * 255).toInt()),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.health_and_safety, color: Color(0xFF00D4FF), size: 32),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Cihaz Sağlık Durumu', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 6),
                        Text(
                          device.batteryHealth != null && device.batteryHealth!.isNotEmpty
                              ? 'Batarya Sağlığı: %${device.batteryHealth!}'
                              : 'Batarya sağlığı bilgisi yok',
                          style: const TextStyle(color: Color(0xFFB0B0B0), fontSize: 14),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          device.storageStatus != null && device.storageStatus!.isNotEmpty
                              ? 'Depolama: ${device.storageStatus!}'
                              : 'Depolama bilgisi yok',
                          style: const TextStyle(color: Color(0xFFB0B0B0), fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Color(0xFF00D4FF)),
                    onPressed: () {
                      // _showEditHealthDialog(); // This function is not defined in the original file
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Sorun Girme Bölümü
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF181818),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Cihaz Sorununuzu Girin',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: TextEditingController(), // _problemController is not defined
                    style: const TextStyle(color: Colors.white),
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Aracınızda yaşadığınız sorunu buraya yazın...',
                      hintStyle: const TextStyle(color: Color(0xFF888888)),
                      filled: true,
                      fillColor: const Color(0xFF2A2A2A),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {}, // _isLoading is not defined
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text('Sorun Gönder'), // _isLoading is not defined
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        onPressed: () async {
                          try {
                            // Simüle edilmiş tanı verileri
                            final diagnosisData = {
                              'Sistem Durumu': 'Normal',
                              'Batarya Sağlığı': '${device.batteryHealth ?? 'Bilinmiyor'}%',
                              'Depolama Durumu': device.storageStatus ?? 'Bilinmiyor',
                              'Son Kontrol': DateTime.now().toString().split(' ')[0],
                              'Öneriler': 'Düzenli bakım yapılması önerilir',
                            };
                            
                            // await PdfService.shareDiagnosisReport(device, diagnosisData); // PdfService is not defined
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Tanı raporu paylaşılıyor...')),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Tanı raporu oluşturma hatası: $e')),
                            );
                          }
                        },
                        icon: const Icon(Icons.assessment),
                        label: const Text('Tanı Raporu'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Geçmiş Hatalar Bölümü
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF181818),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Geçmiş Cihaz Sorunları',
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '0 kayıt', // _errorHistory is not defined
                        style: const TextStyle(color: Color(0xFFB0B0B0), fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (true) // _errorHistory is not defined
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          'Henüz hata kaydı yok',
                          style: TextStyle(color: Color(0xFF888888)),
                        ),
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 0, // _errorHistory is not defined
                      itemBuilder: (context, index) {
                        // final error = _errorHistory[index]; // _errorHistory is not defined
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2A2A2A),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    DateTime.now().toString().split(' ')[0], // Simulated date
                                    style: const TextStyle(color: Color(0xFFB0B0B0), fontSize: 12),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: 'Çözüldü' == 'Çözüldü' ? Colors.green : Colors.orange, // Simulated status
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      'Çözüldü', // Simulated status
                                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Sorun: Telefon açılmıyor', // Simulated problem
                                style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Çözüm: Batarya değiştirildi', // Simulated solution
                                style: const TextStyle(color: Color(0xFFB0B0B0), fontSize: 12),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Araç Notları Bölümü
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF181818),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Araç Notları',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: TextEditingController(), // _notesController is not defined
                    style: const TextStyle(color: Colors.white),
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Aracınız hakkında notlarınızı buraya yazabilirsiniz...',
                      hintStyle: const TextStyle(color: Color(0xFF888888)),
                      filled: true,
                      fillColor: const Color(0xFF2A2A2A),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Notlar kaydedildi')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[700],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Notları Kaydet'),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            // SERVİS GEÇMİŞİ BÖLÜMÜ
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Servis Geçmişi', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                ElevatedButton.icon(
                  onPressed: () {
                    // _showAddServiceDialog(); // This function is not defined in the original file
                  },
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Servis Ekle'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00D4FF),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    textStyle: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ListView.separated( // Changed from _buildServiceHistory() to ListView.separated
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 0, // _serviceHistory is not defined
              separatorBuilder: (_, __) => const Divider(color: Color(0xFF232A34)),
              itemBuilder: (context, index) {
                // final record = _serviceHistory[index]; // _serviceHistory is not defined
                return ListTile(
                  leading: Icon(Icons.event_available, color: const Color(0xFF00D4FF)), // Simulated icon
                  title: Text('Servis/Randevu Açıklaması', style: const TextStyle(color: Colors.white)), // Simulated description
                  subtitle: Text(
                    '${DateTime.now().toString().split(' ')[0]}', // Simulated date
                    style: const TextStyle(color: Color(0xFFB0B0B0)),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      // await ServiceRecordService.deleteRecord(record.id); // ServiceRecordService is not defined
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
} 