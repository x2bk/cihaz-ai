import 'package:flutter/material.dart';
import '../models/device.dart';
import '../models/diagnosis_request.dart';
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
  // Örnek cihaz verisi
  List<Device> _devices = [];
  // Dummy kullanıcı bilgisi
  final String userName = 'Ahmet';
  final String profileUrl = 'https://randomuser.me/api/portraits/men/32.jpg';
  final int unreadNotifications = 3;
  // State'e tema değişkeni ekle
  bool _isDarkTheme = false;



  Future<void> _detectAndAddCurrentDevice() async {
    final deviceInfo = DeviceInfoPlugin();
    String brand = 'Bilinmiyor';
    String model = 'Bilinmiyor';
    String os = '';
    int year = DateTime.now().year;
    String? ram;
    String? disk;
    String? cpu;

    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      brand = androidInfo.brand ?? 'Android';
      model = androidInfo.model ?? 'Android';
      os = 'Android ${androidInfo.version.release}';
      // RAM bilgisini doğru çek
      if (androidInfo.physicalRamSize != null) {
        ram = '${(androidInfo.physicalRamSize! / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
      }
      if (androidInfo.totalDiskSize != null) {
        disk = '${(androidInfo.totalDiskSize! / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
      }
      // İşlemci bilgisini doğru çek
      cpu = androidInfo.hardware ?? androidInfo.board ?? androidInfo.device ?? androidInfo.product ?? androidInfo.host;
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      brand = 'Apple';
      model = iosInfo.utsname.machine ?? 'iPhone';
      os = '${iosInfo.systemName} ${iosInfo.systemVersion}';
      if (iosInfo.physicalRamSize != null) {
        ram = '${(iosInfo.physicalRamSize! / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
      }
      if (iosInfo.totalDiskSize != null) {
        disk = '${(iosInfo.totalDiskSize! / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
      }
      cpu = iosInfo.utsname.machine;
    } else {
      brand = Platform.operatingSystem;
      model = Platform.localHostname;
      os = Platform.operatingSystemVersion;
    }

    final newDevice = Device(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      category: 'Telefon',
      brand: brand,
      model: model,
      year: year,
      notes: os,
      ram: ram,
      disk: disk,
      cpu: cpu,
    );

    setState(() {
      _devices.add(newDevice);
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cihaz Eklendi'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Marka: ${newDevice.brand}'),
            Text('Model: ${newDevice.model}'),
            Text('Yıl: ${newDevice.year}'),
            Text('İşletim Sistemi: ${newDevice.notes}'),
            if (newDevice.ram != null) Text('RAM: ${newDevice.ram}'),
            if (newDevice.disk != null) Text('Depolama: ${newDevice.disk}'),
            if (newDevice.cpu != null) Text('İşlemci: ${newDevice.cpu}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Kapat'),
          ),
        ],
      ),
    );
  }

  // Info butonuna basınca cihaz detay ekranına yönlendir
  void _showDeviceDetails(Device device) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DeviceDetailScreen(device: device),
      ),
    );
  }

  // Profil fotoğrafını büyütme dialog'u
  void _showProfileImageDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.8,
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          decoration: BoxDecoration(
            color: _isDarkTheme ? const Color(0xFF1A1A1A) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Üst bar - kapat butonu
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Profil Fotoğrafı',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _isDarkTheme ? Colors.white : Colors.black,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.close,
                        color: _isDarkTheme ? Colors.white : Colors.black,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
              // Profil fotoğrafı
              Flexible(
                child: Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.network(
                      profileUrl,
                      fit: BoxFit.cover,
                      width: 200,
                      height: 200,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            color: _isDarkTheme ? const Color(0xFF2A2A2A) : const Color(0xFFF0F0F0),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                  : null,
                              color: const Color(0xFF3B82F6),
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            color: _isDarkTheme ? const Color(0xFF2A2A2A) : const Color(0xFFF0F0F0),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.person,
                            size: 80,
                            color: _isDarkTheme ? Colors.white70 : Colors.grey,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              // Alt bilgi
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      userName,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: _isDarkTheme ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Kullanıcı',
                      style: TextStyle(
                        fontSize: 14,
                        color: _isDarkTheme ? Colors.white70 : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddDeviceDialog() {
    final _formKey = GlobalKey<FormState>();
    String category = 'Telefon';
    String brand = '';
    String model = '';
    String year = DateTime.now().year.toString();
    String ram = '';
    String disk = '';
    String cpu = '';
    String notes = '';
    String? errorText;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) => Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              padding: const EdgeInsets.all(0),
              decoration: BoxDecoration(
                color: Theme.of(context).dialogBackgroundColor,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.10),
                    blurRadius: 32,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Üstte büyük cihaz ikonu ve başlık
                      Icon(Icons.devices_other, size: 48, color: const Color(0xFF3B82F6)),
                      const SizedBox(height: 12),
                      Text('Cihaz Ekle', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
                      const SizedBox(height: 18),
                      if (errorText != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(errorText!, style: const TextStyle(color: Colors.red)),
                        ),
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DropdownButtonFormField<String>(
                              value: category,
                              decoration: InputDecoration(
                                labelText: 'Kategori',
                                prefixIcon: Icon(Icons.category, color: Theme.of(context).colorScheme.primary),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                                filled: true,
                                fillColor: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF232A3B) : const Color(0xFFF3F6FB),
                              ),
                              items: ['Telefon', 'Tablet', 'Laptop', 'Diğer']
                                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                                  .toList(),
                              onChanged: (val) => category = val ?? 'Telefon',
                            ),
                            const SizedBox(height: 14),
                            _modernTextField(
                              context,
                              label: 'Marka',
                              icon: Icons.business,
                              validator: (v) => (v == null || v.trim().isEmpty) ? 'Marka giriniz' : null,
                              onSaved: (v) => brand = v?.trim() ?? '',
                            ),
                            const SizedBox(height: 14),
                            _modernTextField(
                              context,
                              label: 'Model',
                              icon: Icons.phone_android,
                              validator: (v) => (v == null || v.trim().isEmpty) ? 'Model giriniz' : null,
                              onSaved: (v) => model = v?.trim() ?? '',
                            ),
                            const SizedBox(height: 14),
                            _modernTextField(
                              context,
                              label: 'Yıl',
                              icon: Icons.calendar_today,
                              keyboardType: TextInputType.number,
                              initialValue: year,
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) return 'Yıl giriniz';
                                final y = int.tryParse(v);
                                final now = DateTime.now().year;
                                if (y == null || y < 1970 || y > now + 1) return 'Geçerli bir yıl giriniz';
                                return null;
                              },
                              onSaved: (v) => year = v?.trim() ?? DateTime.now().year.toString(),
                            ),
                            const SizedBox(height: 14),
                            _modernTextField(
                              context,
                              label: 'RAM (GB)',
                              icon: Icons.memory,
                              keyboardType: TextInputType.number,
                              onSaved: (v) => ram = v?.trim() ?? '',
                            ),
                            const SizedBox(height: 14),
                            _modernTextField(
                              context,
                              label: 'Depolama (GB)',
                              icon: Icons.sd_storage,
                              keyboardType: TextInputType.number,
                              onSaved: (v) => disk = v?.trim() ?? '',
                            ),
                            const SizedBox(height: 14),
                            _modernTextField(
                              context,
                              label: 'İşlemci',
                              icon: Icons.memory_outlined,
                              onSaved: (v) => cpu = v?.trim() ?? '',
                            ),
                            const SizedBox(height: 14),
                            _modernTextField(
                              context,
                              label: 'Not',
                              icon: Icons.info_outline,
                              onSaved: (v) => notes = v?.trim() ?? '',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('İptal'),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              try {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  final newDevice = Device(
                                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                                    category: category,
                                    brand: brand,
                                    model: model,
                                    year: int.tryParse(year) ?? DateTime.now().year,
                                    ram: ram.isNotEmpty ? (ram + ' GB') : null,
                                    disk: disk.isNotEmpty ? (disk + ' GB') : null,
                                    cpu: cpu.isNotEmpty ? cpu : null,
                                    notes: notes.isNotEmpty ? notes : null,
                                  );
                                  if (!mounted) return;
                                  setState(() {
                                    _devices.add(newDevice);
                                  });
                                  Navigator.pop(context);
                                  // Eklendikten sonra detay ekranına yönlendir
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DeviceDetailScreen(device: newDevice),
                                    ),
                                  );
                                }
                              } catch (e) {
                                setStateDialog(() {
                                  errorText = 'Bir hata oluştu:  {e.toString()}';
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF3B82F6),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                              textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              elevation: 2,
                            ),
                            child: const Text('Ekle'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _modernTextField(
    BuildContext context, {
    required String label,
    required IconData icon,
    String? initialValue,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    void Function(String?)? onSaved,
  }) {
    return TextFormField(
      initialValue: initialValue,
      keyboardType: keyboardType,
      validator: validator,
      onSaved: onSaved,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Theme.of(context).colorScheme.primary),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        filled: true,
        fillColor: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF232A3B) : const Color(0xFFF3F6FB),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = _isDarkTheme;
    final mq = MediaQuery.of(context);
    return Theme(
      data: _isDarkTheme
          ? ThemeData.dark().copyWith(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark),
              scaffoldBackgroundColor: const Color(0xFF101624),
              primaryColor: const Color(0xFF3B82F6),
              cardColor: const Color(0xFF181818),
            )
          : ThemeData.light().copyWith(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.light),
              scaffoldBackgroundColor: const Color(0xFFF6F8FC),
              primaryColor: const Color(0xFF3B82F6),
              cardColor: Colors.white,
            ),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        // Tema değiştirici buton sağ üstte
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: mq.size.width * 0.04, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hoşgeldiniz kutusu yerine üst barı fotoğraftaki gibi yap
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(top: 8, bottom: 20),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isDark
                              ? [const Color(0xFF1E3A8A), const Color(0xFF3B82F6)]
                              : [const Color(0xFF3B82F6), const Color(0xFF1E40AF)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: isDark ? Colors.black.withValues(alpha: 0.7) : Colors.blue.withValues(alpha: 0.15),
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Merhaba, $userName!', style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                                // const SizedBox(height: 6),
                                // const Text('En iyi sürüş için hazır', style: TextStyle(color: Colors.white70, fontSize: 14)), // KALDIRILDI
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              // Profil fotoğrafı vektörel çerçeve ve ikon ile
                              GestureDetector(
                                onTap: _showProfileImageDialog,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      width: 44,
                                      height: 44,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: LinearGradient(
                                          colors: [Color(0xFF3B82F6), Color(0xFF60A5FA)],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withValues(alpha: 0.10),
                                            blurRadius: 8,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: 38,
                                      height: 38,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                        border: Border.all(color: Colors.white.withValues(alpha: 0.5), width: 2),
                                      ),
                                      child: ClipOval(
                                        child: Image.network(
                                          profileUrl,
                                          fit: BoxFit.cover,
                                          loadingBuilder: (context, child, loadingProgress) {
                                            if (loadingProgress == null) return child;
                                            return Container(
                                              decoration: const BoxDecoration(
                                                color: Colors.white24,
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Center(
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                                                ),
                                              ),
                                            );
                                          },
                                          errorBuilder: (context, error, stackTrace) {
                                            return Container(
                                              decoration: const BoxDecoration(
                                                color: Colors.white24,
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Icon(
                                                Icons.person,
                                                color: Colors.blue,
                                                size: 20,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    // Vektörel simge (ör: yıldız)
                                    Positioned(
                                      bottom: 2,
                                      right: 2,
                                      child: Icon(Icons.verified, color: Color(0xFF3B82F6), size: 16),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              // Bildirim ikonu + badge
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
                    // Kayıtlı cihazlar başlık ve ekle butonu
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Kayıtlı Cihazlar', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        // FAB olduğu için burada buton yok
                      ],
                    ),
                    const SizedBox(height: 14),
                    // Kayıtlı cihazlar yatay scrollable kartlar veya cihaz ekle butonu
                    SizedBox(
                      height: 160,
                      child: _devices.isEmpty
                          ? Center(
                              child: ElevatedButton.icon(
                                onPressed: () async {
                                  await _detectAndAddCurrentDevice();
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
                                  addedDate: getDeviceAddedDate(d),
                                  status: getDeviceStatus(d),
                                  onInfo: () => _showDeviceDetails(d),
                                  onEdit: () {},
                                  onDelete: () {
                                    setState(() => _devices.removeAt(i));
                                  },
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
                        color: isDark ? const Color(0xFF232A3B) : const Color(0xFFF3F6FB),
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: isDark ? Colors.black.withValues(alpha: 0.08) : Colors.blue.withValues(alpha: 0.06),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: _AnimatedHintTextField(),
                          ),
                          const SizedBox(width: 6),
                          GestureDetector(
                            onLongPress: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Sesli arama başlatılıyor (dummy)...')),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF3B82F6),
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blue.withValues(alpha: 0.12),
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
                                  color: Colors.blue.withValues(alpha: 0.12),
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
                    // Mikrofon tuşu
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF3B82F6),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withValues(alpha: 0.18),
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
                    // Dummy geçmiş listesi
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 0, // Burada geçmiş sayısı 0, örnek için
                      itemBuilder: (context, i) {
                        // Dummy geçmiş kartı
                        return Container(
                          margin: const EdgeInsets.only(bottom: 14),
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF181818) : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: isDark ? Colors.black.withValues(alpha: 0.10) : Colors.blue.withValues(alpha: 0.04),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.medical_services, color: Color(0xFF3B82F6), size: 28),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text('BMC Belde 1993-2013', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                    SizedBox(height: 4),
                                    Text('Motor arızası teşhisi yapıldı.', style: TextStyle(fontSize: 13, color: Colors.grey)),
                                  ],
                                ),
                              ),
                              const Icon(Icons.chevron_right, color: Color(0xFF3B82F6)),
                            ],
                          ),
                        );
                      },
                    ),
                    // Eğer geçmiş yoksa boş durum illüstrasyonu ve metni göster
                    if (true) // geçmiş yoksa
                      Column(
                        children: [
                          const SizedBox(height: 10),
                          Icon(Icons.inbox, size: 54, color: Colors.blueGrey.withValues(alpha: 0.18)),
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
            Positioned(
              top: mq.padding.top + 10,
              right: 10,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: IconButton(
                  key: ValueKey(_isDarkTheme),
                  icon: Icon(_isDarkTheme ? Icons.light_mode : Icons.dark_mode, color: _isDarkTheme ? Colors.yellow : Colors.blueGrey, size: 28),
                  onPressed: () {
                    setState(() => _isDarkTheme = !_isDarkTheme);
                  },
                  tooltip: 'Tema Değiştir',
                ),
              ),
            ),
          ],
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
        floatingActionButton: AnimatedScale(
          scale: 1.0,
          duration: const Duration(milliseconds: 200),
          child: FloatingActionButton.extended(
            onPressed: _showAddDeviceDialog,
            backgroundColor: const Color(0xFF3B82F6),
            foregroundColor: Colors.white,
            icon: const Icon(Icons.add, size: 28),
            label: const Text('Cihaz Ekle', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 8,
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



class HistoryScreen extends StatelessWidget {
  final List<DiagnosisRequest> history;
  const HistoryScreen({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text('Geçmiş', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: history.isEmpty
          ? const Center(
              child: Text(
                'Henüz teşhis geçmişiniz yok.',
                style: TextStyle(color: Color(0xFFB0B0B0), fontSize: 16),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(24),
              itemCount: history.length,
              separatorBuilder: (_, _) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final item = history[index];
                return Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF181818),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${item.brand} ${item.model}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item.problem,
                        style: const TextStyle(color: Color(0xFFB0B0B0)),
                      ),
                    ],
                  ),
                );
              },
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
      color: Colors.white.withValues(alpha: 0.18),
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

// Dummy cihaz eklenme tarihi ve durumu
DateTime getDeviceAddedDate(Device d) => DateTime.now().subtract(Duration(days: 2));
String getDeviceStatus(Device d) => 'Aktif';

class _AnimatedDeviceCard extends StatefulWidget {
  final Device device;
  final DateTime addedDate;
  final String status;
  final VoidCallback onInfo;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  const _AnimatedDeviceCard({required this.device, required this.addedDate, required this.status, required this.onInfo, required this.onEdit, required this.onDelete});

  @override
  State<_AnimatedDeviceCard> createState() => _AnimatedDeviceCardState();
}

class _AnimatedDeviceCardState extends State<_AnimatedDeviceCard> with SingleTickerProviderStateMixin {
  double _scale = 1.0;
  bool _hovering = false;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 80), lowerBound: 0.97, upperBound: 1.0)..value = 1.0;
    _controller.addListener(() {
      setState(() => _scale = _controller.value);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(_) => _controller.reverse();
  void _onTapUp(_) => _controller.forward();
  void _onTapCancel() => _controller.forward();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        onTap: widget.onInfo,
        child: AnimatedScale(
          scale: _scale,
          duration: const Duration(milliseconds: 80),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOut,
            width: 240,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF181818) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: _hovering ? Colors.blue.withValues(alpha: 0.18) : (isDark ? Colors.black.withValues(alpha: 0.18) : Colors.blue.withValues(alpha: 0.08)),
                  blurRadius: _hovering ? 18 : 12,
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
                        widget.device.brand,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: isDark ? Colors.white : Colors.black),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.info_outline, color: Color(0xFF3B82F6)),
                      onPressed: widget.onInfo,
                      tooltip: 'Detay',
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, color: Color(0xFF3B82F6)),
                      onPressed: widget.onEdit,
                      tooltip: 'Düzenle',
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                      onPressed: widget.onDelete,
                      tooltip: 'Sil',
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  widget.device.model,
                  style: TextStyle(fontSize: 14, color: isDark ? Colors.white70 : Colors.black54),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      widget.device.category,
                      style: TextStyle(fontSize: 13, color: isDark ? Colors.blue[200] : Colors.blue[700]),
                    ),
                    const Spacer(),
                    Icon(Icons.circle, size: 10, color: widget.status == 'Aktif' ? Colors.green : Colors.grey),
                    const SizedBox(width: 4),
                    Text(widget.status, style: TextStyle(fontSize: 12, color: widget.status == 'Aktif' ? Colors.green : Colors.grey)),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Eklendi: ${widget.addedDate.day}.${widget.addedDate.month}.${widget.addedDate.year}',
                  style: TextStyle(fontSize: 12, color: isDark ? Colors.white38 : Colors.black38),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AnimatedHintTextField extends StatefulWidget {
  @override
  State<_AnimatedHintTextField> createState() => _AnimatedHintTextFieldState();
}

class _AnimatedHintTextFieldState extends State<_AnimatedHintTextField> with SingleTickerProviderStateMixin {
  final List<String> _hints = [
    'Bir sorun mu var? Yazabilir veya sesli anlatabilirsin.',
    'Örneğin: Motor arızası, yağ değişimi...',
    'Sorununuzu buraya yazın veya mikrofona basılı tutun.',
  ];
  int _hintIndex = 0;
  late AnimationController _controller;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _startHintLoop();
  }

  void _startHintLoop() async {
    while (mounted) {
      await Future.delayed(const Duration(seconds: 3));
      if (!mounted) break;
      _controller.reverse();
      await Future.delayed(const Duration(milliseconds: 700));
      if (!mounted) break;
      setState(() => _hintIndex = (_hintIndex + 1) % _hints.length);
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnim,
      child: TextField(
        decoration: InputDecoration(
          hintText: _hints[_hintIndex],
          border: InputBorder.none,
        ),
      ),
    );
  }
}
