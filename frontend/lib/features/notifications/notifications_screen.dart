import 'package:flutter/material.dart';

import '../../core/utils/formatters.dart';
import '../../core/widgets/app_cards.dart';
import '../../core/widgets/status_badge.dart';
import '../../models/app_models.dart';
import '../../providers_or_bloc/app_state.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  NotificationType? _filter;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.watch(context);
    final notifications = state.repository.notifications.where((item) {
      return _filter == null || item.type == _filter;
    }).toList();
    return FeaturePage(
      title: 'Notifications',
      subtitle: 'Firebase-ready categorized notification center and settings.',
      children: [
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Push notifications'),
          subtitle: const Text(
            'Booking, membership, payment, trainer, and reminders',
          ),
          value: state.notificationsEnabled,
          onChanged: state.setNotificationsEnabled,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: const Text('All'),
                  selected: _filter == null,
                  onSelected: (_) => setState(() => _filter = null),
                ),
              ),
              ...NotificationType.values.map(
                (type) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    avatar: Icon(type.icon, size: 18),
                    label: Text(type.label),
                    selected: _filter == type,
                    onSelected: (_) => setState(() => _filter = type),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SectionHeader(title: 'Notification center'),
        ...notifications.map(
          (item) => Dismissible(
            key: ValueKey(item.id),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              color: Theme.of(context).colorScheme.primaryContainer,
              child: const Icon(Icons.mark_email_read_outlined),
            ),
            onDismissed: (_) => state.markNotificationRead(item.id),
            child: AppCard(
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(item.type.icon),
                title: Text(item.title),
                subtitle: Text(
                  '${item.message}\n${formatDate(item.createdAt)}',
                ),
                isThreeLine: true,
                trailing: item.isRead
                    ? const StatusBadge(label: 'Read', compact: true)
                    : const StatusBadge(label: 'Pending', compact: true),
                onTap: () => state.markNotificationRead(item.id),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
