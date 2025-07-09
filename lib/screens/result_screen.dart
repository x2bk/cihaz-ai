import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final String response;

  const ResultScreen({Key? key, required this.response}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sonuçlar'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDiagnosisCard(isDark),
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
            ...parsedSections.map((section) => _buildDiagnosisSection(section, isDark)).toList(),
          ],
        ),
      ),
    );
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
            color: Colors.black.withOpacity(0.04),
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

  List<Map<String, String>> _parseDiagnosisResponse(String response) {
    // Parse the response and return a list of sections
    // Each section is a map with 'title' and 'content' keys
    return [];
  }
}
 