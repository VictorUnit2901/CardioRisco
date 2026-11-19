import 'package:flutter_test/flutter_test.dart';
import 'package:cardiorisco/main.dart';

void main() {
  testWidgets('CardioRiscoApp inicializa sem erros', (WidgetTester tester) async {
    await tester.pumpWidget(const CardioRiscoApp());
    expect(find.text('CardioRisco'), findsWidgets);
  });
}