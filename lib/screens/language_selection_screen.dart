import 'package:flutter/material.dart';

import '../constants/colors.dart';

class LanguageSelectionScreen extends StatelessWidget {
  final String selectedLanguage;

  const LanguageSelectionScreen({super.key, required this.selectedLanguage});

  static const _languages = ['English (US)', 'Indonesia (INA)'];

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
                      'Bahasa',
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
            Padding(
              padding: const EdgeInsets.fromLTRB(38, 28, 32, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 6),
                    child: Text(
                      'Suggested',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  for (final language in _languages)
                    _LanguageOption(
                      language: language,
                      isSelected: selectedLanguage == language,
                      onTap: () => Navigator.pop(context, language),
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

class _LanguageOption extends StatelessWidget {
  final String language;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.language,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isSelected,
      label: language,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 24,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  language,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 9,
                    color: Colors.black,
                  ),
                ),
              ),
              Container(
                width: 13,
                height: 13,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : const Color(0xFF8186FF),
                    width: 1.2,
                  ),
                ),
                child: isSelected
                    ? const DecoratedBox(
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
