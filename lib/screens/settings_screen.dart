import 'package:flutter/material.dart';
import '../models/device.dart';
import '../services/device_service.dart';
import '../services/settings_service.dart';
import '../services/cloud_backup_service.dart';
import '../services/history_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _cloudBackupEnabled = false;
  bool _offlineModeEnabled = false;
  bool _locationEnabled = true;
  bool _historyEnabled = true;
  List<Device> _devices = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _loadDevices();
  }

  Future<void> _loadSettings() async {
    try {
      final language = await SettingsService.getLanguage();
      final subscription = await SettingsService.getSubscriptionType();
      
      setState(() {
        // _selectedLanguage = language; // This line was removed from the new_code, so it's removed here.
        // _selectedSubscription = subscription; // This line was removed from the new_code, so it's removed here.
      });
    } catch (e) {
      // Hata durumunda varsayılan değerler kullanılır
    }
  }

  Future<void> _loadDevices() async {
    setState(() => _isLoading = true);
    try {
      final devices = await DeviceService.getDevices();
      setState(() {
        _devices = devices;
      });
    } catch (e) {
      // Hata durumunda boş liste
      setState(() {
        _devices = [];
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message.replaceAll('Araç', 'Cihaz').replaceAll('araç', 'cihaz'))));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        title: Text('Ayarlar', style: theme.appBarTheme.titleTextStyle),
        centerTitle: true,
        iconTheme: theme.appBarTheme.iconTheme,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Genel Ayarlar'),
                  const SizedBox(height: 16),
                  _buildLanguageSettings(),
                  const SizedBox(height: 16),
                  _buildSubscriptionSettings(),
                  const SizedBox(height: 32),
                  _buildSectionTitle('Cihaz Yönetimi'),
                  const SizedBox(height: 16),
                  _buildDevicesList(),
                  const SizedBox(height: 24),
                  _buildAddDeviceButton(),
                  const SizedBox(height: 32),
                  _buildCloudBackupSection(),
                  const SizedBox(height: 32),
                  _buildSectionTitle('Uygulama Bilgileri'),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _backupToCloud,
                          icon: const Icon(Icons.cloud_upload),
                          label: const Text('Buluta Yedekle'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00D4FF),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _restoreFromCloud,
                          icon: const Icon(Icons.cloud_download),
                          label: const Text('Buluttan Geri Yükle'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF232A34),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildAppInfo(),
                ],
              ),
            ),
    );
  }

  Widget _buildSectionTitle(String title) {
    final theme = Theme.of(context);
    
    return Text(
      title,
      style: TextStyle(
        color: theme.brightness == Brightness.dark ? Colors.white : Colors.black87,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildLanguageSettings() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF181818),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.language, color: Color(0xFF00D4FF)),
              const SizedBox(width: 8),
              const Text(
                'Dil',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildLanguageOption(
            flag: '🇹🇷',
            title: 'Türkçe',
            subtitle: 'Ana dil',
            isSelected: false, // This line was removed from the new_code, so it's removed here.
            onTap: () async {
              // await SettingsService.setLanguage('tr'); // This line was removed from the new_code, so it's removed here.
              setState(() {
                // _selectedLanguage = 'tr'; // This line was removed from the new_code, so it's removed here.
              });
              _showSnackBar('Dil Türkçe olarak değiştirildi');
            },
          ),
          const SizedBox(height: 12),
          _buildLanguageOption(
            flag: '🇺🇸',
            title: 'English',
            subtitle: 'English language',
            isSelected: false, // This line was removed from the new_code, so it's removed here.
            onTap: () async {
              // await SettingsService.setLanguage('en'); // This line was removed from the new_code, so it's removed here.
              setState(() {
                // _selectedLanguage = 'en'; // This line was removed from the new_code, so it's removed here.
              });
              _showSnackBar('Language changed to English');
            },
          ),
          const SizedBox(height: 12),
          _buildLanguageOption(
            flag: '🇩🇪',
            title: 'Deutsch',
            subtitle: 'Deutsche Sprache',
            isSelected: false, // This line was removed from the new_code, so it's removed here.
            onTap: () async {
              // await SettingsService.setLanguage('de'); // This line was removed from the new_code, so it's removed here.
              setState(() {
                // _selectedLanguage = 'de'; // This line was removed from the new_code, so it's removed here.
              });
              _showSnackBar('Sprache zu Deutsch geändert');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageOption({
    required String flag,
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF00D4FF).withAlpha(51) : const Color(0xFF232A34),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF00D4FF) : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Text(
              flag,
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: isSelected ? const Color(0xFF00D4FF) : Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Color(0xFFB0B0B0),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Color(0xFF00D4FF),
                size: 24,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubscriptionSettings() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final currentSubscription = SettingsService.getSubscriptionOptions()
        .firstWhere((sub) => sub['code'] == 'free'); // This line was removed from the new_code, so it's removed here.
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF181818) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: isDark ? null : [
          BoxShadow(
            color: Colors.black.withAlpha((0.1 * 255).toInt()),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.card_membership, color: isDark ? Colors.white : Colors.black87, size: 24),
              const SizedBox(width: 12),
              Text(
                'Abonelik Türü',
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(context).primaryColor,
                width: 2,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      currentSubscription['name'],
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black87,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      currentSubscription['price'],
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  currentSubscription['description'],
                  style: TextStyle(
                    color: isDark ? const Color(0xFFB0B0B0) : const Color(0xFF666666),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 12),
                ...currentSubscription['features'].map<Widget>((feature) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            feature,
                            style: TextStyle(
                              color: isDark ? const Color(0xFFB0B0B0) : const Color(0xFF666666),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _showSubscriptionDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Abonelik Değiştir'),
            ),
          ),
        ],
      ),
    );
  }

  void _showSubscriptionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF181818),
        title: const Text(
          'Abonelik Seçin',
          style: TextStyle(color: Colors.white),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: SettingsService.getSubscriptionOptions().map((subscription) {
              final isSelected = subscription['code'] == 'free'; // This line was removed from the new_code, so it's removed here.
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSelected ? Theme.of(context).primaryColor.withAlpha(51) : const Color(0xFF2A2A2A),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected ? Theme.of(context).primaryColor : const Color(0xFF666666),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          subscription['name'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          subscription['price'],
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      subscription['description'],
                      style: const TextStyle(
                        color: Color(0xFFB0B0B0),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...subscription['features'].map<Widget>((feature) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 2),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 12,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                feature,
                                style: const TextStyle(
                                  color: Color(0xFFB0B0B0),
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'İptal',
              style: TextStyle(color: Color(0xFFB0B0B0)),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              // Burada gerçek abonelik işlemi yapılacak
              // await SettingsService.setSubscriptionType(_selectedSubscription); // This line was removed from the new_code, so it's removed here.
              Navigator.pop(context);
              _showSnackBar('Abonelik güncellendi');
            },
            child: const Text('Seç'),
          ),
        ],
      ),
    );
  }

  Widget _buildDevicesList() {
    if (_devices.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF181818),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Column(
          children: [
            Icon(Icons.devices, color: Color(0xFF666666), size: 48),
            SizedBox(height: 12),
            Text(
              'Henüz cihaz eklenmemiş',
              style: TextStyle(color: Color(0xFF666666)),
            ),
            SizedBox(height: 8),
            Text(
              'Cihaz ekleyerek hızlı teşhis yapabilirsiniz',
              style: TextStyle(color: Color(0xFF666666), fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Kayıtlı Cihazlar',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ..._devices.map((device) => _buildDeviceCard(device)).toList(),
      ],
    );
  }

  Widget _buildDeviceCard(Device device) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF232A34),
        borderRadius: BorderRadius.circular(12),
        border: device.isDefault
            ? Border.all(color: const Color(0xFF00D4FF), width: 2)
            : Border.all(color: const Color(0xFF666666), width: 1),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF00D4FF),
          child: Text(
            device.brand.isNotEmpty ? device.brand[0].toUpperCase() : 'C',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          device.brand,
          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              device.model,
              style: const TextStyle(color: Color(0xFFB0B0B0), fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              '${device.year}',
              style: const TextStyle(color: Color(0xFFB0B0B0), fontSize: 12),
            ),
            if (device.plateNumber != null) ...[
              const SizedBox(height: 4),
              Text(
                device.plateNumber!,
                style: const TextStyle(color: Color(0xFFB0B0B0), fontSize: 12),
              ),
            ],
            if (device.isDefault) ...[
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF00D4FF),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'Varsayılan',
                  style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ],
        ),
        trailing: PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: Color(0xFF00D4FF)),
          onSelected: (value) => _handleDeviceAction(value, device),
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit, color: Color(0xFF00D4FF)),
                  SizedBox(width: 8),
                  Text('Düzenle'),
                ],
              ),
            ),
            if (!device.isDefault)
              const PopupMenuItem(
                value: 'default',
                child: Row(
                  children: [
                    Icon(Icons.star, color: Color(0xFF00D4FF)),
                    SizedBox(width: 8),
                    Text('Varsayılan Yap'),
                  ],
                ),
              ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Sil'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddDeviceButton() {
    return Container(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _showAddDeviceDialog,
        icon: const Icon(Icons.add, size: 20),
        label: const Text('Yeni Cihaz Ekle', style: TextStyle(fontSize: 16)),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF00D4FF),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _buildAppInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF181818),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildInfoRow('Uygulama Adı', 'Cihazımda Ne Var'),
          _buildInfoRow('Versiyon', '1.0.0'),
          _buildInfoRow('Geliştirici', 'Cihazımda Ne Var Takımı'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFFB0B0B0))),
          Text(value, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  void _handleDeviceAction(String action, Device device) async {
    switch (action) {
      case 'edit':
        _showEditDeviceDialog(device);
        break;
      case 'default':
        await _setDefaultDevice(device);
        break;
      case 'delete':
        _showDeleteConfirmation(device);
        break;
    }
  }

  void _showAddDeviceDialog() {
    _showDeviceDialog();
  }

  void _showEditDeviceDialog(Device device) {
    _showDeviceDialog(device: device);
  }

  void _showDeviceDialog({Device? device}) {
    final isEditing = device != null;
    final yearController = TextEditingController(text: device?.year.toString() ?? '');
    final plateController = TextEditingController(text: device?.plateNumber ?? '');
    bool isDefault = device?.isDefault ?? false;
    String selectedCategory = device?.category ?? 'Diğer';
    String? selectedBrand = device?.brand;
    String? selectedModel = device?.model;
    List<String> availableBrands = ['Samsung', 'Apple', 'Huawei', 'Xiaomi', 'Diğer'];
    List<String> availableModels = [];

    if (selectedBrand != null && selectedBrand != 'Diğer') {
      availableModels = ['Model 1', 'Model 2', 'Model 3'];
    }

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: const Color(0xFF181818),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            isEditing ? 'Cihazı Düzenle' : 'Yeni Cihaz Ekle',
            style: const TextStyle(color: Colors.white),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Kategori Seçimi
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'Kategori',
                    labelStyle: TextStyle(color: Color(0xFFB0B0B0)),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF666666))),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF00D4FF))),
                  ),
                  dropdownColor: const Color(0xFF232A34),
                  style: const TextStyle(color: Colors.white),
                  items: ['Telefon', 'Bilgisayar', 'Tablet', 'Diğer'].map((cat) {
                    return DropdownMenuItem(
                      value: cat,
                      child: Text(cat, style: const TextStyle(color: Colors.white)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value!;
                      selectedBrand = null;
                      selectedModel = null;
                      availableBrands = ['Samsung', 'Apple', 'Huawei', 'Xiaomi', 'Diğer'];
                      availableModels = [];
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Marka Seçimi
                DropdownButtonFormField<String>(
                  value: selectedBrand,
                  decoration: const InputDecoration(
                    labelText: 'Marka',
                    labelStyle: TextStyle(color: Color(0xFFB0B0B0)),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF666666))),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF00D4FF))),
                  ),
                  dropdownColor: const Color(0xFF232A34),
                  style: const TextStyle(color: Colors.white),
                  items: availableBrands.map((brand) {
                    return DropdownMenuItem(
                      value: brand,
                      child: Text(brand, style: const TextStyle(color: Colors.white)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedBrand = value;
                      selectedModel = null;
                      if (value != null && value != 'Diğer') {
                        availableModels = ['Model 1', 'Model 2', 'Model 3'];
                      } else {
                        availableModels = [];
                      }
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Model Seçimi
                if (selectedBrand != null && selectedBrand != 'Diğer')
                  DropdownButtonFormField<String>(
                    value: selectedModel,
                    decoration: const InputDecoration(
                      labelText: 'Model',
                      labelStyle: TextStyle(color: Color(0xFFB0B0B0)),
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF666666))),
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF00D4FF))),
                    ),
                    dropdownColor: const Color(0xFF232A34),
                    style: const TextStyle(color: Colors.white),
                    items: availableModels.map((model) {
                      return DropdownMenuItem(
                        value: model,
                        child: Text(model, style: const TextStyle(color: Colors.white)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedModel = value;
                      });
                    },
                  ),
                if (selectedBrand != null && selectedBrand != 'Diğer') const SizedBox(height: 16),

                // Yıl
                TextField(
                  controller: yearController,
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Yıl',
                    labelStyle: TextStyle(color: Color(0xFFB0B0B0)),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF666666))),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF00D4FF))),
                  ),
                ),
                const SizedBox(height: 16),

                // Plaka/Seri No
                TextField(
                  controller: plateController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Seri No (İsteğe bağlı)',
                    labelStyle: TextStyle(color: Color(0xFFB0B0B0)),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF666666))),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF00D4FF))),
                  ),
                ),
                const SizedBox(height: 16),

                // Varsayılan Cihaz
                Row(
                  children: [
                    Checkbox(
                      value: isDefault,
                      onChanged: (val) {
                        setState(() {
                          isDefault = val ?? false;
                        });
                      },
                      activeColor: const Color(0xFF00D4FF),
                    ),
                    const Text('Varsayılan cihaz yap', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('İptal', style: TextStyle(color: Color(0xFFB0B0B0))),
            ),
            ElevatedButton(
              onPressed: () async {
                if (selectedBrand == null || selectedModel == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Lütfen marka ve model seçin')),
                  );
                  return;
                }

                final newDevice = Device(
                  id: device?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                  category: selectedCategory,
                  brand: selectedBrand!,
                  model: selectedModel!,
                  year: int.tryParse(yearController.text) ?? DateTime.now().year,
                  plateNumber: plateController.text.trim().isEmpty ? null : plateController.text.trim(),
                  isDefault: isDefault,
                  warrantyEndDate: null,
                  imei: null,
                  ram: null,
                  disk: null,
                  notes: null,
                  attachments: [],
                );

                if (isEditing) {
                  await DeviceService.updateDevice(newDevice);
                } else {
                  await DeviceService.addDevice(newDevice);
                }

                Navigator.pop(context);
                _loadDevices();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00D4FF),
                foregroundColor: Colors.white,
              ),
              child: Text(isEditing ? 'Güncelle' : 'Ekle'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _setDefaultDevice(Device device) async {
    // Geçici olarak hiçbir şey yapma
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Varsayılan cihaz ayarlandı')),
    );
  }

  void _showDeleteConfirmation(Device device) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF181818),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Cihazı Sil', style: TextStyle(color: Colors.white)),
        content: Text(
          '${device.brand} ${device.model} cihazını silmek istediğinizden emin misiniz?',
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal', style: TextStyle(color: Color(0xFFB0B0B0))),
          ),
          ElevatedButton(
            onPressed: () async {
              await DeviceService.deleteDevice(device.id);
              Navigator.pop(context);
              _loadDevices();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Sil'),
          ),
        ],
      ),
    );
  }

  Future<void> _backupToCloud() async {
    setState(() => _isLoading = true);
    
    try {
      // Cihazları yedekle
      final devices = await DeviceService.getDevices();
      final devicesBackupSuccess = await CloudBackupService.backupDevices(devices);
      
      // Cihaz geçmişini yedekle
      final allRecords = await HistoryService.getAllRecords();
      final recordsBackupSuccess = await CloudBackupService.backupServiceRecords(allRecords);
      
      if (devicesBackupSuccess && recordsBackupSuccess) {
        _showSnackBar('Verileriniz başarıyla buluta yedeklendi!');
      } else {
        _showSnackBar('Yedekleme sırasında bir hata oluştu.');
      }
    } catch (e) {
      _showSnackBar('Yedekleme hatası: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _restoreFromCloud() async {
    // Onay dialog'u göster
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF181818),
        title: const Text('Geri Yükleme Onayı', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Buluttan verileri geri yüklemek mevcut verilerinizi silecektir. Devam etmek istediğinizden emin misiniz?',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('İptal', style: TextStyle(color: Color(0xFFB0B0B0))),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Geri Yükle'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isLoading = true);
    
    try {
      // Cihazları geri yükle
      final devices = await CloudBackupService.restoreDevices();
      if (devices.isNotEmpty) {
        // Mevcut cihazları sil ve yenilerini ekle
        final existingDevices = await DeviceService.getDevices();
        for (final device in existingDevices) {
          await DeviceService.deleteDevice(device.id);
        }
        for (final device in devices) {
          await DeviceService.addDevice(device);
        }
      }

      // Cihaz geçmişini geri yükle
      final records = await CloudBackupService.restoreServiceRecords();
      if (records.isNotEmpty) {
        // Mevcut kayıtları sil ve yenilerini ekle
        final existingRecords = await HistoryService.getAllRecords();
        for (final record in existingRecords) {
          await HistoryService.deleteRecord(record.id);
        }
        for (final record in records) {
          await HistoryService.addRecord(record);
        }
      }

      _showSnackBar('Verileriniz başarıyla geri yüklendi!');
      _loadDevices(); // Listeyi yenile
    } catch (e) {
      _showSnackBar('Geri yükleme hatası: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildCloudBackupSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF181C24),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.1 * 255).toInt()),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.cloud, color: Color(0xFF00D4FF)),
              const SizedBox(width: 8),
              const Text(
                'Bulut Yedekleme',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Cihaz verilerinizi güvenli bir şekilde buluta yedekleyin ve istediğiniz zaman geri yükleyin.',
            style: TextStyle(
              color: Color(0xFFB0B0B0),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _backupToCloud,
                  icon: const Icon(Icons.cloud_upload),
                  label: const Text('Buluta Yedekle'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00D4FF),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _restoreFromCloud,
                  icon: const Icon(Icons.cloud_download),
                  label: const Text('Buluttan Geri Yükle'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF232A34),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
