import 'package:flutter/material.dart';

import '../constants/colors.dart';
import 'order_flow_screens.dart';

class PesanLaundryScreen extends StatefulWidget {
  const PesanLaundryScreen({super.key});

  @override
  State<PesanLaundryScreen> createState() => _PesanLaundryScreenState();
}

class _PesanLaundryScreenState extends State<PesanLaundryScreen> {
  static const _steps = [
    (
      title: 'Pilih Layanan & Kategori',
      description: 'Satuan, Cuci Komplit, Kiloan',
    ),
    (
      title: 'Detail & Jadwal Pesanan',
      description: 'Atur jam pickup atau delivery',
    ),
    (title: 'Konfirmasi Pesanan', description: 'Review rincian item laundry'),
    (title: 'Pembayaran', description: 'QRIS, E-Wallet atau Tunai'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 34),
              Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    customBorder: const CircleBorder(),
                    child: const CircleAvatar(
                      radius: 12,
                      backgroundColor: AppColors.primary,
                      child: Icon(
                        Icons.arrow_back_rounded,
                        color: Colors.white,
                        size: 17,
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                  const Text(
                    'Pesan Laundry',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Alur Pemesanan',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 6),
              ...List.generate(_steps.length, (index) {
                final step = _steps[index];
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: index == _steps.length - 1 ? 0 : 9,
                  ),
                  child: InkWell(
                    onTap: () => _openOrderStep(index),
                    borderRadius: BorderRadius.circular(14),
                    child: _OrderStepCard(
                      number: index + 1,
                      title: step.title,
                      description: step.description,
                    ),
                  ),
                );
              }),
              const SizedBox(height: 46),
              SizedBox(
                width: double.infinity,
                height: 42,
                child: ElevatedButton(
                  onPressed: () => _openOrderStep(0),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    'Mulai Pesan',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
              const Expanded(child: SizedBox()),
            ],
          ),
        ),
      ),
    );
  }

  void _openOrderStep(int index) {
    final order = LaundryOrderDraft();
    final Widget page = switch (index) {
      0 => OrderCategoryScreen(order: order),
      1 => OrderDetailsScreen(order: order),
      2 => OrderConfirmationScreen(order: order),
      _ => OrderPaymentScreen(order: order),
    };
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }
}

class _OrderStepCard extends StatelessWidget {
  const _OrderStepCard({
    required this.number,
    required this.title,
    required this.description,
  });

  final int number;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary, width: 2),
            ),
            alignment: Alignment.center,
            child: Text(
              '$number',
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(width: 17),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  description,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 8,
                    fontWeight: FontWeight.w400,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
