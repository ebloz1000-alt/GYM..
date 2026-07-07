import 'package:flutter/material.dart';

import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';
import 'providers_or_bloc/app_state.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(GymBookingApp(appState: AppState()));
}

class GymBookingApp extends StatelessWidget {
  const GymBookingApp({super.key, required this.appState});

  final AppState appState;

  @override
  Widget build(BuildContext context) {
    return AppScope(
      state: appState,
      child: AnimatedBuilder(
        animation: appState,
        builder: (context, _) {
          return MaterialApp(
            title: 'Gym Booking',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: appState.themeMode,
            home: AppRouter.resolve(appState),
          );
        },
      ),
    );
  }
}
