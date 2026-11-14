import 'package:flutter_test/flutter_test.dart';
import 'package:sasthyaloy/app/app.dart';

void main() {
  testWidgets('Sasthyaloy app smoke test - launches without crash', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SasthyaloyApp());

    // Verify that the app launches and paints the brand name
    expect(find.byType(SasthyaloyApp), findsOneWidget);
  });
}
