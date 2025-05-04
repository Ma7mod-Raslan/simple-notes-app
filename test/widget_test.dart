import 'package:flutter_test/flutter_test.dart';
import 'package:simple_notes_app/main.dart';

void main() {
  testWidgets('App builds and shows welcome text', (WidgetTester tester) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(const SimpleNotesApp());

    // Verify that the welcome text appears.
    expect(find.text('Welcome to your Notes App!'), findsOneWidget);
  });
}
