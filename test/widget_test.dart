import 'package:flutter_test/flutter_test.dart';

import 'package:aksharaasetu/main.dart';

void main() {
  testWidgets('AksharaaSetu app loads', (WidgetTester tester) async {
    await tester.pumpWidget(const AksharaaSetuApp());

    expect(find.text('AksharaaSetu'), findsOneWidget);
  });
}