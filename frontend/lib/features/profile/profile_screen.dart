import 'package:flutter/material.dart';

import '../../core/utils/formatters.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_cards.dart';
import '../../core/widgets/app_fields.dart';
import '../../core/widgets/state_views.dart';
import '../../providers_or_bloc/app_state.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final _name = TextEditingController();
  late final _email = TextEditingController();
  late final _phone = TextEditingController();
  final _emergency = TextEditingController(text: '+254 700 100 200');

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final user = AppScope.watch(context).currentUser;
    _name.text = user?.name ?? '';
    _email.text = user?.email ?? '';
    _phone.text = user?.phone ?? '';
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _emergency.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.watch(context);
    final user = state.currentUser;
    if (user == null) {
      return const EmptyStateView(
        title: 'No profile',
        message: 'Login to view your profile.',
      );
    }
    return FeaturePage(
      title: 'Profile',
      subtitle: 'Personal information, avatar, security, and account controls.',
      children: [
        AppCard(
          child: Column(
            children: [
              AppAvatar(label: user.avatarLabel, radius: 38),
              const SizedBox(height: 12),
              Text(user.name, style: Theme.of(context).textTheme.titleLarge),
              Text('${user.role.label} - Joined ${formatDate(user.joinedAt)}'),
              const SizedBox(height: 12),
              AppButton(
                label: 'Upload Avatar',
                icon: Icons.upload_outlined,
                variant: AppButtonVariant.secondary,
                onPressed: () =>
                    showSuccessSnack(context, 'Avatar upload picker opened'),
              ),
            ],
          ),
        ),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(title: 'Edit profile'),
              AppTextField(
                label: 'Full name',
                controller: _name,
                icon: Icons.badge_outlined,
              ),
              const SizedBox(height: 12),
              AppTextField(
                label: 'Email',
                controller: _email,
                icon: Icons.mail_outline,
              ),
              const SizedBox(height: 12),
              AppTextField(
                label: 'Phone',
                controller: _phone,
                icon: Icons.phone_outlined,
              ),
              const SizedBox(height: 12),
              AppTextField(
                label: 'Emergency contact',
                controller: _emergency,
                icon: Icons.emergency_outlined,
              ),
              const SizedBox(height: 12),
              AppButton(
                label: 'Save Profile',
                icon: Icons.save_outlined,
                expand: true,
                onPressed: () {
                  state.updateProfile(
                    user.copyWith(
                      name: _name.text,
                      email: _email.text,
                      phone: _phone.text,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        AppCard(
          child: Column(
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.password_outlined),
                title: const Text('Change password'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () =>
                    showSuccessSnack(context, 'Change password opened'),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  Icons.delete_outline,
                  color: Theme.of(context).colorScheme.error,
                ),
                title: const Text('Delete account'),
                subtitle: const Text(
                  'Requires confirmation and admin retention review',
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => showConfirmationDialog(
                  context,
                  title: 'Delete account',
                  message:
                      'This is a frontend confirmation screen for account deletion.',
                  confirmLabel: 'Delete',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
