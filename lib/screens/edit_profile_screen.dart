import 'package:flutter/material.dart';

import '../constants/colors.dart';

class ProfileFormData {
  final String name;
  final String username;
  final String email;
  final String phone;
  final String province;
  final String city;
  final String address;

  const ProfileFormData({
    required this.name,
    required this.username,
    required this.email,
    required this.phone,
    required this.province,
    required this.city,
    required this.address,
  });
}

class EditProfileScreen extends StatefulWidget {
  final String name;
  final String username;
  final String email;
  final String phone;
  final String province;
  final String city;
  final String address;

  const EditProfileScreen({
    super.key,
    required this.name,
    required this.username,
    required this.email,
    required this.phone,
    required this.province,
    required this.city,
    required this.address,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  static const Map<String, List<String>> _citiesByProvince = {
    'Jawa Timur': ['Kota Malang', 'Kota Surabaya', 'Kabupaten Malang'],
    'Jawa Barat': ['Kota Bandung', 'Kabupaten Bandung'],
    'Jawa Tengah': ['Kota Semarang', 'Kabupaten Semarang'],
    'DKI Jakarta': ['Jakarta Selatan', 'Jakarta Timur'],
  };

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _usernameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  late String _province;
  late String _city;

  List<String> get _cities => _citiesByProvince[_province]!;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _usernameController = TextEditingController(text: widget.username);
    _emailController = TextEditingController(text: widget.email);
    _phoneController = TextEditingController(
      text: widget.phone.replaceFirst(RegExp(r'^\+62\s*'), ''),
    );
    _addressController = TextEditingController(text: widget.address);
    _province = _citiesByProvince.containsKey(widget.province)
        ? widget.province
        : 'Jawa Timur';
    _city = _cities.contains(widget.city) ? widget.city : _cities.first;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  String? _requiredValue(String? value) {
    if (value == null || value.trim().isEmpty) return 'Wajib diisi';
    return null;
  }

  void _saveProfile() {
    if (!_formKey.currentState!.validate()) return;

    Navigator.of(context).pop(
      ProfileFormData(
        name: _nameController.text.trim(),
        username: _usernameController.text.trim(),
        email: _emailController.text.trim(),
        phone: '+62 ${_phoneController.text.trim()}',
        province: _province,
        city: _city,
        address: _addressController.text.trim(),
      ),
    );
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
                  const Expanded(
                    child: Text(
                      'Edit Profil',
                      textAlign: TextAlign.center,
                      style: TextStyle(
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
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildTextField(
                        key: const Key('profile-name'),
                        label: 'Nama Lengkap',
                        controller: _nameController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Nama lengkap wajib diisi';
                          }
                          if (value.trim().length < 3) {
                            return 'Nama minimal 3 karakter';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      _buildTextField(
                        label: 'Username',
                        controller: _usernameController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Username wajib diisi';
                          }
                          if (value.trim().length < 3) {
                            return 'Username minimal 3 karakter';
                          }
                          if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value.trim())) {
                            return 'Hanya boleh huruf, angka, dan underscore (_)';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      _buildTextField(
                        label: 'Email',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Email wajib diisi';
                          }
                          if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value.trim())) {
                            return 'Format email tidak valid (contoh: user@gmail.com)';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      _buildTextField(
                        label: 'Nomor Telepon',
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        prefix: _buildPhonePrefix(),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Nomor telepon wajib diisi';
                          }
                          final digits = value.replaceAll(RegExp(r'\D'), '');
                          if (digits.length < 8 || digits.length > 13) {
                            return 'Nomor telepon harus 8-13 digit angka';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 5, child: _buildProvinceField()),
                          const SizedBox(width: 10),
                          Expanded(flex: 4, child: _buildCityField()),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildTextField(
                        label: 'Alamat',
                        controller: _addressController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Alamat wajib diisi';
                          }
                          if (value.trim().length < 5) {
                            return 'Alamat minimal 5 karakter';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 52),
                      SizedBox(
                        height: 52,
                        child: FilledButton(
                          onPressed: _saveProfile,
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text(
                            'Simpan',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.6,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    Key? key,
    required String label,
    required TextEditingController controller,
    TextInputType? keyboardType,
    Widget? prefix,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      key: key,
      controller: controller,
      keyboardType: keyboardType,
      validator: validator ?? _requiredValue,
      style: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 12,
        color: AppColors.textDark,
      ),
      decoration: _inputDecoration(label).copyWith(
        prefixIcon: prefix,
        prefixIconConstraints: prefix == null
            ? null
            : const BoxConstraints(minWidth: 0, minHeight: 0),
      ),
    );
  }

  Widget _buildProvinceField() {
    return DropdownButtonFormField<String>(
      initialValue: _province,
      isExpanded: true,
      icon: const Icon(Icons.arrow_drop_down, color: AppColors.primary),
      style: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 11,
        color: AppColors.textDark,
      ),
      decoration: _inputDecoration('Provinsi'),
      items: _citiesByProvince.keys
          .map(
            (province) => DropdownMenuItem(
              value: province,
              child: Text(province, overflow: TextOverflow.ellipsis),
            ),
          )
          .toList(),
      onChanged: (province) {
        if (province == null) return;
        setState(() {
          _province = province;
          _city = _citiesByProvince[province]!.first;
        });
      },
    );
  }

  Widget _buildCityField() {
    return DropdownButtonFormField<String>(
      initialValue: _city,
      isExpanded: true,
      icon: const Icon(Icons.arrow_drop_down, color: AppColors.primary),
      style: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 11,
        color: AppColors.textDark,
      ),
      decoration: _inputDecoration('Kota atau Kabupaten'),
      items: _cities
          .map(
            (city) => DropdownMenuItem(
              value: city,
              child: Text(city, overflow: TextOverflow.ellipsis),
            ),
          )
          .toList(),
      onChanged: (city) {
        if (city != null) setState(() => _city = city);
      },
    );
  }

  Widget _buildPhonePrefix() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 7),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 22,
            height: 14,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFD8D8D8), width: 0.5),
              borderRadius: BorderRadius.circular(1),
            ),
            child: const Column(
              children: [
                Expanded(child: ColoredBox(color: Color(0xFFFF424A))),
                Expanded(child: ColoredBox(color: Colors.white)),
              ],
            ),
          ),
          const SizedBox(width: 7),
          const Text(
            '+62',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 11,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    const borderColor = Color(0xFF8C91E8);

    return InputDecoration(
      labelText: label,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      labelStyle: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 9,
        color: AppColors.textMuted,
      ),
      filled: true,
      fillColor: AppColors.inputFill,
      isDense: true,
      contentPadding: const EdgeInsets.fromLTRB(10, 12, 10, 8),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: borderColor, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.2),
      ),
      errorMaxLines: 2,
      errorStyle: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 10,
        color: Colors.redAccent,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
