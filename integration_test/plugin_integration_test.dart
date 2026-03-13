import 'package:flix_inpage/flix_inpage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('plugin API is available', (WidgetTester tester) async {
    final controller = FlixInpageHtmlViewController();
    expect(controller, isA<FlixInpageHtmlViewController>());
  });
}
