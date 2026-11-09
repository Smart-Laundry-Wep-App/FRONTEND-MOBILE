import 'package:flutter_test/flutter_test.dart';
import 'package:sca_smart_laundry/main.dart';

void main() {
  testWidgets('App renders SCA Smart Laundry login screen', (WidgetTester tester) async {
    await tester.pumpWidget(const SCASmartLaundryApp());
    expect(find.text('SCA Smart Laundry'), findsWidgets);
    expect(find.text('CUCI BERSIH, CEPAT & TEPAT WAKTU'), findsWidgets);
    expect(find.text('Masuk'), findsOneWidget);
  });
}
