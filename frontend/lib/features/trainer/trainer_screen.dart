import 'package:flutter/material.dart';

import '../../core/utils/formatters.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_cards.dart';
import '../../core/widgets/pickers.dart';
import '../../core/widgets/status_badge.dart';
import '../../models/app_models.dart';
import '../../providers_or_bloc/app_state.dart';

class TrainerModuleScreen extends StatefulWidget {
  const TrainerModuleScreen({super.key});

  @override
  State<TrainerModuleScreen> createState() => _TrainerModuleScreenState();
}

class _TrainerModuleScreenState extends State<TrainerModuleScreen> {
  String? _selectedTrainerId;
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));

  @override
  Widget build(BuildContext context) {
    final state = AppScope.watch(context);
    if (state.currentRole == UserRole.trainer) {
      return _TrainerDashboard(
        selectedDate: _selectedDate,
        onDate: (date) {
          setState(() => _selectedDate = date);
        },
      );
    }
    final trainers = state.repository.trainers;
    return FeaturePage(
      title: 'Trainers',
      subtitle:
          'Profiles, ratings, availability, reviews, and trainer selection.',
      children: [
        ...trainers.map(
          (trainer) => TrainerCard(
            trainer: trainer,
            selected: trainer.id == _selectedTrainerId,
            onSelect: () => setState(() => _selectedTrainerId = trainer.id),
          ),
        ),
        if (_selectedTrainerId != null)
          AppButton(
            label: 'Continue with selected trainer',
            icon: Icons.arrow_forward_outlined,
            expand: true,
            onPressed: () {},
          ),
      ],
    );
  }
}

class _TrainerDashboard extends StatelessWidget {
  const _TrainerDashboard({required this.selectedDate, required this.onDate});

  final DateTime selectedDate;
  final ValueChanged<DateTime> onDate;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.watch(context);
    final bookings = state.repository.bookings.take(4).toList();
    return FeaturePage(
      title: 'Trainer Dashboard',
      subtitle: 'Today sessions, weekly schedule, calendar, and availability.',
      trailing: const StatusBadge(label: 'Available'),
      children: [
        ResponsiveGrid(
          children: const [
            StatCard(
              label: 'Today sessions',
              value: '5',
              icon: Icons.today_outlined,
              change: 'Active',
            ),
            StatCard(
              label: 'Weekly sessions',
              value: '28',
              icon: Icons.calendar_month_outlined,
              change: '+8%',
            ),
            StatCard(
              label: 'Rating',
              value: '4.9',
              icon: Icons.star_outline,
              change: 'Active',
            ),
            StatCard(
              label: 'Tomorrow edits',
              value: '3',
              icon: Icons.edit_calendar_outlined,
              change: 'Pending',
            ),
          ],
        ),
        const SectionHeader(title: 'Session calendar'),
        DateChipPicker(
          selectedDate: selectedDate,
          onSelected: onDate,
          days: 14,
        ),
        const SectionHeader(title: 'Assigned sessions'),
        ...bookings.map((booking) => BookingTile(booking: booking)),
        const SectionHeader(title: 'Edit tomorrow sessions'),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tomorrow: ${formatDate(DateTime.now().add(const Duration(days: 1)))}',
              ),
              const SizedBox(height: 10),
              const TimeSlotPicker(
                selectedSlot: '07:00',
                onSelected: _noopSlot,
                availableSlots: ['07:00', '12:00', '18:00'],
              ),
              const SizedBox(height: 12),
              AppButton(
                label: 'Save Availability',
                icon: Icons.save_outlined,
                onPressed: () {},
              ),
            ],
          ),
        ),
        const SectionHeader(title: 'Profile management'),
        const AppCard(
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.person_outline),
            title: Text('Trainer profile'),
            subtitle: Text(
              'Specialty, bio, availability, notifications, and reviews',
            ),
            trailing: Icon(Icons.chevron_right),
          ),
        ),
      ],
    );
  }
}

void _noopSlot(String value) {}
