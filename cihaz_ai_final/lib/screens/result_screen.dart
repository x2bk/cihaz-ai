import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/diagnosis_request.dart';
import '../constants/app_constants.dart';
import 'nearby_services_screen.dart';

class ResultScreen extends StatelessWidget {
  final String response;
  final DiagnosisRequest? request;

  const ResultScreen({super.key, required this.response, this.request});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Teşhis Sonucu', style: theme.appBarTheme.titleTextStyle),
        actions: [
          IconButton(
            icon: Icon(Icons.share, color: theme.appBarTheme.iconTheme?.color),
            onPressed: () => _shareResult(context),
          ),
          IconButton(
            icon: Icon(Icons.copy, color: theme.appBarTheme.iconTheme?.color),
            onPressed: () => _copyToClipboard(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (request != null) ...[
                _buildDeviceInfoCard(request!),
                const SizedBox(height: 16),
              ],
              _buildDiagnosisCard(isDark),
              const SizedBox(height: 16),
              _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDeviceInfoCard(DiagnosisRequest request) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.devices_other, color: Colors.blue[600]),
                const SizedBox(width: 8),
                const Text(
                  'Cihaz Bilgileri',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildInfoRow('Marka', request.brand),
            _buildInfoRow('Model', request.model),
            _buildInfoRow('Yıl', request.year),
          ],
        ),
      ),
    );
  }

  Widget _buildDiagnosisCard(bool isDark) {
    final parsedSections = _parseDiagnosisResponse(response);
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.medical_services, color: Colors.green[600]),
                const SizedBox(width: 8),
                const Text(
                  'Teşhis Raporu',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...parsedSections.map((section) => _buildDiagnosisSection(section, isDark)),
          ],
        ),
      ),
    );
  }

  List<Map<String, String>> _parseDiagnosisResponse(String response) {
    // DeepSeek yanıtını başlık ve içeriklere ayırır
    final lines = response.split('\n');
    final List<Map<String, String>> sections = [];
    String? currentTitle;
    StringBuffer? currentContent;
    for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed.isEmpty) continue;
      // Başlıkları tespit et (örn: - Olası sorunlar ve nedenleri)
      if (trimmed.startsWith('- ')) {
        if (currentTitle != null && currentContent != null) {
          sections.add({'title': currentTitle, 'content': currentContent.toString().trim()});
        }
        currentTitle = trimmed.substring(2);
        currentContent = StringBuffer();
      } else {
        currentContent ??= StringBuffer();
        currentContent.writeln(trimmed);
      }
    }
    if (currentTitle != null && currentContent != null) {
      sections.add({'title': currentTitle, 'content': currentContent.toString().trim()});
    }
    // Eğer hiç başlık yoksa, tüm metni tek kutuda göster
    if (sections.isEmpty) {
      sections.add({'title': 'Teşhis', 'content': response});
    }
    return sections;
  }

  Widget _buildDiagnosisSection(Map<String, String> section, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[isDark ? 900 : 100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[isDark ? 800 : 300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.1 * 255).toInt()),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            section['title'] ?? '',
            style: TextStyle(
              color: Colors.blue[700],
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            section['content'] ?? '',
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black87,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w500)),
          Expanded(
            child: Text(value, style: const TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _showHistory(context),
                icon: Icon(Icons.history, color: isDark ? Colors.white : Colors.black87),
                label: Text('Geçmiş', style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: isDark ? const Color(0xFF444444) : const Color(0xFFE0E0E0),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _newDiagnosis(context),
                icon: const Icon(Icons.add),
                label: const Text('Yeni Teşhis'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => _showNearbyServices(context),
            icon: const Icon(Icons.location_on),
            label: const Text('Yakındaki Servisler'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  void _shareResult(BuildContext context) {
    final shareText =
        '''
💻 Cihaz Teşhis Raporu

${request != null ? '''
📋 Cihaz Bilgileri:
Marka: ${request!.brand}
Model: ${request!.model}
Yıl: ${request!.year}
''' : ''}

🔧 Teşhis Sonucu:
$response

📱 Arabamda Ne Var? uygulamasından paylaşıldı.
    ''';

    Clipboard.setData(ClipboardData(text: shareText));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Sonuç panoya kopyalandı')));
  }

  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: response));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Teşhis sonucu kopyalandı')));
  }

  void _showHistory(BuildContext context) {
    Navigator.pop(context);
  }

  void _newDiagnosis(BuildContext context) {
    Navigator.pop(context);
  }

  void _showNearbyServices(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NearbyServicesScreen()),
    );
  }
}
