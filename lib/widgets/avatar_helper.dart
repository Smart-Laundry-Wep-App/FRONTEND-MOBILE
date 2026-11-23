import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../constants/colors.dart';
import '../services/auth_service.dart';

class AvatarHelper {
  static final ImagePicker _picker = ImagePicker();

  /// Menampilkan dialog pemilihan foto (Galeri atau Kamera)
  static Future<String?> pickProfileImage(BuildContext context) async {
    final ImageSource? source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (bottomSheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Text(
                'Ganti Foto Profil',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 18),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE9ECFA),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.photo_library_rounded, color: AppColors.primary),
                ),
                title: const Text(
                  'Pilih dari Galeri / Penyimpanan',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
                subtitle: const Text(
                  'Ambil foto yang sudah tersimpan di perangkat',
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 11, color: AppColors.textMuted),
                ),
                onTap: () => Navigator.pop(bottomSheetContext, ImageSource.gallery),
              ),
              const SizedBox(height: 8),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE9ECFA),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.camera_alt_rounded, color: AppColors.primary),
                ),
                title: const Text(
                  'Ambil Foto dengan Kamera',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
                subtitle: const Text(
                  'Buka kamera dan ambil foto baru sekarang',
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 11, color: AppColors.textMuted),
                ),
                onTap: () => Navigator.pop(bottomSheetContext, ImageSource.camera),
              ),
            ],
          ),
        ),
      ),
    );

    if (source == null) return null;

    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );

      if (image == null) return null;

      final Uint8List bytes = await image.readAsBytes();
      final base64String = 'data:image/jpeg;base64,${base64Encode(bytes)}';

      // Simpan langsung ke AuthService & update profil
      await AuthService.instance.updateProfile(avatarUrl: base64String);

      return base64String;
    } catch (e) {
      debugPrint('[AvatarHelper] Error picking image: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memilih foto: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
      return null;
    }
  }

  /// Widget cerdas untuk render gambar profil (Mendukung Base64, URL Network, atau Asset default)
  static Widget buildAvatarWidget({
    String? avatarSource,
    double size = 76,
    BoxFit fit = BoxFit.cover,
  }) {
    final String? source = avatarSource ?? AuthService.instance.avatarUrl;

    if (source != null && source.isNotEmpty) {
      // 1. Base64 Image
      if (source.startsWith('data:image')) {
        try {
          final base64Data = source.split(',').last;
          final Uint8List bytes = base64Decode(base64Data);
          return Image.memory(
            bytes,
            width: size,
            height: size,
            fit: fit,
            errorBuilder: (_, _, _) => _defaultAssetImage(size, fit),
          );
        } catch (_) {
          return _defaultAssetImage(size, fit);
        }
      }

      // 2. Network URL Image
      if (source.startsWith('http://') || source.startsWith('https://')) {
        return Image.network(
          source,
          width: size,
          height: size,
          fit: fit,
          errorBuilder: (_, _, _) => _defaultAssetImage(size, fit),
        );
      }
    }

    // 3. Fallback Default Asset Image
    return _defaultAssetImage(size, fit);
  }

  static Widget _defaultAssetImage(double size, BoxFit fit) {
    return Image.asset(
      'assets/images/profile_avatar.png',
      width: size,
      height: size,
      fit: fit,
    );
  }
}
