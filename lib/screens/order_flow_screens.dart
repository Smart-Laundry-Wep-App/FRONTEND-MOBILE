import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/colors.dart';
import '../services/api_service.dart';
import '../widgets/custom_icons.dart';
import 'dashboard_screen.dart';

class LaundryOrderDraft {
  String service = 'Cuci Kering';
  bool delivery = false;
  int quantity = 1;
  DateTime pickupDate = DateTime.now().add(const Duration(days: 1));
  String pickupTime = '06.00 - 10.00';
  String paymentMethod = 'QRIS';
  int? serviceId;
  String serviceUnit = 'kg';
  int pricePerUnit = 10000;
  String? orderId;
  String? orderCode;
  String? paymentUrl;

  bool get isKiloService => serviceUnit == 'kg';
  String get unit => serviceUnit;
  String get quantityLabel => '$quantity $unit';
  String get quantitySummaryLabel =>
      isKiloService ? 'Berat Total' : 'Jumlah Item';
  String get priceLabel =>
      'Rp. ${pricePerUnit.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match[1]}.')}/$unit';
  int get total => quantity * pricePerUnit;
  String get serviceDisplayName =>
      service == 'Cuci Kering' ? '$service - Reguler' : service;
}

class OrderServiceSelectionScreen extends StatefulWidget {
  const OrderServiceSelectionScreen({super.key, required this.order});

  final LaundryOrderDraft order;

  @override
  State<OrderServiceSelectionScreen> createState() =>
      _OrderServiceSelectionScreenState();
}

class _OrderServiceSelectionScreenState
    extends State<OrderServiceSelectionScreen> {
  static const _defaultServices = [
    (
      name: 'Cuci Kering',
      description: 'Pakaian bersih dan kering, siap digunakan.',
    ),
    (
      name: 'Cuci Express',
      description: 'Laundry cepat untuk kebutuhan mendesak.',
    ),
    (name: 'Cuci Selimut', description: 'Selimut bersih, lembut, dan nyaman.'),
    (
      name: 'Cuci Bed Cover',
      description: 'Perlengkapan tidur bersih dan segar.',
    ),
    (name: 'Cuci Boneka', description: 'Boneka bersih dan nyaman dipeluk.'),
    (name: 'Cuci Sepatu', description: 'Sepatu bersih dengan perawatan tepat.'),
    (name: 'Wenter Pakaian', description: 'Segarkan warna pakaian favoritmu.'),
  ];

  late List<
    ({int? id, String name, String description, String unit, int price})
  >
  _services = _defaultServices
      .map(
        (service) => (
          id: null,
          name: service.name,
          description: service.description,
          unit: service.name == 'Cuci Kering' || service.name == 'Cuci Express'
              ? 'kg'
              : 'pcs',
          price: 10000,
        ),
      )
      .toList();

  @override
  void initState() {
    super.initState();
    _loadServices();
  }

  Future<void> _loadServices() async {
    if (!await ApiService.instance.hasSession) return;
    try {
      final response = await ApiService.instance.fetchServices();
      final rows = response['data'];
      if (rows is! List) return;
      final services = rows.whereType<Map>().map((row) {
        return (
          id: int.tryParse('${row['id']}'),
          name: '${row['name']}',
          description: '${row['description']}',
          unit: '${row['unit']}',
          price: (double.tryParse('${row['price']}') ?? 10000).round(),
        );
      }).toList();
      if (!mounted || services.isEmpty) return;
      setState(() {
        _services = services;
        _applySelectedService();
      });
    } on ApiException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.message)));
      }
    }
  }

  void _applySelectedService() {
    for (final service in _services) {
      if (service.name == widget.order.service) {
        widget.order
          ..serviceId = service.id
          ..serviceUnit = service.unit
          ..pricePerUnit = service.price;
        return;
      }
    }
  }

  void _continue() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => OrderCategoryScreen(order: widget.order),
      ),
    );
  }

  Widget _serviceIcon(int index, Color color) {
    return switch (index) {
      0 || 1 => WashingMachineIcon(size: 26, color: color),
      2 => BlanketIcon(size: 26, color: color),
      3 => BedCoverIcon(size: 26, color: color),
      4 => TeddyBearIcon(size: 26, color: color),
      5 => ShoeIcon(size: 26, color: color),
      _ => PantsIcon(size: 26, color: color),
    };
  }

  @override
  Widget build(BuildContext context) {
    return _OrderPage(
      title: 'Pilih Layanan',
      bottom: _ContinueButton(label: 'Lanjut', onPressed: _continue),
      child: Column(
        children: [
          for (var index = 0; index < _services.length; index++) ...[
            _buildServiceCard(index, _services[index]),
            if (index < _services.length - 1) const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }

  Widget _buildServiceCard(
    int index,
    ({int? id, String name, String description, String unit, int price})
    service,
  ) {
    final selected = widget.order.service == service.name;
    final foregroundColor = selected ? Colors.white : AppColors.primary;

    return Material(
      key: Key('service-option-${service.name}'),
      color: selected ? AppColors.primary : Colors.white,
      borderRadius: BorderRadius.circular(9),
      child: InkWell(
        onTap: () => setState(() {
          widget.order
            ..service = service.name
            ..serviceId = service.id
            ..serviceUnit = service.unit
            ..pricePerUnit = service.price;
        }),
        borderRadius: BorderRadius.circular(9),
        child: Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9),
            border: Border.all(
              color: selected ? AppColors.primary : const Color(0xFFE7E8ED),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.07),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: foregroundColor, width: 1),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: _serviceIcon(index, foregroundColor),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service.name,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: foregroundColor,
                      ),
                    ),
                    Text(
                      service.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 8,
                        color: foregroundColor.withValues(
                          alpha: selected ? 0.9 : 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
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
          const SizedBox(height: 8),
          Text(
            'Layanan: ${widget.order.service}',
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
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
  String? _validationError;

  Future<void> _selectDate() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = await showDatePicker(
      context: context,
      initialDate: widget.order.pickupDate.isBefore(today)
          ? today
          : widget.order.pickupDate,
      firstDate: today,
      lastDate: today.add(const Duration(days: 365)),
    );
    if (date != null) {
      setState(() {
        widget.order.pickupDate = date;
        _validationError = null;
      });
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
        _validationError = null;
      });
    }
  }

  String _formatTime(int hour) => '${hour.toString().padLeft(2, '0')}.00';

  void _continue() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final pickupDay = DateTime(
      widget.order.pickupDate.year,
      widget.order.pickupDate.month,
      widget.order.pickupDate.day,
    );

    if (widget.order.quantity <= 0) {
      setState(() => _validationError = 'Jumlah item/berat harus lebih dari 0.');
      return;
    }
    if (pickupDay.isBefore(today)) {
      setState(() => _validationError = 'Tanggal pengambilan tidak boleh di masa lalu.');
      return;
    }

    setState(() => _validationError = null);
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
          if (_validationError != null)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFFFEBEE),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.redAccent.shade100),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline_rounded,
                      color: Colors.redAccent, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _validationError!,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          const _SectionTitle('Detail Layanan'),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
            decoration: _cardDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.order.serviceDisplayName,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  widget.order.priceLabel,
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
              _SmallValue(widget.order.quantityLabel),
              const SizedBox(width: 14),
              _QuantityButton(
                icon: Icons.remove,
                onPressed: widget.order.quantity > 1
                    ? () => setState(() => widget.order.quantity--)
                    : null,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Text('-', style: TextStyle(color: AppColors.primary)),
              ),
              _QuantityButton(
                icon: Icons.add,
                onPressed: () => setState(() => widget.order.quantity++),
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

class OrderConfirmationScreen extends StatefulWidget {
  const OrderConfirmationScreen({super.key, required this.order});

  final LaundryOrderDraft order;

  @override
  State<OrderConfirmationScreen> createState() =>
      _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> {
  String? _errorMessage;
  bool _isCreatingOrder = false;

  Future<void> _createOrderAndContinue() async {
    if (_isCreatingOrder) return;
    setState(() {
      _isCreatingOrder = true;
      _errorMessage = null;
    });

    try {
      if (!await ApiService.instance.hasSession) {
        if (!mounted) return;
        const msg = 'Silakan masuk untuk membuat pesanan.';
        setState(() => _errorMessage = msg);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(msg)),
        );
        return;
      }
      if (widget.order.orderId == null) {
        final created = await ApiService.instance.createOrder({
          'service_id': widget.order.serviceId,
          'service_name': widget.order.service,
          'delivery': widget.order.delivery,
          'category_type': widget.order.delivery ? 'delivery' : 'pickup_outlet',
          'quantity': widget.order.quantity,
          'pickup_date':
              widget.order.pickupDate.toIso8601String().split('T').first,
          'pickup_time': widget.order.pickupTime,
          'payment_method': widget.order.paymentMethod,
          'promo_code': await ApiService.instance.appliedPromoCode,
        });
        widget.order
          ..orderId = '${created['id']}'
          ..orderCode = '${created['order_code']}';
      }
      if (!mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => OrderPaymentScreen(order: widget.order),
        ),
      );
    } on ApiException catch (error) {
      if (mounted) {
        setState(() => _errorMessage = error.message);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.message)));
      }
    } catch (error) {
      if (mounted) {
        final msg = 'Terjadi kesalahan: $error';
        setState(() => _errorMessage = msg);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(msg)));
      }
    } finally {
      if (mounted) setState(() => _isCreatingOrder = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _OrderPage(
      title: 'Konfirmasi Pesanan',
      bottom: _ContinueButton(
        label: _isCreatingOrder ? 'Memproses...' : 'Bayar Sekarang',
        onPressed: _isCreatingOrder ? null : _createOrderAndContinue,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: _cardDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_errorMessage != null)
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEBEE),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.redAccent.shade100),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline_rounded,
                        color: Colors.redAccent, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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
            Text(
              widget.order.serviceDisplayName,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 12),
            _SummaryRow(
              widget.order.quantitySummaryLabel,
              widget.order.quantityLabel,
            ),
            _SummaryRow(
              'Total harga',
              'Rp ${_formatCurrency(widget.order.total)}',
            ),
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
              _dateLabel(widget.order.pickupDate),
              '${widget.order.pickupTime} WIB',
            ),
            const SizedBox(height: 20),
            _outlinedSummaryRow(
              'Total',
              'Rp ${_formatCurrency(widget.order.total)}',
            ),
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
  bool _isBusy = false;

  Future<void> _ensureOrder() async {
    if (widget.order.orderId != null) return;
    final created = await ApiService.instance.createOrder({
      'service_id': widget.order.serviceId,
      'service_name': widget.order.service,
      'delivery': widget.order.delivery,
      'category_type': widget.order.delivery ? 'delivery' : 'pickup_outlet',
      'quantity': widget.order.quantity,
      'pickup_date': widget.order.pickupDate.toIso8601String().split('T').first,
      'pickup_time': widget.order.pickupTime,
      'payment_method': widget.order.paymentMethod,
      'promo_code': await ApiService.instance.appliedPromoCode,
    });
    widget.order
      ..orderId = '${created['id']}'
      ..orderCode = '${created['order_code']}';
  }

  Future<void> _continue() async {
    if (_isBusy) return;
    setState(() => _isBusy = true);
    try {
      if (!await ApiService.instance.hasSession) {
        throw const ApiException('Silakan masuk untuk membayar pesanan.');
      }
      await _ensureOrder();
      final status = await ApiService.instance.fetchPaymentStatus(
        widget.order.orderId!,
      );
      if (status['payment_status'] == 'paid') {
        if (!mounted) return;
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => PaymentSuccessScreen(order: widget.order),
          ),
        );
        return;
      }

      final payment = await ApiService.instance.createPayment(
        widget.order.orderId!,
        widget.order.paymentMethod.toUpperCase(),
      );
      final url = payment['payment_url'] as String?;
      if (url == null || url.isEmpty) {
        throw const ApiException(
          'Gateway tidak mengembalikan tautan pembayaran.',
        );
      }
      widget.order.paymentUrl = url;
      final opened = await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      );
      if (!mounted) return;
      if (!opened) {
        throw const ApiException('Tautan pembayaran tidak dapat dibuka.');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Selesaikan pembayaran, lalu periksa status pembayaran.',
          ),
        ),
      );
    } on ApiException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.message)));
      }
    } finally {
      if (mounted) setState(() => _isBusy = false);
    }
  }

  Future<void> _refreshPaymentStatus() async {
    if (_isBusy) return;
    setState(() => _isBusy = true);
    try {
      if (widget.order.orderId == null) {
        throw const ApiException('Pesanan belum dibuat.');
      }
      final status = await ApiService.instance.fetchPaymentStatus(
        widget.order.orderId!,
      );
      if (!mounted) return;
      if (status['payment_status'] == 'paid') {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => PaymentSuccessScreen(order: widget.order),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pembayaran belum dikonfirmasi gateway.'),
          ),
        );
      }
    } on ApiException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.message)));
      }
    } finally {
      if (mounted) setState(() => _isBusy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _OrderPage(
      title: 'PEMBAYARAN',
      bottom: _ContinueButton(
        label: 'Lanjut',
        onPressed: _isBusy
            ? null
            : () {
                _continue();
              },
      ),
      child: Column(
        children: [
          SizedBox(
            width: 210,
            child: ElevatedButton(
              onPressed: _isBusy ? null : _refreshPaymentStatus,
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
            onPressed: _isBusy ? null : _continue,
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
            Text(
              order.serviceDisplayName,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 12),
            _SummaryRow(order.quantitySummaryLabel, order.quantityLabel),
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
  final VoidCallback? onPressed;

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
