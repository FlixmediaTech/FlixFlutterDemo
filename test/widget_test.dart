import 'package:flix_flutter_demo/src/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows login screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Flix login'), findsOneWidget);
    expect(find.text('Sign in'), findsOneWidget);
  });
}
