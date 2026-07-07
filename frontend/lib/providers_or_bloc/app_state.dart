import 'package:flutter/material.dart';

import '../models/app_models.dart';
import '../repositories/mock_repository.dart';

class AppState extends ChangeNotifier {
  AppState();

  final MockRepository repository = MockRepository();

  bool isBootstrapped = false;
  bool hasInternet = true;
  bool hasCompletedOnboarding = false;
  bool rememberMe = false;
  bool isRefreshingSession = false;
  bool notificationsEnabled = true;
  String jwtStatus = 'Not checked';
  String appVersionStatus = 'Ready';

  UserRole? currentRole;
  AppUser? currentUser;
  ThemeMode themeMode = ThemeMode.light;
  String language = 'English';

  Future<void> bootstrap() async {
    if (isBootstrapped) return;
    appVersionStatus = 'Checking version';
    notifyListeners();
    await Future<void>.delayed(const Duration(milliseconds: 450));
    hasInternet = true;
    appVersionStatus = 'Version up to date';
    jwtStatus = 'No saved JWT token';
    await Future<void>.delayed(const Duration(milliseconds: 450));
    isBootstrapped = true;
    notifyListeners();
  }

  Future<void> login(UserRole role, {required bool remember}) async {
    isRefreshingSession = true;
    rememberMe = remember;
    notifyListeners();
    await Future<void>.delayed(const Duration(milliseconds: 650));
    currentRole = role;
    currentUser = repository.userForRole(role);
    jwtStatus = remember ? 'JWT stored and valid' : 'Session token valid';
    isRefreshingSession = false;
    notifyListeners();
  }

  Future<void> register({
    required String name,
    required String email,
    required String phone,
    required UserRole role,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    currentRole = role;
    currentUser = AppUser(
      id: 'new-${DateTime.now().millisecondsSinceEpoch}',
      name: name.isEmpty ? 'New ${role.label}' : name,
      email: email.isEmpty ? 'new-user@example.com' : email,
      phone: phone.isEmpty ? '+254 700 123 456' : phone,
      role: role,
      status: 'Active',
      avatarLabel: _initials(name.isEmpty ? role.label : name),
      joinedAt: DateTime.now(),
    );
    jwtStatus = 'JWT issued after registration';
    notifyListeners();
  }

  Future<void> refreshJwt() async {
    isRefreshingSession = true;
    jwtStatus = 'Refreshing JWT';
    notifyListeners();
    await Future<void>.delayed(const Duration(milliseconds: 550));
    jwtStatus = 'JWT refreshed just now';
    isRefreshingSession = false;
    notifyListeners();
  }

  void completeOnboarding() {
    hasCompletedOnboarding = true;
    notifyListeners();
  }

  void logout() {
    currentRole = null;
    currentUser = null;
    jwtStatus = 'Logged out and token cleared';
    notifyListeners();
  }

  void switchRole(UserRole role) {
    currentRole = role;
    currentUser = repository.userForRole(role);
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) {
    themeMode = mode;
    notifyListeners();
  }

  void setLanguage(String value) {
    language = value;
    notifyListeners();
  }

  void setNotificationsEnabled(bool value) {
    notificationsEnabled = value;
    notifyListeners();
  }

  void addBooking(Booking booking) {
    repository.addBooking(booking);
    notifyListeners();
  }

  void cancelBooking(Booking booking) {
    repository.updateBooking(booking.copyWith(status: BookingStatus.cancelled));
    notifyListeners();
  }

  void updateBooking(Booking booking) {
    repository.updateBooking(booking);
    notifyListeners();
  }

  void addPayment(PaymentRecord payment) {
    repository.addPayment(payment);
    notifyListeners();
  }

  void markNotificationRead(String id) {
    repository.markNotificationRead(id);
    notifyListeners();
  }

  void addFeedback(FeedbackEntry entry) {
    repository.addFeedback(entry);
    notifyListeners();
  }

  void updateProfile(AppUser user) {
    currentUser = user;
    repository.updateUser(user);
    notifyListeners();
  }

  int get unreadNotifications =>
      repository.notifications.where((item) => !item.isRead).length;

  static String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return 'FF';
    if (parts.length == 1) {
      final end = parts.first.length < 2 ? parts.first.length : 2;
      return parts.first.substring(0, end).toUpperCase();
    }
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }
}

class AppScope extends InheritedNotifier<AppState> {
  const AppScope({super.key, required AppState state, required super.child})
    : super(notifier: state);

  static AppState watch(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope was not found in the widget tree.');
    return scope!.notifier!;
  }

  static AppState read(BuildContext context) {
    final element = context.getElementForInheritedWidgetOfExactType<AppScope>();
    final scope = element?.widget as AppScope?;
    assert(scope != null, 'AppScope was not found in the widget tree.');
    return scope!.notifier!;
  }
}
