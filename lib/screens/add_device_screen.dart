import 'package:flutter/material.dart';
import '../models/device.dart';
import '../services/device_service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../services/notification_service.dart';

class AddDeviceScreen extends StatefulWidget {
  final Device? device;
  const AddDeviceScreen({super.key, this.device});

  @override
  State<AddDeviceScreen> createState() => _AddDeviceScreenState();
}

class _AddDeviceScreenState extends State<AddDeviceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _brandController = TextEditingController();
  final _modelController = TextEditingController();
  final _yearController = TextEditingController();
  final _plateController = TextEditingController();
  
  int _currentStep = 0;
  bool _isDefault = false;
  bool _isLoading = false;
  File? _deviceImage;
  IconData? _selectedIcon;
  final List<IconData> _iconOptions = [
    Icons.devices_other, Icons.phone_android, Icons.laptop_mac, Icons.tablet_mac, Icons.tv, Icons.watch, Icons.headphones, Icons.router
  ];
  DateTime? _warrantyEndDate;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final List<String> _categories = ['Telefon', 'Bilgisayar', 'Tablet', 'TV', 'Diğer'];
  String? _selectedCategory;
  final TextEditingController _imeiController = TextEditingController();
  final TextEditingController _ramController = TextEditingController();
  final TextEditingController _diskController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  List<File> _attachments = [];

  @override
  void initState() {
    super.initState();
    if (widget.device != null) {
      _brandController.text = widget.device!.brand;
      _modelController.text = widget.device!.model;
      _yearController.text = widget.device!.year.toString();
      _plateController.text = widget.device!.plateNumber ?? '';
      _isDefault = widget.device!.isDefault;
      _warrantyEndDate = widget.device!.warrantyEndDate;
      _selectedCategory = widget.device!.category;
      _imeiController.text = widget.device!.imei ?? '';
      _ramController.text = widget.device!.ram ?? '';
      _diskController.text = widget.device!.disk ?? '';
      _noteController.text = widget.device!.notes ?? '';
      _attachments = widget.device!.attachments.map((path) => File(path)).toList();
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked != null) {
      setState(() {
        _deviceImage = File(picked.path);
        _selectedIcon = null;
      });
    }
  }

  Future<void> _pickFromCamera() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.camera, imageQuality: 80);
    if (picked != null) {
      setState(() {
        _deviceImage = File(picked.path);
        _selectedIcon = null;
      });
    }
  }

  Future<void> _pickAttachment() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked != null) {
      setState(() {
        _attachments.add(File(picked.path));
      });
    }
  }

  Future<void> _takeAttachmentPhoto() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.camera, imageQuality: 80);
    if (picked != null) {
      setState(() {
        _attachments.add(File(picked.path));
      });
    }
  }

  void _showIconPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Wrap(
          spacing: 20,
          runSpacing: 20,
          children: _iconOptions.map((icon) => GestureDetector(
            onTap: () {
              setState(() {
                _selectedIcon = icon;
                _deviceImage = null;
              });
              Navigator.pop(context);
            },
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: _selectedIcon == icon ? Theme.of(context).primaryColor.withAlpha(51) : Colors.transparent,
                border: Border.all(
                  color: _selectedIcon == icon ? Theme.of(context).primaryColor : Colors.grey.shade700,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, size: 36, color: Theme.of(context).primaryColor),
            ),
          )).toList(),
        ),
      ),
    );
  }

  Future<void> _pickWarrantyDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _warrantyEndDate ?? now,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 365 * 10)),
      helpText: 'Garanti Bitiş Tarihi Seç',
      locale: const Locale('tr', 'TR'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: const Color(0xFF00D4FF),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _warrantyEndDate = picked;
      });
    }
  }

  void _showQrScanner() async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.black,
        insetPadding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: SizedBox(
          width: 350,
          height: 400,
          child: _QrScannerWidget(
            onScanned: (value) {
              Navigator.pop(context, value);
            },
          ),
        ),
      ),
    );
    if (result != null && result.isNotEmpty) {
      setState(() {
        _plateController.text = result;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: const [
              Icon(Icons.check_circle, color: Color(0xFF00D4FF)),
              SizedBox(width: 8),
              Text('QR koddan seri numarası alındı!'),
            ],
          ),
          backgroundColor: Colors.green.shade700,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.error, color: Colors.red),
              SizedBox(width: 8),
              Text('Geçerli bir QR kod okunamadı.'),
            ],
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        title: Text(widget.device != null ? 'Cihazı Düzenle' : 'Yeni Cihaz Ekle', style: theme.appBarTheme.titleTextStyle),
        centerTitle: true,
        iconTheme: theme.appBarTheme.iconTheme,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          children: [
            const SizedBox(height: 12),
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF00D4FF), Color(0xFF0099CC)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF00D4FF).withAlpha(28),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: _deviceImage != null
                          ? Image.file(_deviceImage!, fit: BoxFit.cover)
                          : Icon(
                              _selectedIcon ?? Icons.devices_other,
                              size: 60,
                              color: Colors.white,
                            ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withAlpha(24),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                            child: const Icon(Icons.photo, color: Color(0xFF00D4FF), size: 22),
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: _pickFromCamera,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withAlpha(24),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                            child: const Icon(Icons.camera_alt, color: Color(0xFF00D4FF), size: 22),
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: _showIconPicker,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withAlpha(24),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                            child: const Icon(Icons.widgets, color: Color(0xFF00D4FF), size: 22),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Stepper(
              type: StepperType.vertical,
              currentStep: _currentStep,
              onStepContinue: () {
                if (_currentStep < 4) {
                  setState(() {
                    _currentStep += 1;
                  });
                } else {
                  _saveDevice();
                }
              },
              onStepCancel: () {
                if (_currentStep > 0) {
                  setState(() {
                    _currentStep -= 1;
                  });
                }
              },
              controlsBuilder: (context, details) {
                return Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: Row(
                    children: [
                      if (_currentStep > 0)
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: details.onStepCancel,
                            icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF00D4FF)),
                            label: const Text('Geri', style: TextStyle(fontWeight: FontWeight.bold)),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFF00D4FF)),
                              foregroundColor: const Color(0xFF00D4FF),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      if (_currentStep > 0) const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _isLoading ? null : details.onStepContinue,
                          icon: Icon(_currentStep == 3 ? Icons.check_circle : Icons.arrow_forward_ios, color: Colors.white),
                          label: _isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : Text(_currentStep == 3 ? (widget.device != null ? 'Güncelle' : 'Kaydet') : 'İleri', style: const TextStyle(fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00D4FF),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 4,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              steps: [
                Step(
                  title: Row(
                    children: const [
                      Icon(Icons.category, color: Color(0xFF00D4FF)),
                      SizedBox(width: 8),
                      Text('Cihaz Kategorisi', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Cihazınızın türünü seçin. Kategoriye göre ek alanlar açılır.',
                        style: TextStyle(color: Color(0xFFB0B0B0), fontSize: 15),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: _selectedCategory,
                        items: _categories.map((cat) => DropdownMenuItem(
                          value: cat,
                          child: Text(cat, style: const TextStyle(color: Colors.white)),
                        )).toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectedCategory = val;
                          });
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFF181818),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.all(16),
                          hintText: 'Kategori seçin',
                          hintStyle: const TextStyle(color: Color(0xFF888888)),
                        ),
                        dropdownColor: const Color(0xFF181818),
                        style: const TextStyle(color: Colors.white),
                        icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF00D4FF)),
                      ),
                      const SizedBox(height: 16),
                      if (_selectedCategory == 'Telefon')
                        TextFormField(
                          controller: _imeiController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.sim_card, color: Color(0xFF00D4FF)),
                            hintText: 'IMEI numarası (isteğe bağlı)',
                            hintStyle: const TextStyle(color: Color(0xFF888888)),
                            filled: true,
                            fillColor: const Color(0xFF181818),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.all(16),
                          ),
                        ),
                      if (_selectedCategory == 'Bilgisayar') ...[
                        TextFormField(
                          controller: _ramController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.memory, color: Color(0xFF00D4FF)),
                            hintText: 'RAM (örn: 16 GB)',
                            hintStyle: const TextStyle(color: Color(0xFF888888)),
                            filled: true,
                            fillColor: const Color(0xFF181818),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.all(16),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _diskController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.sd_storage, color: Color(0xFF00D4FF)),
                            hintText: 'Disk (örn: 512 GB SSD)',
                            hintStyle: const TextStyle(color: Color(0xFF888888)),
                            filled: true,
                            fillColor: const Color(0xFF181818),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.all(16),
                          ),
                        ),
                      ],
                    ],
                  ),
                  isActive: _currentStep >= 0,
                ),
                Step(
                  title: Row(
                    children: const [
                      Icon(Icons.precision_manufacturing, color: Color(0xFF00D4FF)),
                      SizedBox(width: 8),
                      Text('Cihaz Markası', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Cihazınızın markasını girin',
                        style: TextStyle(color: Color(0xFFB0B0B0), fontSize: 15),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _brandController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.precision_manufacturing, color: Color(0xFF00D4FF)),
                          hintText: 'Örn: Apple, Samsung, Lenovo...',
                          hintStyle: const TextStyle(color: Color(0xFF888888)),
                          filled: true,
                          fillColor: const Color(0xFF181818),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.all(18),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Marka gerekli';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                  isActive: _currentStep >= 1,
                ),
                Step(
                  title: Row(
                    children: const [
                      Icon(Icons.devices_other, color: Color(0xFF00D4FF)),
                      SizedBox(width: 8),
                      Text('Cihaz Modeli', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Model adını girin (ör: iPhone 14 Pro, Galaxy S23, ThinkPad X1)',
                        style: TextStyle(color: Color(0xFFB0B0B0), fontSize: 15),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _modelController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.devices_other, color: Color(0xFF00D4FF)),
                          hintText: 'Örn: iPhone 14 Pro, Galaxy S23, ThinkPad X1...',
                          hintStyle: const TextStyle(color: Color(0xFF888888)),
                          filled: true,
                          fillColor: const Color(0xFF181818),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.all(18),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Model gerekli';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                  isActive: _currentStep >= 1,
                ),
                Step(
                  title: Row(
                    children: const [
                      Icon(Icons.calendar_today, color: Color(0xFF00D4FF)),
                      SizedBox(width: 8),
                      Text('Üretim Yılı', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Cihazınızın üretim yılını girin',
                        style: TextStyle(color: Color(0xFFB0B0B0), fontSize: 15),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _yearController,
                        style: const TextStyle(color: Colors.white),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.calendar_today, color: Color(0xFF00D4FF)),
                          hintText: 'Örn: 2023',
                          hintStyle: const TextStyle(color: Color(0xFF888888)),
                          filled: true,
                          fillColor: const Color(0xFF181818),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.all(18),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Yıl gerekli';
                          }
                          final year = int.tryParse(value);
                          if (year == null || year < 2000 || year > DateTime.now().year + 1) {
                            return 'Geçerli bir yıl girin (2000 ve sonrası)';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                  isActive: _currentStep >= 2,
                ),
                Step(
                  title: Row(
                    children: const [
                      Icon(Icons.confirmation_number, color: Color(0xFF00D4FF)),
                      SizedBox(width: 8),
                      Text('Seri No (Opsiyonel)', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Cihazınızın seri numarasını girin (isteğe bağlı)',
                        style: TextStyle(color: Color(0xFFB0B0B0), fontSize: 15),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _plateController,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.confirmation_number, color: Color(0xFF00D4FF)),
                                hintText: 'Örn: SN123456789',
                                hintStyle: const TextStyle(color: Color(0xFF888888)),
                                filled: true,
                                fillColor: const Color(0xFF181818),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.all(18),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: _showQrScanner,
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFF232A34),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: const Color(0xFF00D4FF), width: 1.2),
                              ),
                              child: const Icon(Icons.qr_code_scanner, color: Color(0xFF00D4FF), size: 28),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF232A34),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Checkbox(
                              value: _isDefault,
                              onChanged: (value) {
                                setState(() {
                                  _isDefault = value ?? false;
                                });
                              },
                              activeColor: const Color(0xFF00D4FF),
                            ),
                            const Expanded(
                              child: Text(
                                'Bu cihazı varsayılan cihaz olarak ayarla',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Varsayılan cihaz olarak ayarlarsanız, teşhis ve bildirimlerde bu cihaz öncelikli olur.',
                        style: TextStyle(color: Color(0xFFB0B0B0), fontSize: 13),
                      ),
                    ],
                  ),
                  isActive: _currentStep >= 3,
                ),
                Step(
                  title: Row(
                    children: const [
                      Icon(Icons.verified_user, color: Color(0xFF00D4FF)),
                      SizedBox(width: 8),
                      Text('Garanti Bitiş Tarihi', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Cihazınızın garanti bitiş tarihini seçin. Garanti bitişine yakın otomatik bildirim alırsınız.',
                        style: TextStyle(color: Color(0xFFB0B0B0), fontSize: 15),
                      ),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: _pickWarrantyDate,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
                          decoration: BoxDecoration(
                            color: const Color(0xFF181818),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFF00D4FF), width: 1.2),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.event, color: Color(0xFF00D4FF)),
                              const SizedBox(width: 12),
                              Text(
                                _warrantyEndDate != null
                                    ? '${_warrantyEndDate!.day.toString().padLeft(2, '0')}.${_warrantyEndDate!.month.toString().padLeft(2, '0')}.${_warrantyEndDate!.year}'
                                    : 'Tarih seçin',
                                style: const TextStyle(color: Colors.white, fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  isActive: _currentStep >= 4,
                ),
                Step(
                  title: Row(
                    children: const [
                      Icon(Icons.note_alt, color: Color(0xFF00D4FF)),
                      SizedBox(width: 8),
                      Text('Cihaz Notu & Belgeler', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Cihazınızla ilgili notlarınızı ve önemli belgeleri ekleyin (ör. fatura, garanti belgesi).',
                        style: TextStyle(color: Color(0xFFB0B0B0), fontSize: 15),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _noteController,
                        style: const TextStyle(color: Colors.white),
                        maxLines: 3,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.note, color: Color(0xFF00D4FF)),
                          hintText: 'Cihaz hakkında notlarınızı yazın...',
                          hintStyle: const TextStyle(color: Color(0xFF888888)),
                          filled: true,
                          fillColor: const Color(0xFF181818),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.all(18),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          ElevatedButton.icon(
                            onPressed: _pickAttachment,
                            icon: const Icon(Icons.attach_file),
                            label: const Text('Belge Ekle'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF00D4FF),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton.icon(
                            onPressed: _takeAttachmentPhoto,
                            icon: const Icon(Icons.camera_alt),
                            label: const Text('Fotoğraf Çek'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF232A34),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (_attachments.isNotEmpty)
                        SizedBox(
                          height: 80,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: _attachments.length,
                            separatorBuilder: (_, __) => const SizedBox(width: 10),
                            itemBuilder: (context, index) {
                              final file = _attachments[index];
                              return Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.file(file, width: 80, height: 80, fit: BoxFit.cover),
                                  ),
                                  Positioned(
                                    top: 2,
                                    right: 2,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _attachments.removeAt(index);
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.black.withAlpha(179),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(Icons.close, color: Colors.white, size: 18),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                  isActive: _currentStep >= 5,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveDevice() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      if (widget.device != null) {
        // Güncelleme
        final updated = widget.device!.copyWith(
          brand: _brandController.text,
          model: _modelController.text,
          year: int.tryParse(_yearController.text) ?? widget.device!.year,
          plateNumber: _plateController.text,
          isDefault: _isDefault,
          warrantyEndDate: _warrantyEndDate,
          imei: _imeiController.text.trim().isEmpty ? null : _imeiController.text.trim(),
          ram: _ramController.text.trim().isEmpty ? null : _ramController.text.trim(),
          disk: _diskController.text.trim().isEmpty ? null : _diskController.text.trim(),
          notes: _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
          attachments: _attachments.map((file) => file.path).toList(),
        );
        await DeviceService.updateDevice(updated);
        if (_warrantyEndDate != null) {
          await NotificationService.scheduleWarrantyNotification(
            id: updated.id.hashCode,
            deviceName: updated.brand + ' ' + updated.model,
            warrantyEndDate: _warrantyEndDate!,
          );
        }
        Navigator.pop(context, true);
      } else {
        // Yeni ekleme
        final newDevice = Device(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          category: _selectedCategory ?? 'Diğer',
          brand: _brandController.text,
          model: _modelController.text,
          year: int.parse(_yearController.text),
          plateNumber: _plateController.text,
          isDefault: _isDefault,
          warrantyEndDate: _warrantyEndDate,
          imei: _imeiController.text.trim().isEmpty ? null : _imeiController.text.trim(),
          ram: _ramController.text.trim().isEmpty ? null : _ramController.text.trim(),
          disk: _diskController.text.trim().isEmpty ? null : _diskController.text.trim(),
          notes: _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
          attachments: _attachments.map((file) => file.path).toList(),
        );
        await DeviceService.addDevice(newDevice);
        if (_warrantyEndDate != null) {
          await NotificationService.scheduleWarrantyNotification(
            id: newDevice.id.hashCode,
            deviceName: newDevice.brand + ' ' + newDevice.model,
            warrantyEndDate: _warrantyEndDate!,
          );
        }
        Navigator.pop(context, true);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bir hata oluştu')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }
}

class _QrScannerWidget extends StatefulWidget {
  final void Function(String) onScanned;
  const _QrScannerWidget({required this.onScanned});

  @override
  State<_QrScannerWidget> createState() => _QrScannerWidgetState();
}

class _QrScannerWidgetState extends State<_QrScannerWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.qr_code_scanner,
              color: Colors.white,
              size: 100,
            ),
            const SizedBox(height: 20),
            const Text(
              'QR Tarama Özelliği\nGeçici Olarak Devre Dışı',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00D4FF),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: const Text('Geri Dön'),
            ),
          ],
        ),
      ),
    );
  }
} 