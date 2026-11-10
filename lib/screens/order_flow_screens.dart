import 'package:flutter/material.dart';

import '../constants/colors.dart';
import 'dashboard_screen.dart';

class LaundryOrderDraft {
  bool delivery = false;
  int kilograms = 1;
  DateTime pickupDate = DateTime(2026, 9, 3);
  String pickupTime = '06.00 - 10.00';
  String paymentMethod = 'QRIS';

  int get total => kilograms * 10000;
}

class OrderCategoryScreen extends StatefulWidget {
  const OrderCategoryScreen({super.key, required this.order});

  final LaundryOrderDraft order;

  @override
  State<OrderCategoryScreen> createState() => _OrderCategoryScreenState();
}

class _OrderCategoryScreenState extends State<OrderCategoryScreen> {
  void _continue() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => OrderDetailsScreen(order: widget.order),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _OrderPage(
      title: 'Pilih Kategori',
      bottom: _ContinueButton(label: 'Lanjut', onPressed: _continue),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle('Kategori'),
          const SizedBox(height: 16),
          _SelectableCard(
            selected: !widget.order.delivery,
            icon: Icons.home_filled,
            title: 'Ambil Sendiri',
            subtitle: 'Antar & ambil langsung di outlet',
            onTap: () => setState(() => widget.order.delivery = false),
          ),
          const SizedBox(height: 12),
          _SelectableCard(
            selected: widget.order.delivery,
            icon: Icons.delivery_dining_rounded,
            title: 'Delivery',
            subtitle: 'Kurir jemput & antar ke lokasimu',
            onTap: () => setState(() => widget.order.delivery = true),
          ),
        ],
      ),
    );
  }
}

class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen({super.key, required this.order});

  final LaundryOrderDraft order;

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: widget.order.pickupDate,
      firstDate: DateTime(2026),
      lastDate: DateTime(2030),
    );
    if (date != null) {
      setState(() => widget.order.pickupDate = date);
    }
  }

  Future<void> _selectTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 6, minute: 0),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.textDark,
              surface: Colors.white,
            ),
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Colors.white,
              dialBackgroundColor: AppColors.inputFill,
              dialHandColor: AppColors.primary,
              hourMinuteColor: AppColors.inputFill,
              hourMinuteTextColor: AppColors.primary,
              dayPeriodColor: const Color(0xFFE9EAFE),
              dayPeriodTextColor: AppColors.primary,
              entryModeIconColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (time != null) {
      final endHour = (time.hour + 4) % 24;
      setState(() {
        widget.order.pickupTime =
            '${_formatTime(time.hour)} - ${_formatTime(endHour)}';
      });
    }
  }

  String _formatTime(int hour) => '${hour.toString().padLeft(2, '0')}.00';

  void _continue() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => OrderConfirmationScreen(order: widget.order),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _OrderPage(
      title: 'Detail Pesanan',
      bottom: _ContinueButton(label: 'Lanjut', onPressed: _continue),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle('Detail Layanan'),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
            decoration: _cardDecoration(),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cuci Kering - Reguler',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Rp. 10.000/kg',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 26),
          Row(
            children: [
              const Expanded(child: _SectionTitle('Jumlah')),
              _SmallValue('${widget.order.kilograms} kg'),
              const SizedBox(width: 14),
              _QuantityButton(
                icon: Icons.remove,
                onPressed: widget.order.kilograms > 1
                    ? () => setState(() => widget.order.kilograms--)
                    : null,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Text('-', style: TextStyle(color: AppColors.primary)),
              ),
              _QuantityButton(
                icon: Icons.add,
                onPressed: () => setState(() => widget.order.kilograms++),
              ),
            ],
          ),
          const SizedBox(height: 52),
          const _SectionTitle('Jadwal Pengambilan'),
          const SizedBox(height: 14),
          _ScheduleTile(
            icon: Icons.calendar_month_outlined,
            label: _dateLabel(widget.order.pickupDate),
            onTap: _selectDate,
          ),
          const SizedBox(height: 14),
          _ScheduleTile(
            icon: Icons.access_time_rounded,
            label: widget.order.pickupTime,
            onTap: _selectTime,
          ),
        ],
      ),
    );
  }
}

class OrderConfirmationScreen extends StatelessWidget {
  const OrderConfirmationScreen({super.key, required this.order});

  final LaundryOrderDraft order;

  @override
  Widget build(BuildContext context) {
    return _OrderPage(
      title: 'Konfirmasi Pesanan',
      bottom: _ContinueButton(
        label: 'Bayar Sekarang',
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => OrderPaymentScreen(order: order)),
          );
        },
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: _cardDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ringkasan Pesanan',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 19,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Cuci Kering - Reguler',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 12),
            _SummaryRow('Berat Total', '${order.kilograms} kg'),
            _SummaryRow('Total harga', 'Rp ${_formatCurrency(order.total)}'),
            const _SummaryRow('Ongkir', 'Free'),
            const SizedBox(height: 14),
            const Text(
              'Estimasi',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 8),
            _SummaryRow(
              _dateLabel(order.pickupDate),
              '${order.pickupTime} WIB',
            ),
            const SizedBox(height: 20),
            _outlinedSummaryRow('Total', 'Rp ${_formatCurrency(order.total)}'),
            const SizedBox(height: 18),
            _outlinedSummaryRow('Bayar', ''),
          ],
        ),
      ),
    );
  }
}

class OrderPaymentScreen extends StatefulWidget {
  const OrderPaymentScreen({super.key, required this.order});

  final LaundryOrderDraft order;

  @override
  State<OrderPaymentScreen> createState() => _OrderPaymentScreenState();
}

class _OrderPaymentScreenState extends State<OrderPaymentScreen> {
  static const _wallets = ['Gopay', 'Dana', 'ShopeePay', 'OVO'];

  void _continue() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PaymentSuccessScreen(order: widget.order),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _OrderPage(
      title: 'PEMBAYARAN',
      bottom: _ContinueButton(label: 'Lanjut', onPressed: _continue),
      child: Column(
        children: [
          SizedBox(
            width: 210,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Status pembayaran diperbarui.'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text(
                'Refresh status pembayaran',
                style: TextStyle(fontFamily: 'Poppins', fontSize: 11),
              ),
            ),
          ),
          const SizedBox(height: 14),
          GestureDetector(
            onTap: () => setState(() => widget.order.paymentMethod = 'QRIS'),
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primary),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Icon(
                  Icons.qr_code_2_rounded,
                  size: 210,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Scan QRIS untuk membayar',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('QR pembayaran akan tersedia saat checkout.'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            icon: const Icon(Icons.download_rounded),
            label: const Text('Unduh QR Code'),
          ),
          const SizedBox(height: 16),
          const Row(
            children: [
              Expanded(child: Divider()),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  'atau',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Expanded(child: Divider()),
            ],
          ),
          const SizedBox(height: 12),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'E-Wallet',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _wallets.map((wallet) {
              final selected = widget.order.paymentMethod == wallet;
              return GestureDetector(
                onTap: () =>
                    setState(() => widget.order.paymentMethod = wallet),
                child: Column(
                  children: [
                    Container(
                      width: 68,
                      height: 65,
                      decoration: BoxDecoration(
                        color: selected
                            ? const Color(0xFFE9EAFE)
                            : Colors.white,
                        border: Border.all(
                          color: selected
                              ? AppColors.primary
                              : AppColors.inputBorder,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        wallet == 'Gopay'
                            ? Icons.account_balance_wallet_rounded
                            : wallet == 'Dana'
                            ? Icons.account_balance_rounded
                            : wallet == 'OVO'
                            ? Icons.circle_outlined
                            : Icons.wallet_rounded,
                        color: AppColors.primary,
                        size: 30,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      wallet,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen({super.key, required this.order});

  final LaundryOrderDraft order;

  @override
  Widget build(BuildContext context) {
    return _OrderPage(
      title: 'PEMBAYARAN',
      bottom: _ContinueButton(
        label: 'Check Pesanan',
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => PaidOrderSummaryScreen(order: order),
            ),
          );
        },
      ),
      child: Center(
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 245),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 34),
          decoration: _cardDecoration(),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle_outline_rounded,
                size: 78,
                color: Color(0xFF00C853),
              ),
              SizedBox(height: 32),
              Text(
                'Pembayaran berhasil\ndan selesai. Terimakasih',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  height: 1.3,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                  letterSpacing: 0.6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PaidOrderSummaryScreen extends StatelessWidget {
  const PaidOrderSummaryScreen({super.key, required this.order});

  final LaundryOrderDraft order;

  @override
  Widget build(BuildContext context) {
    return _OrderPage(
      title: 'Detail Pesanan',
      bottom: _ContinueButton(
        label: 'Beranda',
        onPressed: () {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const DashboardScreen()),
            (route) => false,
          );
        },
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: _cardDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ringkasan Pesanan',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 19,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Cuci Kering - Reguler',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 12),
            _SummaryRow('Berat Total', '${order.kilograms} kg'),
            _SummaryRow('Total harga', 'Rp ${_formatCurrency(order.total)}'),
            const _SummaryRow('Ongkir', 'Free'),
            const SizedBox(height: 14),
            const Text(
              'Estimasi',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 8),
            _SummaryRow(
              _dateLabel(order.pickupDate),
              '${order.pickupTime} WIB',
            ),
            const SizedBox(height: 18),
            _outlinedSummaryRow('Sedang di proses', ''),
          ],
        ),
      ),
    );
  }
}

class _OrderPage extends StatelessWidget {
  const _OrderPage({
    required this.title,
    required this.child,
    required this.bottom,
  });

  final String title;
  final Widget child;
  final Widget bottom;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 24, 28, 18),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    customBorder: const CircleBorder(),
                    child: const CircleAvatar(
                      radius: 19,
                      backgroundColor: AppColors.primary,
                      child: Icon(
                        Icons.arrow_back_rounded,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 38),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                child: child,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(26, 12, 26, 28),
              child: bottom,
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 17,
        fontWeight: FontWeight.w700,
        color: AppColors.textDark,
      ),
    );
  }
}

class _SelectableCard extends StatelessWidget {
  const _SelectableCard({
    required this.selected,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final bool selected;
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          height: 100,
          padding: const EdgeInsets.symmetric(horizontal: 28),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primary),
                ),
                child: Icon(icon, size: 33, color: AppColors.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 10,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                selected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: AppColors.primary,
                size: 29,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContinueButton extends StatelessWidget {
  const _ContinueButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 66,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 21,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}

class _SmallValue extends StatelessWidget {
  const _SmallValue(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: _cardDecoration(),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  const _QuantityButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      height: 40,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFAFAFA),
          foregroundColor: AppColors.primary,
          elevation: 2,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Icon(icon, size: 18),
      ),
    );
  }
}

class _ScheduleTile extends StatelessWidget {
  const _ScheduleTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(17),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(17),
        child: Container(
          height: 72,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(17),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 32),
              const SizedBox(width: 18),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.primaryLight,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                color: AppColors.primary,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

Widget _outlinedSummaryRow(String label, String value) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    decoration: BoxDecoration(
      border: Border.all(color: AppColors.primary),
      borderRadius: BorderRadius.circular(9),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
      ],
    ),
  );
}

BoxDecoration _cardDecoration() {
  return BoxDecoration(
    color: const Color(0xFFFAFAFA),
    borderRadius: BorderRadius.circular(17),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.12),
        blurRadius: 4,
        offset: const Offset(0, 3),
      ),
    ],
  );
}

String _dateLabel(DateTime date) {
  const months = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];
  return '${date.day} ${months[date.month - 1]} ${date.year}';
}

String _formatCurrency(int amount) {
  final digits = amount.toString();
  final result = StringBuffer();
  for (var index = 0; index < digits.length; index++) {
    if (index > 0 && (digits.length - index) % 3 == 0) {
      result.write('.');
    }
    result.write(digits[index]);
  }
  return result.toString();
}
