import 'package:flutter_test/flutter_test.dart';
import 'package:lab3_padbakery/main.dart';

void main() {
  testWidgets('PAD BAKERY app launches successfully', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const PadBakeryApp());

    expect(find.byType(PadBakeryApp), findsOneWidget);
  });
}
