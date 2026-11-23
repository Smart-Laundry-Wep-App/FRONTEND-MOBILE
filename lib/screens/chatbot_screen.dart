import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/colors.dart';
import '../services/api_service.dart';
import 'gps_tracking_screen.dart';

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({super.key});

  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  final List<_ChatMessage> _messages = [];

  bool _isSending = false;
  bool _isLoadingHistory = true;

  final List<String> _quickReplies = [
    'Cek Status Pesanan',
    'Informasi Layanan',
    'Informasi Harga',
    'Promo Terbaru',
    'Hubungi Admin',
  ];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _loadHistory() async {
    setState(() => _isLoadingHistory = true);
    if (!await ApiService.instance.hasSession) {
      _loadDefaultMessages();
      setState(() => _isLoadingHistory = false);
      return;
    }

    try {
      final history = await ApiService.instance.fetchChatHistory();
      if (!mounted) return;

      if (history.isEmpty) {
        _loadDefaultMessages();
      } else {
        _messages.clear();
        for (final msg in history) {
          final isBot = msg['sender'] == 'bot' || msg['isFromBot'] == true;
          final hasOrder = msg['has_order_widget'] == 1 || msg['has_order_widget'] == true;
          _messages.add(
            _ChatMessage(
              text: '${msg['message'] ?? ''}',
              fromBot: isBot,
              showOrder: hasOrder,
            ),
          );
        }
      }
    } on ApiException {
      _loadDefaultMessages();
    } finally {
      if (mounted) {
        setState(() => _isLoadingHistory = false);
        _scrollToBottom();
      }
    }
  }

  void _loadDefaultMessages() {
    _messages.clear();
    _messages.addAll([
      const _ChatMessage(
        text: 'Halo! 👋 Selamat datang di SCA Smart Laundry. Ada yang bisa CleanBOT bantu terkait cucian, status pesanan, atau promo spesial hari ini?',
        fromBot: true,
      ),
    ]);
  }

  Future<void> _sendMessage([String? presetText]) async {
    final text = (presetText ?? _messageController.text).trim();
    if (text.isEmpty || _isSending) return;

    if (presetText == null) {
      _messageController.clear();
    }

    setState(() {
      _messages.add(_ChatMessage(text: text, fromBot: false));
      _isSending = true;
    });
    _scrollToBottom();

    try {
      final response = await ApiService.instance.sendChatMessage(text);
      if (!mounted) return;

      Map<String, dynamic>? orderData;
      if (response['order'] is Map<String, dynamic>) {
        orderData = response['order'] as Map<String, dynamic>;
      }

      setState(() {
        _messages.add(
          _ChatMessage(
            text: '${response['message'] ?? ''}',
            fromBot: true,
            showOrder: response['showOrder'] == true,
            orderData: orderData,
          ),
        );
      });
    } on ApiException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.message),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal mengirim pesan. Silakan coba lagi.'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSending = false);
        _scrollToBottom();
      }
    }
  }

  Future<void> _openWhatsApp() async {
    final uri = Uri.parse('https://wa.me/6281234567890');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tidak dapat membuka WhatsApp')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(72),
        child: SafeArea(
          bottom: false,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  customBorder: const CircleBorder(),
                  child: const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Icon(
                      Icons.arrow_back_rounded,
                      color: AppColors.primary,
                      size: 26,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Image.asset(
                  'assets/images/group_45.png',
                  width: 46,
                  height: 46,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CleanBOT',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 15,
                          height: 1.2,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.circle, size: 8, color: Color(0xFF00D632)),
                          SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              'Assisten online SCA Laundry',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 9.5,
                                color: AppColors.textDark,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoadingHistory
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                      strokeWidth: 2.5,
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                    itemCount: _messages.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 24, top: 4),
                            child: DecoratedBox(
                              decoration: const BoxDecoration(
                                color: Color(0xFFF7F8FA),
                                borderRadius: BorderRadius.all(Radius.circular(18)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 6,
                                ),
                                child: Text(
                                  'Hari ini, ${_formatTodayDate()}',
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 9,
                                    color: AppColors.textDark,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                      return _buildMessageRow(_messages[index - 1]);
                    },
                  ),
          ),
          if (_isSending) _buildTypingIndicator(),
          _buildQuickRepliesBar(),
          _buildComposer(),
        ],
      ),
    );
  }

  String _formatTodayDate() {
    final now = DateTime.now();
    const months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return '${now.day} ${months[now.month - 1]}';
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: Row(
        children: [
          Image.asset(
            'assets/images/group_45.png',
            width: 30,
            height: 30,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'CleanBOT sedang mengetik...',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 9.5,
                    fontStyle: FontStyle.italic,
                    color: AppColors.primary.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickRepliesBar() {
    return Container(
      height: 38,
      margin: const EdgeInsets.only(bottom: 6),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        scrollDirection: Axis.horizontal,
        itemCount: _quickReplies.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final label = _quickReplies[index];
          return ActionChip(
            label: Text(
              label,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 9.5,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
            backgroundColor: const Color(0xFFF1F4FD),
            side: const BorderSide(color: Color(0xFF9AA7DD), width: 0.8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            onPressed: () => _sendMessage(label),
          );
        },
      ),
    );
  }

  Widget _buildMessageRow(_ChatMessage message) {
    if (!message.fromBot) {
      return Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 280),
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF4261E8),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(17),
                topRight: Radius.circular(17),
                bottomLeft: Radius.circular(17),
                bottomRight: Radius.circular(3),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              message.text,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 10,
                height: 1.6,
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Image.asset(
            'assets/images/group_45.png',
            width: 34,
            height: 34,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: const BoxConstraints(maxWidth: 290),
                  padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(17),
                      topRight: Radius.circular(17),
                      bottomLeft: Radius.circular(3),
                      bottomRight: Radius.circular(17),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.16),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    message.text,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 10,
                      height: 1.6,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                if (message.showOrder) ...[
                  const SizedBox(height: 10),
                  _buildOrderCard(message.orderData),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _ActionChip(
                        icon: Icons.delivery_dining_outlined,
                        label: 'Lacak Kurir',
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const GpsTrackingScreen(),
                            ),
                          );
                        },
                      ),
                      _ActionChip(
                        icon: Icons.call_outlined,
                        label: 'Hubungi admin',
                        onTap: _openWhatsApp,
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic>? data) {
    final code = data?['order_code'] ?? '#SCA-12345';
    final service = data?['service_name'] ?? 'Cuci Kering';
    final weight = data?['quantity'] != null
        ? '${data!['quantity']}${data['unit'] ?? 'kg'}'
        : '3,7kg';
    final variant = data?['service_variant'] ?? 'cuci kering';
    final est = data?['estimated_delivery'] ?? 'Pukul 15.00 WIB, Hari ini';

    return Container(
      constraints: const BoxConstraints(maxWidth: 300),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.inputBorder, width: 0.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                code.toString().startsWith('#') ? code.toString() : '#$code',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  service.toString(),
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 7.5,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Laundry $variant ($weight)',
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 9.5,
              color: AppColors.primary,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 6),
            child: Divider(height: 1, color: AppColors.inputBorder),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Estimasi selesai:',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 9,
                  color: AppColors.primary,
                ),
              ),
              Text(
                est.toString(),
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildComposer() {
    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        12,
        20,
        14 + MediaQuery.viewPaddingOf(context).bottom,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FB),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F1F1),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            const Icon(Icons.add, size: 26, color: Colors.black54),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: _messageController,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendMessage(),
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 11,
                  color: AppColors.textDark,
                ),
                decoration: const InputDecoration(
                  hintText: 'Ketik pesan untuk CleanBOT',
                  hintStyle: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 10.5,
                    color: AppColors.textHint,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                ),
              ),
            ),
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: _isSending ? null : () => _sendMessage(),
              icon: Icon(
                Icons.send_rounded,
                color: _isSending ? Colors.grey : AppColors.primary,
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatMessage {
  const _ChatMessage({
    required this.text,
    required this.fromBot,
    this.showOrder = false,
    this.orderData,
  });

  final String text;
  final bool fromBot;
  final bool showOrder;
  final Map<String, dynamic>? orderData;
}

class _ActionChip extends StatelessWidget {
  const _ActionChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.textDark,
        side: const BorderSide(color: AppColors.primary),
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
        visualDensity: VisualDensity.compact,
      ),
      icon: Icon(icon, size: 16, color: AppColors.primary),
      label: Text(
        label,
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 9,
          color: AppColors.textDark,
        ),
      ),
    );
  }
}
