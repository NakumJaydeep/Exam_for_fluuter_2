import 'package:flutter_test/flutter_test.dart';
import 'package:app2/main.dart';

void main() {
  testWidgets('Splash screen displays app title and logo', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const BookManagementApp());

    // Verify that splash screen displays the app title.
    expect(find.text('Book Management App'), findsOneWidget);
    expect(find.text('Organize & Explore Your Library'), findsOneWidget);
  });
}
