import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

import '../constants/colors.dart';
import '../services/api_config.dart';
import '../services/auth_service.dart';

class GpsTrackingScreen extends StatefulWidget {
  final String orderCode;

  const GpsTrackingScreen({
    super.key,
    this.orderCode = '#12345',
  });

  @override
  State<GpsTrackingScreen> createState() => _GpsTrackingScreenState();
}

class _GpsTrackingScreenState extends State<GpsTrackingScreen> {
  bool _isLoading = true;
  String _orderCode = '#12345';
  String _statusText = 'Sedang dalam perjalanan';
  String _estimatedTime = '15 Menit lagi';
  String _driverName = 'Samuela';
  String _driverPhone = '+62 812 3456 7890';

  // Koordinat Peta
  LatLng _driverPosition = const LatLng(-7.9735, 112.6380);
  LatLng _outletPosition = const LatLng(-7.9826, 112.6308);
  LatLng _customerPosition = const LatLng(-7.9620, 112.6450);
  List<LatLng> _routePoints = [
    const LatLng(-7.9826, 112.6308),
    const LatLng(-7.9780, 112.6340),
    const LatLng(-7.9735, 112.6380),
    const LatLng(-7.9675, 112.6410),
    const LatLng(-7.9620, 112.6450),
  ];

  late final MapController _mapController;

  @override
  void initState() {
    super.initState();
    _orderCode = widget.orderCode;
    _mapController = MapController();
    _fetchTrackingData();
  }

  Future<void> _fetchTrackingData() async {
    try {
      final cleanCode = _orderCode.replaceAll('#', '');
      final url = Uri.parse('${ApiConfig.baseUrl}/tracking/$cleanCode');
      
      final headers = <String, String>{
        'Content-Type': 'application/json',
      };
      if (AuthService.instance.token != null) {
        headers['Authorization'] = 'Bearer ${AuthService.instance.token}';
      }

      final res = await http.get(url, headers: headers).timeout(const Duration(seconds: 5));
      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        if (body['success'] == true && body['data'] != null) {
          final data = body['data'];
          if (mounted) {
            setState(() {
              _statusText = data['current_step'] ?? data['last_status_message'] ?? 'Sedang dalam perjalanan';
              _estimatedTime = data['estimated_delivery'] ?? '15 Menit lagi';
              _driverName = data['driver_name'] ?? 'Samuela';
              _driverPhone = data['driver_phone'] ?? '+62 812 3456 7890';

              if (data['driver_lat'] != null && data['driver_lng'] != null) {
                _driverPosition = LatLng(
                  (data['driver_lat'] as num).toDouble(),
                  (data['driver_lng'] as num).toDouble(),
                );
              }
              if (data['outlet_lat'] != null && data['outlet_lng'] != null) {
                _outletPosition = LatLng(
                  (data['outlet_lat'] as num).toDouble(),
                  (data['outlet_lng'] as num).toDouble(),
                );
              }
              if (data['customer_lat'] != null && data['customer_lng'] != null) {
                _customerPosition = LatLng(
                  (data['customer_lat'] as num).toDouble(),
                  (data['customer_lng'] as num).toDouble(),
                );
              }

              if (data['route_points'] != null && data['route_points'] is List) {
                final list = data['route_points'] as List;
                _routePoints = list.map((pt) {
                  return LatLng(
                    (pt['lat'] as num).toDouble(),
                    (pt['lng'] as num).toDouble(),
                  );
                }).toList();
              }
              _isLoading = false;
            });
            return;
          }
        }
      }
    } catch (_) {
      // Jika backend offline, fallback menggunakan koordinat default
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _recenterMap() {
    _mapController.move(_driverPosition, 14.5);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
          child: Column(
            children: [
              // Top Bar
              Row(
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
                  const Expanded(
                    child: Center(
                      child: Text(
                        'GPS Tracking',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _isLoading ? null : _fetchTrackingData,
                    icon: _isLoading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.primary,
                            ),
                          )
                        : const Icon(Icons.refresh_rounded, color: AppColors.primary),
                    tooltip: 'Muat ulang status',
                  ),
                ],
              ),
              const SizedBox(height: 36),

              // Status Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(22, 20, 22, 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFAFAFA),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pesanan $_orderCode',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        const Icon(
                          Icons.check_circle,
                          size: 22,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 7),
                        Expanded(
                          child: Text(
                            _statusText,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 13),
                    Text(
                      'Estimasi tiba\n$_estimatedTime',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        height: 1.35,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE9ECF2),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.account_circle_rounded,
                            size: 30,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _driverName,
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primary,
                                  ),
                                ),
                                Text(
                                  _driverPhone,
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 10.5,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Menghubungi $_driverName ($_driverPhone)...'),
                                  backgroundColor: AppColors.primary,
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                            visualDensity: VisualDensity.compact,
                            icon: const Icon(
                              Icons.phone_in_talk_rounded,
                              color: AppColors.primary,
                              size: 22,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 36),

              // Interactive Real Map Widget
              AspectRatio(
                aspectRatio: 2.2,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    children: [
                      _buildRealMap(isInteractive: true),
                      // Frame border
                      Positioned.fill(
                        child: IgnorePointer(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColors.primary,
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                      // Recenter button
                      Positioned(
                        left: 8,
                        bottom: 8,
                        child: Material(
                          color: Colors.white,
                          shape: const CircleBorder(),
                          elevation: 3,
                          child: InkWell(
                            onTap: _recenterMap,
                            customBorder: const CircleBorder(),
                            child: const Padding(
                              padding: EdgeInsets.all(6),
                              child: Icon(
                                Icons.my_location_rounded,
                                size: 18,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Fullscreen expand button
                      Positioned(
                        right: 8,
                        bottom: 8,
                        child: Material(
                          color: Colors.white,
                          shape: const CircleBorder(),
                          elevation: 3,
                          child: InkWell(
                            key: const Key('tracking-map-fullscreen'),
                            onTap: () => showDialog<void>(
                              context: context,
                              builder: (_) => _ExpandedTrackingMapDialog(
                                driverPosition: _driverPosition,
                                outletPosition: _outletPosition,
                                customerPosition: _customerPosition,
                                routePoints: _routePoints,
                                driverName: _driverName,
                              ),
                            ),
                            customBorder: const CircleBorder(),
                            child: const Padding(
                              padding: EdgeInsets.all(6),
                              child: Icon(
                                Icons.fullscreen_rounded,
                                size: 20,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Map Legend
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLegendItem(Icons.storefront_rounded, const Color(0xFF00A9D8), 'Outlet SCA'),
                  const SizedBox(width: 14),
                  _buildLegendItem(Icons.delivery_dining_rounded, const Color(0xFF0074C8), 'Kurir'),
                  const SizedBox(width: 14),
                  _buildLegendItem(Icons.home_rounded, const Color(0xFF063A75), 'Tujuan Anda'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLegendItem(IconData icon, Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 12, color: Colors.white),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
      ],
    );
  }

  Widget _buildRealMap({required bool isInteractive}) {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: _driverPosition,
        initialZoom: 14.2,
        interactionOptions: InteractionOptions(
          flags: isInteractive ? InteractiveFlag.all : InteractiveFlag.none,
        ),
      ),
      children: [
        // OpenStreetMap Tile Layer resmi
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.scasmartlaundry.app',
        ),

        // Polylines (Jalur Rute)
        PolylineLayer(
          polylines: [
            Polyline(
              points: _routePoints,
              strokeWidth: 4.5,
              color: const Color(0xFF08A9F2),
              borderColor: Colors.white,
              borderStrokeWidth: 1.5,
            ),
          ],
        ),

        // Markers (Outlet, Driver, Customer)
        MarkerLayer(
          markers: [
            // 1. Outlet Marker
            Marker(
              point: _outletPosition,
              width: 34,
              height: 34,
              child: const _MapPin(
                icon: Icons.storefront_rounded,
                color: Color(0xFF00A9D8),
                label: 'Outlet',
              ),
            ),

            // 2. Driver Marker (Kurir)
            Marker(
              point: _driverPosition,
              width: 38,
              height: 38,
              child: const _MapPin(
                icon: Icons.delivery_dining_rounded,
                color: Color(0xFF0074C8),
                isPulse: true,
              ),
            ),

            // 3. Customer Destination Marker
            Marker(
              point: _customerPosition,
              width: 34,
              height: 34,
              child: const _MapPin(
                icon: Icons.home_rounded,
                color: Color(0xFF063A75),
                label: 'Customer',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MapPin extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String? label;
  final bool isPulse;

  const _MapPin({
    required this.icon,
    required this.color,
    this.label,
    this.isPulse = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2.2),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: isPulse ? 0.45 : 0.25),
            blurRadius: isPulse ? 8 : 4,
            spreadRadius: isPulse ? 2 : 0,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          icon,
          size: isPulse ? 22 : 18,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _ExpandedTrackingMapDialog extends StatelessWidget {
  final LatLng driverPosition;
  final LatLng outletPosition;
  final LatLng customerPosition;
  final List<LatLng> routePoints;
  final String driverName;

  const _ExpandedTrackingMapDialog({
    required this.driverPosition,
    required this.outletPosition,
    required this.customerPosition,
    required this.routePoints,
    required this.driverName,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    final mapWidth = (screenSize.width - 32).clamp(0.0, 600.0);
    final mapHeight = (screenSize.height * 0.70).clamp(320.0, 600.0);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: SizedBox(
        key: const Key('tracking-map-expanded-view'),
        width: mapWidth,
        height: mapHeight,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              FlutterMap(
                options: MapOptions(
                  initialCenter: driverPosition,
                  initialZoom: 14.5,
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.scasmartlaundry.app',
                  ),
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: routePoints,
                        strokeWidth: 5.0,
                        color: const Color(0xFF08A9F2),
                        borderColor: Colors.white,
                        borderStrokeWidth: 2.0,
                      ),
                    ],
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: outletPosition,
                        width: 36,
                        height: 36,
                        child: const _MapPin(
                          icon: Icons.storefront_rounded,
                          color: Color(0xFF00A9D8),
                        ),
                      ),
                      Marker(
                        point: driverPosition,
                        width: 42,
                        height: 42,
                        child: const _MapPin(
                          icon: Icons.delivery_dining_rounded,
                          color: Color(0xFF0074C8),
                          isPulse: true,
                        ),
                      ),
                      Marker(
                        point: customerPosition,
                        width: 36,
                        height: 36,
                        child: const _MapPin(
                          icon: Icons.home_rounded,
                          color: Color(0xFF063A75),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // Close button
              Positioned(
                top: 14,
                right: 14,
                child: Material(
                  color: Colors.white,
                  shape: const CircleBorder(),
                  elevation: 4,
                  child: InkWell(
                    key: const Key('tracking-map-fullscreen-exit'),
                    onTap: () => Navigator.of(context).pop(),
                    customBorder: const CircleBorder(),
                    child: const Padding(
                      padding: EdgeInsets.all(8),
                      child: Icon(
                        Icons.close_rounded,
                        color: AppColors.primary,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
