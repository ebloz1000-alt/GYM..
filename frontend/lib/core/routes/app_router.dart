import 'package:flutter/material.dart';

import '../../features/admin/admin_dashboard.dart';
import '../../features/analytics/analytics_screen.dart';
import '../../features/auth/auth_screen.dart';
import '../../features/booking/booking_screen.dart';
import '../../features/dashboard/dashboard_page.dart';
import '../../features/equipment/equipment_screen.dart';
import '../../features/feedback/feedback_screen.dart';
import '../../features/help/help_screen.dart';
import '../../features/member/member_dashboard.dart';
import '../../features/membership/membership_screen.dart';
import '../../features/notifications/notifications_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/payments/payment_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/reports/reports_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/trainer/trainer_screen.dart';
import '../../models/app_models.dart';
import '../../providers_or_bloc/app_state.dart';
import '../constants/app_constants.dart';
import '../widgets/app_cards.dart';

class AppRouter {
  const AppRouter._();

  static Widget resolve(AppState state) {
    if (!state.isBootstrapped) return const SplashScreen();
    if (!state.hasCompletedOnboarding) return const OnboardingScreen();
    if (state.currentRole == null) return const AuthScreen();
    return RoleShell(role: state.currentRole!);
  }
}

class RoleShell extends StatefulWidget {
  const RoleShell({super.key, required this.role});

  final UserRole role;

  @override
  State<RoleShell> createState() => _RoleShellState();
}

class _RoleShellState extends State<RoleShell> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int _index = 0;

  @override
  void didUpdateWidget(covariant RoleShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.role != widget.role) {
      _index = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.watch(context);
    final destinations = _destinations(widget.role);
    if (_index >= destinations.length) _index = 0;
    final selected = destinations[_index];
    final isWide = MediaQuery.sizeOf(context).width >= 900;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('${AppConstants.appName} - ${widget.role.label}'),
        actions: [
          IconButton(
            tooltip: 'Refresh session',
            onPressed: state.refreshJwt,
            icon: const Icon(Icons.sync_outlined),
          ),
          PopupMenuButton<UserRole>(
            tooltip: 'Switch role',
            icon: const Icon(Icons.manage_accounts_outlined),
            onSelected: state.switchRole,
            itemBuilder: (context) => UserRole.values
                .map(
                  (role) => PopupMenuItem(
                    value: role,
                    child: Text('Open ${role.label} App'),
                  ),
                )
                .toList(),
          ),
        ],
      ),
      drawer: _RoleDrawer(
        selectedIndex: _index,
        destinations: destinations,
        onSelected: (value) {
          setState(() => _index = value);
          Navigator.of(context).maybePop();
        },
      ),
      body: isWide
          ? Row(
              children: [
                NavigationRail(
                  selectedIndex: _index,
                  extended: MediaQuery.sizeOf(context).width >= 1120,
                  scrollable: true,
                  labelType: MediaQuery.sizeOf(context).width >= 1120
                      ? NavigationRailLabelType.none
                      : NavigationRailLabelType.all,
                  onDestinationSelected: (value) =>
                      setState(() => _index = value),
                  destinations: destinations
                      .map(
                        (item) => NavigationRailDestination(
                          icon: Icon(item.icon),
                          selectedIcon: Icon(item.selectedIcon ?? item.icon),
                          label: Text(item.title),
                        ),
                      )
                      .toList(),
                ),
                const VerticalDivider(width: 1),
                Expanded(child: selected.builder(context)),
              ],
            )
          : selected.builder(context),
      bottomNavigationBar: isWide
          ? null
          : _BottomRoleNavigation(
              destinations: destinations,
              selectedIndex: _index,
              onSelected: (value) {
                if (value == 4 && destinations.length > 5) {
                  _scaffoldKey.currentState?.openDrawer();
                  return;
                }
                setState(() => _index = value);
              },
            ),
    );
  }

  List<RoleDestination> _destinations(UserRole role) {
    switch (role) {
      case UserRole.member:
        return [
          RoleDestination('Home', Icons.home_outlined, const DashboardPage()),
          RoleDestination(
            'Booking',
            Icons.event_available_outlined,
            const BookingScreen(),
          ),
          RoleDestination(
            'Equipment',
            Icons.fitness_center_outlined,
            const EquipmentScreen(),
          ),
          RoleDestination(
            'Trainers',
            Icons.sports_gymnastics_outlined,
            const TrainerModuleScreen(),
          ),
          RoleDestination(
            'Membership',
            Icons.workspace_premium_outlined,
            const MembershipScreen(),
          ),
          RoleDestination(
            'Payments',
            Icons.payments_outlined,
            const PaymentScreen(),
          ),
          RoleDestination(
            'Notifications',
            Icons.notifications_none_outlined,
            const NotificationsScreen(),
          ),
          RoleDestination(
            'Feedback',
            Icons.rate_review_outlined,
            const FeedbackScreen(),
          ),
          RoleDestination(
            'Profile',
            Icons.person_outline,
            const ProfileScreen(),
          ),
          RoleDestination(
            'Settings',
            Icons.settings_outlined,
            const SettingsScreen(),
          ),
          RoleDestination('Help', Icons.help_outline, const HelpScreen()),
        ];
      case UserRole.trainer:
        return [
          RoleDestination(
            'Dashboard',
            Icons.dashboard_outlined,
            const TrainerModuleScreen(),
          ),
          RoleDestination(
            'Bookings',
            Icons.event_note_outlined,
            const BookingScreen(),
          ),
          RoleDestination(
            'Notifications',
            Icons.notifications_none_outlined,
            const NotificationsScreen(),
          ),
          RoleDestination(
            'Feedback',
            Icons.rate_review_outlined,
            const FeedbackScreen(),
          ),
          RoleDestination(
            'Payments',
            Icons.payments_outlined,
            const PaymentScreen(),
          ),
          RoleDestination(
            'Profile',
            Icons.person_outline,
            const ProfileScreen(),
          ),
          RoleDestination(
            'Settings',
            Icons.settings_outlined,
            const SettingsScreen(),
          ),
          RoleDestination('Help', Icons.help_outline, const HelpScreen()),
        ];
      case UserRole.admin:
        return [
          RoleDestination(
            'Dashboard',
            Icons.dashboard_outlined,
            const AdminDashboard(),
          ),
          RoleDestination(
            'Equipment',
            Icons.inventory_2_outlined,
            const AdminEquipmentManagementScreen(),
          ),
          RoleDestination(
            'Users',
            Icons.groups_outlined,
            const UserManagementScreen(),
          ),
          RoleDestination(
            'Bookings',
            Icons.event_note_outlined,
            const AdminBookingManagementScreen(),
          ),
          RoleDestination(
            'Reports',
            Icons.summarize_outlined,
            const ReportsScreen(),
          ),
          RoleDestination(
            'Analytics',
            Icons.insights_outlined,
            const AnalyticsScreen(),
          ),
          RoleDestination(
            'Payments',
            Icons.payments_outlined,
            const PaymentScreen(),
          ),
          RoleDestination(
            'Notifications',
            Icons.notifications_none_outlined,
            const NotificationsScreen(),
          ),
          RoleDestination(
            'Profile',
            Icons.person_outline,
            const ProfileScreen(),
          ),
          RoleDestination(
            'Settings',
            Icons.settings_outlined,
            const SettingsScreen(),
          ),
          RoleDestination('Help', Icons.help_outline, const HelpScreen()),
        ];
    }
  }
}

class RoleDestination {
  const RoleDestination(this.title, this.icon, this.page, {this.selectedIcon});

  final String title;
  final IconData icon;
  final IconData? selectedIcon;
  final Widget page;

  WidgetBuilder get builder =>
      (_) => page;
}

class _RoleDrawer extends StatelessWidget {
  const _RoleDrawer({
    required this.selectedIndex,
    required this.destinations,
    required this.onSelected,
  });

  final int selectedIndex;
  final List<RoleDestination> destinations;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.watch(context);
    final user = state.currentUser;
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  AppAvatar(label: user?.avatarLabel ?? 'FF'),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.name ?? AppConstants.appName,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(user?.role.label ?? 'Guest'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            for (var i = 0; i < destinations.length; i++)
              NavigationDrawerDestination(
                icon: Icon(destinations[i].icon),
                selectedIcon: Icon(
                  destinations[i].selectedIcon ?? destinations[i].icon,
                ),
                label: Text(destinations[i].title),
              ).asListTile(
                context: context,
                selected: selectedIndex == i,
                onTap: () => onSelected(i),
              ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout_outlined),
              title: const Text('Logout'),
              onTap: state.logout,
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomRoleNavigation extends StatelessWidget {
  const _BottomRoleNavigation({
    required this.destinations,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<RoleDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final items = destinations.length > 5
        ? [
            ...destinations.take(4),
            const RoleDestination(
              'More',
              Icons.menu_outlined,
              SizedBox.shrink(),
            ),
          ]
        : destinations;
    final navIndex = selectedIndex < 4 ? selectedIndex : items.length - 1;
    return NavigationBar(
      selectedIndex: navIndex,
      onDestinationSelected: onSelected,
      destinations: items
          .map(
            (item) => NavigationDestination(
              icon: Icon(item.icon),
              selectedIcon: Icon(item.selectedIcon ?? item.icon),
              label: item.title,
            ),
          )
          .toList(),
    );
  }
}

extension on NavigationDrawerDestination {
  Widget asListTile({
    required BuildContext context,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return ListTile(
      selected: selected,
      leading: selected ? selectedIcon : icon,
      title: label,
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
    );
  }
}
