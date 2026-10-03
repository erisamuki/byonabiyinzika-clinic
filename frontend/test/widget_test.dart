import 'package:clinic_app/app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows the sign-in screen first', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: ClinicApp()));
    await tester.pumpAndSettle();

    expect(find.text('Sign in'), findsOneWidget);
  });
}
