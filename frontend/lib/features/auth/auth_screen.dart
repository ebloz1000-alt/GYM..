import 'package:flutter/material.dart';

import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_cards.dart';
import '../../core/widgets/app_fields.dart';
import '../../core/widgets/state_views.dart';
import '../../models/app_models.dart';
import '../../providers_or_bloc/app_state.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  UserRole _role = UserRole.member;
  bool _remember = true;
  bool _phoneLogin = false;
  int _tab = 0;

  final _name = TextEditingController();
  final _email = TextEditingController(text: 'amina@example.com');
  final _phone = TextEditingController(text: '+254 711 245 901');
  final _password = TextEditingController(text: 'Password123');
  final _confirm = TextEditingController(text: 'Password123');
  final _otp = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _password.dispose();
    _confirm.dispose();
    _otp.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.watch(context);
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const SizedBox(height: 22),
            Icon(
              Icons.fitness_center_outlined,
              size: 54,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 14),
            Text(
              'Welcome to FitFlow',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            Text(
              'Login, register, or recover access with role-based routing.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 22),
            SegmentedButton<int>(
              segments: const [
                ButtonSegment(
                  value: 0,
                  icon: Icon(Icons.login),
                  label: Text('Login'),
                ),
                ButtonSegment(
                  value: 1,
                  icon: Icon(Icons.person_add),
                  label: Text('Register'),
                ),
                ButtonSegment(
                  value: 2,
                  icon: Icon(Icons.lock_reset),
                  label: Text('Recover'),
                ),
              ],
              selected: {_tab},
              onSelectionChanged: (value) => setState(() => _tab = value.first),
            ),
            const SizedBox(height: 18),
            if (state.isRefreshingSession) const SkeletonLoader(rows: 2),
            if (_tab == 0) _loginCard(state),
            if (_tab == 1) _registrationCard(state),
            if (_tab == 2) _recoveryCard(),
            _securityCard(state),
          ],
        ),
      ),
    );
  }

  Widget _roleSelector() {
    return SegmentedButton<UserRole>(
      segments: const [
        ButtonSegment(
          value: UserRole.member,
          icon: Icon(Icons.person_outline),
          label: Text('Member'),
        ),
        ButtonSegment(
          value: UserRole.trainer,
          icon: Icon(Icons.sports_gymnastics_outlined),
          label: Text('Trainer'),
        ),
        ButtonSegment(
          value: UserRole.admin,
          icon: Icon(Icons.admin_panel_settings_outlined),
          label: Text('Admin'),
        ),
      ],
      selected: {_role},
      onSelectionChanged: (value) => setState(() => _role = value.first),
    );
  }

  Widget _loginCard(AppState state) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'Sign in'),
          _roleSelector(),
          const SizedBox(height: 14),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(_phoneLogin ? 'Phone login' : 'Email login'),
            subtitle: const Text('Switch between email and phone credentials'),
            value: _phoneLogin,
            onChanged: (value) => setState(() => _phoneLogin = value),
          ),
          AppTextField(
            label: _phoneLogin ? 'Phone number' : 'Email address',
            controller: _phoneLogin ? _phone : _email,
            icon: _phoneLogin ? Icons.phone_outlined : Icons.mail_outline,
          ),
          const SizedBox(height: 12),
          AppTextField(
            label: 'Password',
            controller: _password,
            icon: Icons.lock_outline,
            obscure: true,
          ),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            value: _remember,
            onChanged: (value) => setState(() => _remember = value ?? false),
            title: const Text('Remember me'),
            subtitle: const Text('Store JWT for auto login on this device'),
          ),
          AppButton(
            label: 'Login as ${_role.label}',
            icon: Icons.login_outlined,
            expand: true,
            onPressed: state.isRefreshingSession
                ? null
                : () => state.login(_role, remember: _remember),
          ),
        ],
      ),
    );
  }

  Widget _registrationCard(AppState state) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'Create account'),
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
          Text('Select role', style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
          _roleSelector(),
          const SizedBox(height: 12),
          AppTextField(
            label: 'Create password',
            controller: _password,
            obscure: true,
          ),
          const SizedBox(height: 12),
          AppTextField(
            label: 'Confirm password',
            controller: _confirm,
            obscure: true,
          ),
          const SizedBox(height: 14),
          AppButton(
            label: 'Register',
            icon: Icons.person_add_alt_outlined,
            expand: true,
            onPressed: () {
              if (_password.text != _confirm.text) {
                showSuccessSnack(context, 'Passwords must match');
                return;
              }
              state.register(
                name: _name.text,
                email: _email.text,
                phone: _phone.text,
                role: _role,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _recoveryCard() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'Password recovery'),
          AppTextField(
            label: 'Email for OTP',
            controller: _email,
            icon: Icons.mail_outline,
          ),
          const SizedBox(height: 12),
          AppButton(
            label: 'Send OTP',
            icon: Icons.mark_email_read_outlined,
            onPressed: () =>
                showSuccessSnack(context, 'OTP sent to ${_email.text}'),
          ),
          const SizedBox(height: 12),
          AppTextField(
            label: 'Verify OTP',
            controller: _otp,
            icon: Icons.pin_outlined,
          ),
          const SizedBox(height: 12),
          AppTextField(
            label: 'Reset password',
            controller: _password,
            obscure: true,
          ),
          const SizedBox(height: 12),
          AppButton(
            label: 'Reset Password',
            icon: Icons.lock_reset_outlined,
            expand: true,
            onPressed: () =>
                showSuccessSnack(context, 'Password reset flow completed'),
          ),
        ],
      ),
    );
  }

  Widget _securityCard(AppState state) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'Session security'),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.key_outlined),
            title: const Text('JWT status'),
            subtitle: Text(state.jwtStatus),
            trailing: IconButton(
              tooltip: 'Refresh JWT',
              icon: const Icon(Icons.refresh_outlined),
              onPressed: state.refreshJwt,
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.timer_off_outlined),
            title: const Text('Session expiry'),
            subtitle: const Text(
              'Users are redirected to login when tokens expire',
            ),
            trailing: TextButton(
              onPressed: () =>
                  showSuccessSnack(context, 'Session expiry screen previewed'),
              child: const Text('Preview'),
            ),
          ),
        ],
      ),
    );
  }
}
