import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../services/api_config.dart';

class ServerConfigDialog {
  static Future<void> show(BuildContext context) async {
    final controller = TextEditingController(text: ApiConfig.baseUrl);

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: const [
            Icon(Icons.dns_rounded, color: AppColors.primary),
            SizedBox(width: 8),
            Text(
              'Konfigurasi Backend',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Alamat URL Backend API:',
              style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: AppColors.textMuted),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'http://localhost:5000/api',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
              style: const TextStyle(fontFamily: 'Poppins', fontSize: 13),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                _chip(ctx, controller, 'Localhost', 'http://127.0.0.1:5000/api'),
                _chip(ctx, controller, 'Android Emu', 'http://10.0.2.2:5000/api'),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await ApiConfig.resetBaseUrl();
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Reset Default', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              if (controller.text.trim().isNotEmpty) {
                await ApiConfig.setBaseUrl(controller.text.trim());
              }
              if (ctx.mounted) Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  static Widget _chip(BuildContext context, TextEditingController controller, String label, String url) {
    return ActionChip(
      label: Text(label, style: const TextStyle(fontSize: 11, fontFamily: 'Poppins')),
      onPressed: () {
        controller.text = url;
      },
      padding: EdgeInsets.zero,
    );
  }
}
