import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sca_smart_laundry/main.dart';
import 'package:sca_smart_laundry/screens/dashboard_screen.dart';
import 'package:sca_smart_laundry/screens/gps_tracking_screen.dart';
import 'package:sca_smart_laundry/screens/order_flow_screens.dart';
import 'package:sca_smart_laundry/screens/profile_screen.dart';
import 'package:sca_smart_laundry/widgets/app_bottom_nav_bar.dart';

void main() {
  testWidgets('App renders SCA Smart Laundry login screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const SCASmartLaundryApp());
    expect(find.text('SCA Smart Laundry'), findsWidgets);
    expect(find.text('CUCI BERSIH, CEPAT & TEPAT WAKTU'), findsWidgets);
    expect(find.text('Masuk'), findsOneWidget);
  });

  testWidgets('Order flow selects a service before its category', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: DashboardScreen()));

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    expect(find.text('Pesan Laundry'), findsOneWidget);
    await tester.tap(find.text('Mulai Pesan'));
    await tester.pumpAndSettle();

    expect(find.text('Pilih Layanan'), findsOneWidget);
    await tester.ensureVisible(find.text('Cuci Selimut'));
    await tester.tap(find.text('Cuci Selimut'));
    await tester.tap(find.text('Lanjut'));
    await tester.pumpAndSettle();

    expect(find.text('Pilih Kategori'), findsOneWidget);
    expect(find.text('Layanan: Cuci Selimut'), findsOneWidget);

    await tester.tap(find.text('Lanjut'));
    await tester.pumpAndSettle();

    expect(find.text('Detail Pesanan'), findsOneWidget);
    expect(find.text('Cuci Selimut'), findsOneWidget);
    expect(find.text('Rp. 10.000/pcs'), findsOneWidget);
    expect(find.text('1 pcs'), findsOneWidget);
    expect(find.text('Jumlah'), findsOneWidget);

    await tester.tap(find.text('Lanjut'));
    await tester.pumpAndSettle();
    expect(find.text('Jumlah Item'), findsOneWidget);
    expect(find.text('1 pcs'), findsOneWidget);
  });

  testWidgets('Cuci Kering uses kilogram units', (WidgetTester tester) async {
    final order = LaundryOrderDraft();
    await tester.pumpWidget(
      MaterialApp(home: OrderDetailsScreen(order: order)),
    );

    expect(find.text('Rp. 10.000/kg'), findsOneWidget);
    expect(find.text('1 kg'), findsOneWidget);
    expect(find.text('Cuci Kering - Reguler'), findsOneWidget);
  });

  testWidgets('Tracking map opens fullscreen and returns to tracking', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: GpsTrackingScreen()));

    await tester.ensureVisible(
      find.byKey(const Key('tracking-map-fullscreen')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('tracking-map-fullscreen')));
    await tester.pumpAndSettle();

    final mapSize = tester.getSize(
      find.byKey(const Key('tracking-map-expanded-view')),
    );
    expect(mapSize.width, lessThan(800));
    expect(mapSize.height, lessThan(600));

    await tester.tap(find.byKey(const Key('tracking-map-fullscreen-exit')));
    await tester.pumpAndSettle();

    expect(find.byType(GpsTrackingScreen), findsOneWidget);
  });

  testWidgets('Profile center button returns to dashboard', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: ProfileScreen()));

    await tester.tap(find.byType(HomeBerandaIcon));
    await tester.pumpAndSettle();

    expect(find.byType(DashboardScreen), findsOneWidget);
  });

  testWidgets('Profile tab opens the account and settings screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: DashboardScreen()));

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();

    expect(find.text('Profil Pengguna'), findsOneWidget);
    expect(find.text('Edit Profil dan Informasi'), findsOneWidget);
    expect(find.text('Kelola Notifikasi'), findsOneWidget);
    expect(find.byKey(const Key('profile-avatar')), findsOneWidget);

    await tester.tap(find.text('Bahasa'));
    await tester.pumpAndSettle();

    expect(find.text('Suggested'), findsOneWidget);
    expect(find.text('English (US)'), findsOneWidget);
    expect(find.text('Indonesia (INA)'), findsOneWidget);

    await tester.tap(find.text('English (US)'));
    await tester.pumpAndSettle();
    expect(find.text('EN'), findsOneWidget);

    await tester.tap(find.text('Kelola Notifikasi'));
    await tester.pumpAndSettle();

    expect(find.text('Notifikasi'), findsOneWidget);
    expect(find.text('Umum'), findsOneWidget);
    expect(find.text('Pembaruan Sistem dan Layanan'), findsOneWidget);
    expect(find.text('Lainnya'), findsOneWidget);
    expect(find.text('Permintaan Pembayaran'), findsOneWidget);

    final firstSwitch = tester.getRect(
      find.byKey(const Key('notification-switch-Pembaruan Aplikasi')),
    );
    final secondSwitch = tester.getRect(
      find.byKey(const Key('notification-switch-Pengingat Tagihan')),
    );
    expect(secondSwitch.top - firstSwitch.bottom, greaterThanOrEqualTo(6));

    await tester.tap(find.byKey(const Key('notification-switch-Suara')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('notification-back')));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Kelola Notifikasi'));
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<Semantics>(find.byKey(const Key('notification-switch-Suara')))
          .properties
          .toggled,
      isTrue,
    );

    await tester.tap(find.byKey(const Key('notification-back')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Edit Profil dan Informasi'));
    await tester.pumpAndSettle();

    expect(find.text('Edit Profil'), findsOneWidget);
    expect(find.text('Username'), findsOneWidget);
    expect(find.text('Provinsi'), findsOneWidget);
    expect(find.text('Kota atau Kabupaten'), findsOneWidget);
    expect(find.text('Alamat'), findsOneWidget);

    await tester.enterText(
      find.byKey(const Key('profile-name')),
      'Ardhiva Riyo',
    );
    await tester.tap(find.text('Simpan'));
    await tester.pumpAndSettle();

    expect(find.text('Ardhiva Riyo'), findsOneWidget);
  });
}
