import 'package:flutter/material.dart';
import 'package:food_nutrition_analysis/komposisi_nutrisi_grid.dart';

class ResultPage extends StatelessWidget {
  final Map<String, dynamic> data;

  const ResultPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final komposisi = data['komposisi_nutrisi'] as Map<String, dynamic>? ?? {};
    final namaMakanan = data['nama_makanan'] ?? 'Tidak diketahui';
    final kehalalan = data['kehalalan'] ?? 'Tidak diketahui';
    final tambahan = data['informasi_tambahan'] ?? '-';

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Hasil Analisis',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
        backgroundColor: Colors.deepOrangeAccent,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildCard(
              icon: Icons.fastfood_rounded,
              title: 'Nama Makanan',
              content: namaMakanan,
              color: Colors.orange.shade50,
            ),
            _buildCard(
              icon: Icons.verified_outlined,
              title: 'Status Kehalalan',
              content: kehalalan,
              color: Colors.green.shade50,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Komposisi Nutrisi:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                KomposisiNutrisiTable(komposisi: komposisi),
              ],
            ),
            _buildCard(
              icon: Icons.info_outline_rounded,
              title: 'Informasi Tambahan',
              content: tambahan,
              color: Colors.purple.shade50,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({
    required IconData icon,
    required String title,
    String? content,
    Widget? contentWidget,
    Color? color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 32, color: Colors.deepOrange),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  contentWidget ??
                      Text(
                        content ?? '-',
                        style: const TextStyle(fontSize: 14),
                      ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
