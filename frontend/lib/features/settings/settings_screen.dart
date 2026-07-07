import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_cards.dart';
import '../../providers_or_bloc/app_state.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.watch(context);
    return FeaturePage(
      title: 'Settings',
      subtitle:
          'Theme, language, notifications, privacy, security, about, terms, help, and logout.',
      children: [
        AppCard(
          child: Column(
            children: [
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Dark theme'),
                value: state.themeMode == ThemeMode.dark,
                onChanged: (value) => state.setThemeMode(
                  value ? ThemeMode.dark : ThemeMode.light,
                ),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Notifications'),
                value: state.notificationsEnabled,
                onChanged: state.setNotificationsEnabled,
              ),
              DropdownButtonFormField<String>(
                initialValue: state.language,
                decoration: const InputDecoration(labelText: 'Language'),
                items: const [
                  DropdownMenuItem(value: 'English', child: Text('English')),
                  DropdownMenuItem(value: 'Swahili', child: Text('Swahili')),
                  DropdownMenuItem(value: 'French', child: Text('French')),
                ],
                onChanged: (value) {
                  if (value != null) state.setLanguage(value);
                },
              ),
            ],
          ),
        ),
        const SectionHeader(title: 'Privacy and security'),
        AppCard(
          child: Column(
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.privacy_tip_outlined),
                title: const Text('Privacy settings'),
                subtitle: const Text(
                  'Data export, consent, visibility, and retention',
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.security_outlined),
                title: const Text('Security options'),
                subtitle: Text(state.jwtStatus),
                trailing: IconButton(
                  tooltip: 'Refresh JWT',
                  icon: const Icon(Icons.refresh_outlined),
                  onPressed: state.refreshJwt,
                ),
              ),
            ],
          ),
        ),
        const SectionHeader(title: 'About'),
        const AppCard(
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.info_outline),
            title: Text(AppConstants.appName),
            subtitle: Text(
              'Terms, help, app information, and version ${AppConstants.appVersion}',
            ),
          ),
        ),
        AppButton(
          label: 'Logout',
          icon: Icons.logout_outlined,
          variant: AppButtonVariant.danger,
          expand: true,
          onPressed: state.logout,
        ),
      ],
    );
  }
}
