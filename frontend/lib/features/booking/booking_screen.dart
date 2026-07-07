import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_cards.dart';
import '../../core/widgets/pickers.dart';
import '../../core/widgets/state_views.dart';
import '../../models/app_models.dart';
import '../../providers_or_bloc/app_state.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int _step = 0;
  EquipmentItem? _equipment;
  TrainerProfile? _trainer;
  DateTime _date = DateTime.now();
  String? _slot;
  bool _success = false;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.watch(context);
    final repo = state.repository;
    if (_success) {
      return FeaturePage(
        title: 'Booking Success',
        subtitle: 'Your session is confirmed and ready for payment tracking.',
        children: [
          const EmptyStateView(
            title: 'Booking created',
            message:
                'A confirmation notification and payment record are ready.',
            icon: Icons.check_circle_outline,
          ),
          AppButton(
            label: 'Create another booking',
            icon: Icons.add,
            expand: true,
            onPressed: () => setState(() {
              _success = false;
              _step = 0;
              _equipment = null;
              _trainer = null;
              _slot = null;
            }),
          ),
          const SectionHeader(title: 'Upcoming bookings'),
          ...repo.bookings
              .take(3)
              .map((booking) => BookingTile(booking: booking)),
        ],
      );
    }
    return FeaturePage(
      title: 'Book a Session',
      subtitle:
          'Equipment, date, slot, trainer, review, confirmation, and payment.',
      children: [
        Stepper(
          currentStep: _step,
          onStepTapped: (value) => setState(() => _step = value),
          controlsBuilder: (context, details) => const SizedBox.shrink(),
          steps: [
            Step(
              title: const Text('Select equipment'),
              isActive: _step >= 0,
              content: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: repo.equipment
                    .where((item) => item.status == EquipmentStatus.available)
                    .map(
                      (item) => ChoiceChip(
                        label: Text('${item.name} - ${item.available} free'),
                        selected: _equipment?.id == item.id,
                        onSelected: (_) => setState(() {
                          _equipment = item;
                          _step = 1;
                        }),
                      ),
                    )
                    .toList(),
              ),
            ),
            Step(
              title: const Text('Choose date'),
              isActive: _step >= 1,
              content: DateChipPicker(
                selectedDate: _date,
                onSelected: (value) => setState(() {
                  _date = value;
                  _step = 2;
                }),
              ),
            ),
            Step(
              title: const Text('Choose time slot'),
              isActive: _step >= 2,
              content: TimeSlotPicker(
                selectedSlot: _slot,
                onSelected: (value) => setState(() {
                  _slot = value;
                  _step = 3;
                }),
              ),
            ),
            Step(
              title: const Text('Select trainer'),
              isActive: _step >= 3,
              content: Column(
                children: repo.trainers
                    .where(
                      (trainer) =>
                          _slot == null ||
                          trainer.availableSlots.contains(_slot),
                    )
                    .map(
                      (trainer) => TrainerCard(
                        trainer: trainer,
                        selected: trainer.id == _trainer?.id,
                        onSelect: () => setState(() {
                          _trainer = trainer;
                          _step = 4;
                        }),
                      ),
                    )
                    .toList(),
              ),
            ),
            Step(
              title: const Text('Review and confirm'),
              isActive: _step >= 4,
              content: _reviewCard(state),
            ),
          ],
        ),
        const SectionHeader(title: 'Booking history'),
        ...repo.bookings.map(
          (booking) => BookingTile(
            booking: booking,
            onCancel: () => state.cancelBooking(booking),
          ),
        ),
      ],
    );
  }

  Widget _reviewCard(AppState state) {
    final canConfirm = _equipment != null && _trainer != null && _slot != null;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_equipment?.name ?? 'No equipment selected'),
          Text('Date: ${formatDate(_date)}'),
          Text('Time: ${_slot ?? 'No slot selected'}'),
          Text('Trainer: ${_trainer?.name ?? 'No trainer selected'}'),
          const SizedBox(height: 14),
          AppButton(
            label: 'Confirm Booking',
            icon: Icons.check_circle_outline,
            expand: true,
            onPressed: canConfirm
                ? () {
                    final booking = Booking(
                      id: 'bk-${DateTime.now().millisecondsSinceEpoch}',
                      equipmentName: _equipment!.name,
                      trainerName: _trainer!.name,
                      date: _date,
                      timeSlot: _slot ?? AppConstants.timeSlots.first,
                      status: BookingStatus.confirmed,
                      paymentStatus: PaymentStatus.pending,
                    );
                    state.addBooking(booking);
                    setState(() => _success = true);
                  }
                : null,
          ),
          const SizedBox(height: 8),
          AppButton(
            label: 'Cancel Booking Flow',
            icon: Icons.close_outlined,
            variant: AppButtonVariant.outline,
            expand: true,
            onPressed: () => setState(() {
              _step = 0;
              _equipment = null;
              _trainer = null;
              _slot = null;
            }),
          ),
        ],
      ),
    );
  }
}
