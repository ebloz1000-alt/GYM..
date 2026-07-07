import 'package:flutter/material.dart';

import '../../core/utils/formatters.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_cards.dart';
import '../../core/widgets/app_charts.dart';
import '../../core/widgets/status_badge.dart';
import '../../models/app_models.dart';
import '../../providers_or_bloc/app_state.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.watch(context);
    final repo = state.repository;
    final activeMembers = repo.users
        .where(
          (user) => user.role == UserRole.member && user.status == 'Active',
        )
        .length;
    final pendingPayments = repo.payments
        .where((payment) => payment.status == PaymentStatus.pending)
        .length;
    return FeaturePage(
      title: 'Admin Dashboard',
      subtitle:
          'Operations, revenue, bookings, users, equipment, trainers, and alerts.',
      children: [
        ResponsiveGrid(
          children: [
            StatCard(
              label: 'Members',
              value: '$activeMembers',
              icon: Icons.groups_outlined,
              change: 'Active',
            ),
            const StatCard(
              label: 'Memberships',
              value: '126',
              icon: Icons.workspace_premium_outlined,
              change: '+16%',
            ),
            StatCard(
              label: 'Revenue',
              value: formatMoney(74200),
              icon: Icons.payments_outlined,
              change: '+12%',
            ),
            StatCard(
              label: 'Today bookings',
              value: '${repo.bookings.length}',
              icon: Icons.event_note_outlined,
              change: 'Confirmed',
            ),
            const StatCard(
              label: 'Equipment usage',
              value: '74%',
              icon: Icons.fitness_center_outlined,
              change: 'Active',
            ),
            const StatCard(
              label: 'Trainer score',
              value: '4.8',
              icon: Icons.star_outline,
              change: '+4%',
            ),
            StatCard(
              label: 'Pending payments',
              value: '$pendingPayments',
              icon: Icons.pending_actions_outlined,
              change: 'Pending',
            ),
            StatCard(
              label: 'Notifications',
              value: '${state.unreadNotifications}',
              icon: Icons.notifications_outlined,
              change: 'Pending',
            ),
          ],
        ),
        const SectionHeader(title: 'Revenue overview'),
        AppCard(child: AppLineChart(points: repo.revenueTrend)),
        const SectionHeader(title: 'Equipment usage'),
        AppCard(child: AppBarChart(points: repo.equipmentUsage)),
        const SectionHeader(title: 'Quick actions'),
        AppCard(
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              AppButton(
                label: 'Add Equipment',
                icon: Icons.add_box_outlined,
                onPressed: () {},
              ),
              AppButton(
                label: 'Assign Trainer',
                icon: Icons.person_add_alt,
                onPressed: () {},
              ),
              AppButton(
                label: 'Export Report',
                icon: Icons.download_outlined,
                onPressed: () {},
              ),
              AppButton(
                label: 'System Logs',
                icon: Icons.article_outlined,
                variant: AppButtonVariant.secondary,
                onPressed: () {},
              ),
            ],
          ),
        ),
        const SectionHeader(title: 'Recent bookings'),
        ...repo.bookings
            .take(3)
            .map((booking) => BookingTile(booking: booking)),
      ],
    );
  }
}

class AdminEquipmentManagementScreen extends StatefulWidget {
  const AdminEquipmentManagementScreen({super.key});

  @override
  State<AdminEquipmentManagementScreen> createState() =>
      _AdminEquipmentManagementScreenState();
}

class _AdminEquipmentManagementScreenState
    extends State<AdminEquipmentManagementScreen> {
  String _query = '';
  String _status = 'All';

  @override
  Widget build(BuildContext context) {
    final equipment = AppScope.watch(context).repository.equipment.where((
      item,
    ) {
      final matchesQuery =
          item.name.toLowerCase().contains(_query.toLowerCase()) ||
          item.category.toLowerCase().contains(_query.toLowerCase());
      final matchesStatus = _status == 'All' || item.status.label == _status;
      return matchesQuery && matchesStatus;
    }).toList();
    return FeaturePage(
      title: 'Equipment Management',
      subtitle:
          'CRUD operations, maintenance, categories, capacity, image upload, and filters.',
      children: [
        TextField(
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.search),
            labelText: 'Search equipment',
          ),
          onChanged: (value) => setState(() => _query = value),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: ['All', 'Available', 'Full', 'Maintenance']
              .map(
                (status) => ChoiceChip(
                  label: Text(status),
                  selected: _status == status,
                  onSelected: (_) => setState(() => _status = status),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 12),
        AppButton(
          label: 'Add Equipment',
          icon: Icons.add_photo_alternate_outlined,
          expand: true,
          onPressed: () => _showEquipmentForm(context),
        ),
        const SectionHeader(title: 'Inventory'),
        ...equipment.map(
          (item) => AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(item.imageIcon),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        item.name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    StatusBadge(label: item.status.label),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${item.category} - Capacity ${item.capacity} - ${item.location}',
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () => _showEquipmentForm(context),
                      icon: const Icon(Icons.edit_outlined),
                      label: const Text('Edit'),
                    ),
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.construction_outlined),
                      label: const Text('Maintenance'),
                    ),
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.delete_outline),
                      label: const Text('Delete'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showEquipmentForm(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.fromLTRB(
          16,
          0,
          16,
          MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(decoration: InputDecoration(labelText: 'Equipment name')),
            SizedBox(height: 12),
            TextField(decoration: InputDecoration(labelText: 'Category')),
            SizedBox(height: 12),
            TextField(decoration: InputDecoration(labelText: 'Capacity')),
            SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.image_outlined),
              title: Text('Upload image'),
              subtitle: Text('Frontend image picker placeholder'),
            ),
          ],
        ),
      ),
    );
  }
}

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  String _query = '';
  UserRole? _role;

  @override
  Widget build(BuildContext context) {
    final users = AppScope.watch(context).repository.users.where((user) {
      final matchesQuery =
          user.name.toLowerCase().contains(_query.toLowerCase()) ||
          user.email.toLowerCase().contains(_query.toLowerCase());
      final matchesRole = _role == null || user.role == _role;
      return matchesQuery && matchesRole;
    }).toList();
    return FeaturePage(
      title: 'User Management',
      subtitle:
          'Members, trainers, admins, filters, role management, suspension, and details.',
      children: [
        TextField(
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.search),
            labelText: 'Search users',
          ),
          onChanged: (value) => setState(() => _query = value),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          children: [
            ChoiceChip(
              label: const Text('All'),
              selected: _role == null,
              onSelected: (_) => setState(() => _role = null),
            ),
            ...UserRole.values.map(
              (role) => ChoiceChip(
                label: Text(role.label),
                selected: _role == role,
                onSelected: (_) => setState(() => _role = role),
              ),
            ),
          ],
        ),
        const SectionHeader(title: 'Users'),
        ...users.map(
          (user) => AppCard(
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: AppAvatar(label: user.avatarLabel),
              title: Text(user.name),
              subtitle: Text('${user.role.label} - ${user.email}'),
              trailing: PopupMenuButton<String>(
                itemBuilder: (context) => const [
                  PopupMenuItem(value: 'details', child: Text('View details')),
                  PopupMenuItem(value: 'suspend', child: Text('Suspend')),
                  PopupMenuItem(value: 'activate', child: Text('Activate')),
                  PopupMenuItem(value: 'delete', child: Text('Delete')),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class AdminBookingManagementScreen extends StatefulWidget {
  const AdminBookingManagementScreen({super.key});

  @override
  State<AdminBookingManagementScreen> createState() =>
      _AdminBookingManagementScreenState();
}

class _AdminBookingManagementScreenState
    extends State<AdminBookingManagementScreen> {
  String _filter = 'All';

  @override
  Widget build(BuildContext context) {
    final state = AppScope.watch(context);
    final bookings = state.repository.bookings.where((booking) {
      return _filter == 'All' || booking.status.label == _filter;
    }).toList();
    return FeaturePage(
      title: 'Booking Management',
      subtitle:
          'All bookings, overrides, cancellation, trainer reassignment, and conflicts.',
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: ['All', 'Pending', 'Confirmed', 'Completed', 'Cancelled']
              .map(
                (status) => ChoiceChip(
                  label: Text(status),
                  selected: _filter == status,
                  onSelected: (_) => setState(() => _filter = status),
                ),
              )
              .toList(),
        ),
        const SectionHeader(title: 'Conflict viewer'),
        const AppCard(
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.warning_amber_outlined),
            title: Text('Two bookings overlap at 18:00 in Cardio Zone A'),
            subtitle: Text(
              'Admin override or trainer reassignment recommended',
            ),
            trailing: StatusBadge(label: 'Pending', compact: true),
          ),
        ),
        const SectionHeader(title: 'All bookings'),
        ...bookings.map(
          (booking) => AppCard(
            child: Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const AppAvatar(
                    label: 'B',
                    icon: Icons.event_available_outlined,
                  ),
                  title: Text(booking.equipmentName),
                  subtitle: Text(
                    '${formatDate(booking.date)} at ${booking.timeSlot}\nTrainer: ${booking.trainerName}',
                  ),
                  isThreeLine: true,
                  trailing: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      StatusBadge(label: booking.status.label, compact: true),
                      const SizedBox(height: 6),
                      StatusBadge(
                        label: booking.paymentStatus.label,
                        compact: true,
                      ),
                    ],
                  ),
                ),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.sync_alt_outlined),
                      label: const Text('Override'),
                    ),
                    OutlinedButton.icon(
                      onPressed: () => state.updateBooking(
                        booking.copyWith(trainerName: 'Maya Wanjiku'),
                      ),
                      icon: const Icon(Icons.person_add_alt),
                      label: const Text('Assign Trainer'),
                    ),
                    OutlinedButton.icon(
                      onPressed: () => state.cancelBooking(booking),
                      icon: const Icon(Icons.cancel_outlined),
                      label: const Text('Cancel'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
