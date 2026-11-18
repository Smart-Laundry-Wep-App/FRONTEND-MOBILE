import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../services/language_service.dart';

class NotificationSettingsScreen extends StatefulWidget {
  final Map<String, bool> initialSettings;
  final ValueChanged<Map<String, bool>> onSettingsChanged;

  const NotificationSettingsScreen({
    super.key,
    required this.initialSettings,
    required this.onSettingsChanged,
  });

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  static const Map<String, bool> _defaultSettings = {
    'Notifikasi Umum': true,
    'Suara': false,
    'Getar': true,
    'Pembaruan Aplikasi': true,
    'Pengingat Tagihan': true,
    'Promosi': true,
    'Diskon Tersedia': true,
    'Permintaan Pembayaran': true,
    'Layanan Baru Tersedia': true,
    'Tips Baru Tersedia': true,
  };

  static const List<_NotificationGroupData> _groups = [
    _NotificationGroupData('Umum', ['Notifikasi Umum', 'Suara', 'Getar']),
    _NotificationGroupData('Pembaruan Sistem dan Layanan', [
      'Pembaruan Aplikasi',
      'Pengingat Tagihan',
      'Promosi',
      'Diskon Tersedia',
      'Permintaan Pembayaran',
    ]),
    _NotificationGroupData('Lainnya', [
      'Layanan Baru Tersedia',
      'Tips Baru Tersedia',
    ]),
  ];

  late final Map<String, bool> _settings = {
    ..._defaultSettings,
    ...widget.initialSettings,
  };

  void _updateSetting(String label, bool value) {
    setState(() => _settings[label] = value);
    widget.onSettingsChanged(Map<String, bool>.of(_settings));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 18, 24, 0),
              child: Row(
                children: [
                  Material(
                    color: AppColors.primary,
                    shape: const CircleBorder(),
                    child: InkWell(
                      key: const Key('notification-back'),
                      onTap: () => Navigator.pop(context),
                      customBorder: const CircleBorder(),
                      child: const SizedBox(
                        width: 38,
                        height: 38,
                        child: Icon(
                          Icons.arrow_back_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      LanguageService.tr('notif_title'),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 38),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                child: Column(
                  children: [
                    for (var index = 0; index < _groups.length; index++) ...[
                      _buildGroup(_groups[index]),
                      if (index < _groups.length - 1)
                        const SizedBox(height: 10),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroup(_NotificationGroupData group) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(10, 7, 9, 6),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF8993FF), width: 1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 3),
            child: Text(
              group.title,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ),
          for (final label in group.options)
            _buildOption(label, _settings[label] ?? false),
        ],
      ),
    );
  }

  Widget _buildOption(String label, bool isEnabled) {
    return SizedBox(
      height: 26,
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 9.5,
                color: Colors.black,
              ),
            ),
          ),
          Semantics(
            key: Key('notification-switch-$label'),
            button: true,
            toggled: isEnabled,
            label: label,
            value: isEnabled ? 'Aktif' : 'Nonaktif',
            onTap: () => _updateSetting(label, !isEnabled),
            child: GestureDetector(
              onTap: () => _updateSetting(label, !isEnabled),
              child: SizedBox(
                width: 33,
                height: 19,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: isEnabled
                        ? AppColors.primary
                        : const Color(0xFFD4D4D4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: AnimatedAlign(
                    duration: const Duration(milliseconds: 150),
                    alignment: isEnabled
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      width: 13,
                      height: 13,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationGroupData {
  final String title;
  final List<String> options;

  const _NotificationGroupData(this.title, this.options);
}
