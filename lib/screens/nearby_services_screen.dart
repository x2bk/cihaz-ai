import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/location_service.dart';

class NearbyServicesScreen extends StatefulWidget {
  const NearbyServicesScreen({super.key});

  @override
  State<NearbyServicesScreen> createState() => _NearbyServicesScreenState();
}

class _NearbyServicesScreenState extends State<NearbyServicesScreen> {
  List<Map<String, dynamic>> _services = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadNearbyServices();
  }

  Future<void> _loadNearbyServices() async {
    setState(() {
      _isLoading = true;
      _error = null;
      _services = [];
    });
    final position = await LocationService.getCurrentLocation();
    if (!mounted) return;
    if (position == null) {
      setState(() {
        _error = 'Konum alınamadı. Lütfen konum izinlerini kontrol edin.';
        _isLoading = false;
      });
      return;
    }
    try {
      final services = await LocationService.getNearbyServices(
        position.latitude,
        position.longitude,
      );
      if (!mounted) return;
      setState(() {
        _services = services;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Servisler yüklenirken hata oluştu.';
        _isLoading = false;
      });
    }
  }

  Future<void> _callService(String phone) async {
    final url = 'tel:$phone';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  Future<void> _openMaps(double lat, double lng) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        title: Text(
          'Yakındaki Servisler',
          style: theme.appBarTheme.titleTextStyle,
        ),
        centerTitle: true,
        iconTheme: theme.appBarTheme.iconTheme,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: theme.appBarTheme.iconTheme?.color),
            onPressed: _isLoading ? null : _loadNearbyServices,
            tooltip: 'Yenile',
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: theme.primaryColor))
          : _error != null
          ? Center(
              child: Text(
                _error!,
                style: TextStyle(color: isDark ? const Color(0xFFB0B0B0) : const Color(0xFF666666), fontSize: 16),
                textAlign: TextAlign.center,
              ),
            )
          : _services.isEmpty
          ? Center(
              child: Text(
                'Yakınızda servis bulunamadı.',
                style: TextStyle(color: isDark ? const Color(0xFFB0B0B0) : const Color(0xFF666666), fontSize: 16),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(24),
              itemCount: _services.length,
              separatorBuilder: (_, _) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final service = _services[index];
                return Container(
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF181818) : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: isDark ? null : [
                      BoxShadow(
                        color: Colors.black.withAlpha((0.1 * 255).toInt()),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.build,
                            color: isDark ? Colors.white : Colors.black87,
                            size: 28,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              service['name'],
                              style: TextStyle(
                                color: isDark ? Colors.white : Colors.black87,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        service['address'],
                        style: TextStyle(color: isDark ? const Color(0xFFB0B0B0) : const Color(0xFF666666)),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 18),
                          const SizedBox(width: 4),
                          Text(
                            '${service['rating']}',
                            style: TextStyle(color: isDark ? const Color(0xFFB0B0B0) : const Color(0xFF666666)),
                          ),
                          const SizedBox(width: 16),
                          Icon(
                            Icons.location_on,
                            color: isDark ? const Color(0xFFB0B0B0) : const Color(0xFF666666),
                            size: 18,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            service['distance'],
                            style: TextStyle(color: isDark ? const Color(0xFFB0B0B0) : const Color(0xFF666666)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => _callService(service['phone']),
                              icon: Icon(
                                Icons.phone,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                              label: Text(
                                'Ara',
                                style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                  color: isDark ? const Color(0xFF444444) : const Color(0xFFE0E0E0),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => _openMaps(
                                service['latitude'],
                                service['longitude'],
                              ),
                              icon: Icon(Icons.map, color: isDark ? Colors.white : Colors.black87),
                              label: Text(
                                'Harita',
                                style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                  color: isDark ? const Color(0xFF444444) : const Color(0xFFE0E0E0),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
