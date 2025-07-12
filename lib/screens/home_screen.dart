import 'package:flutter/material.dart';
import '../models/device.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';
import 'device_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  List<Device> _devices = [];
  final int unreadNotifications = 3;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    return Theme(
      data: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark),
        scaffoldBackgroundColor: const Color(0xFF101624),
        primaryColor: const Color(0xFF3B82F6),
        cardColor: const Color(0xFF181818),
      ),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: mq.size.width * 0.04, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Modern üst bar
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 8, bottom: 20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.7),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Cihaz AI', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              _CircleIconButton(icon: Icons.notifications_none, onTap: () {}),
                              if (unreadNotifications > 0)
                                Positioned(
                                  right: 2,
                                  top: 2,
                                  child: Container(
                                    padding: const EdgeInsets.all(3),
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                                    child: Text(
                                      unreadNotifications.toString(),
                                      style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(width: 16),
                          _CircleIconButton(icon: Icons.settings, onTap: () {}),
                          const SizedBox(width: 16),
                          _CircleIconButton(icon: Icons.logout, onTap: () {}),
                        ],
                      ),
                    ],
                  ),
                ),
                // Kayıtlı cihazlar başlık
                const Text('Kayıtlı Cihazlar', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 14),
                // Kayıtlı cihazlar yatay scrollable kartlar veya cihaz ekle butonu
                SizedBox(
                  height: 160,
                  child: _devices.isEmpty
                      ? Center(
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              // Cihaz ekleme fonksiyonu burada olmalı
                            },
                            icon: const Icon(Icons.add, size: 32),
                            label: const Text('Bu Cihazı Yükle', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF3B82F6),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 22),
                              textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              elevation: 4,
                            ),
                          ),
                        )
                      : ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: _devices.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 14),
                          itemBuilder: (context, i) {
                            final d = _devices[i];
                            return _AnimatedDeviceCard(
                              device: d,
                              addedDate: DateTime.now(),
                              status: 'Aktif',
                              onInfo: () {},
                              onEdit: () {},
                              onDelete: () {},
                            );
                          },
                        ),
                ),
                const SizedBox(height: 24),
                // Bir sorun mu var? kutusu ve gönder/mikrofon butonları
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF232A3B),
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Bir sorun mu var? Yazabilir veya sesli anlatabilirsin.',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onLongPress: () {},
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF3B82F6),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.withOpacity(0.12),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(10),
                            child: Icon(Icons.mic, color: Colors.white, size: 24),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF3B82F6),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.12),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(10),
                          child: Icon(Icons.send, color: Colors.white, size: 24),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF3B82F6),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.18),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.mic, color: Colors.white, size: 32),
                      onPressed: () {},
                      iconSize: 48,
                      padding: const EdgeInsets.all(18),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                // Teşhis Geçmişi başlık ve kutusu
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Teşhis Geçmişi', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.history, color: Color(0xFF3B82F6)),
                      label: const Text('Geçmişi Gör', style: TextStyle(color: Color(0xFF3B82F6), fontWeight: FontWeight.bold)),
                      style: TextButton.styleFrom(foregroundColor: const Color(0xFF3B82F6)),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 0,
                  itemBuilder: (context, i) {
                    return Container();
                  },
                ),
                if (true)
                  Column(
                    children: [
                      const SizedBox(height: 10),
                      Icon(Icons.inbox, size: 54, color: Colors.blueGrey.withOpacity(0.18)),
                      const SizedBox(height: 10),
                      const Text(
                        'Henüz teşhis geçmişiniz yok.',
                        style: TextStyle(fontSize: 15, color: Color(0xFFB0B0B0)),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(bottom: 16, left: 24, right: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _BottomNavButton(
                icon: Icons.home,
                label: 'Ana Sayfa',
                selected: _selectedIndex == 0,
                onTap: () {
                  setState(() => _selectedIndex = 0);
                },
              ),
              _BottomNavButton(
                icon: Icons.devices_other,
                label: 'Cihazlarım',
                selected: _selectedIndex == 1,
                onTap: () {
                  setState(() => _selectedIndex = 1);
                },
              ),
              _BottomNavButton(
                icon: Icons.favorite,
                label: 'Favoriler',
                selected: false,
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomNavButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _BottomNavButton({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            color: selected ? const Color(0xFF2563EB) : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: selected ? Colors.white : const Color(0xFFB0B0B0),
                size: 28,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: selected ? Colors.white : const Color(0xFFB0B0B0),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _CircleIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withOpacity(0.18),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
      ),
    );
  }
}

class _AnimatedDeviceCard extends StatelessWidget {
  final Device device;
  final DateTime addedDate;
  final String status;
  final VoidCallback onInfo;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  const _AnimatedDeviceCard({
    required this.device,
    required this.addedDate,
    required this.status,
    required this.onInfo,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: 240,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF181818) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.18) : Colors.blue.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.devices_other, color: Color(0xFF3B82F6), size: 32),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  device.brand,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.info_outline, color: Color(0xFF3B82F6)),
                onPressed: onInfo,
                tooltip: 'Detay',
              ),
              IconButton(
                icon: const Icon(Icons.edit, color: Color(0xFF3B82F6)),
                onPressed: onEdit,
                tooltip: 'Düzenle',
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                onPressed: onDelete,
                tooltip: 'Sil',
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            device.model,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Text(
                device.category,
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? Colors.blue[200] : Colors.blue[700],
                ),
              ),
              const Spacer(),
              Icon(
                Icons.circle,
                size: 10,
                color: status == 'Aktif' ? Colors.green : Colors.grey,
              ),
              const SizedBox(width: 4),
              Text(
                status,
                style: TextStyle(
                  fontSize: 12,
                  color: status == 'Aktif' ? Colors.green : Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Eklendi: ${addedDate.day}.${addedDate.month}.${addedDate.year}',
            style: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.white38 : Colors.black38,
            ),
          ),
        ],
      ),
    );
  }
} 