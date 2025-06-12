import 'package:flutter/material.dart';

class KomposisiNutrisiTable extends StatelessWidget {
  final Map<String, dynamic> komposisi;

  const KomposisiNutrisiTable({super.key, required this.komposisi});

  @override
  Widget build(BuildContext context) {
    final iconMap = {
      'karbohidrat': Icons.local_pizza,
      'protein': Icons.egg_alt,
      'lemak': Icons.oil_barrel,
      'serat': Icons.grass,
      'vitamin': Icons.local_florist,
    };

    final colorMap = {
      'karbohidrat': Colors.orange.shade100,
      'protein': Colors.green.shade100,
      'lemak': Colors.red.shade100,
      'serat': Colors.blue.shade100,
      'vitamin': Colors.purple.shade100,
    };

    final items = komposisi.entries.toList();
    final rows = <TableRow>[];

    for (int i = 0; i < items.length; i += 2) {
      final rowChildren = <Widget>[];

      for (int j = i; j < i + 2; j++) {
        if (j < items.length) {
          final key = items[j].key.toLowerCase();
          final value = items[j].value.toString();
          final icon = iconMap[key] ?? Icons.help_center_rounded;
          final color = colorMap[key] ?? Colors.grey.shade200;

          rowChildren.add(
            _buildNutrientCard(
              icon: icon,
              label: _capitalize(key),
              value: value,
              color: color,
            ),
          );
        } else {
          // Kosong jika data ganjil
          rowChildren.add(const SizedBox());
        }
      }

      rows.add(
        TableRow(
          children: rowChildren.map((child) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: child,
            );
          }).toList(),
        ),
      );
    }

    return Table(
      children: rows,
      columnWidths: const {
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(1),
      },
    );
  }

  Widget _buildNutrientCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(8),
      height: 120,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.deepOrange, size: 28),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  String _capitalize(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1);
  }
}
