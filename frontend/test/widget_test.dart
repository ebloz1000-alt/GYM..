import 'package:flutter_test/flutter_test.dart';
import 'package:gym_booking_app/main.dart';
import 'package:gym_booking_app/providers_or_bloc/app_state.dart';

void main() {
  testWidgets('boots into onboarding after splash checks', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(GymBookingApp(appState: AppState()));
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    expect(find.text('Book equipment without guessing'), findsOneWidget);
  });
}
