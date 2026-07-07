import 'package:flutter/material.dart';

import '../constants/app_constants.dart';
import '../utils/formatters.dart';

class DateChipPicker extends StatelessWidget {
  const DateChipPicker({
    super.key,
    required this.selectedDate,
    required this.onSelected,
    this.days = 7,
  });

  final DateTime selectedDate;
  final ValueChanged<DateTime> onSelected;
  final int days;

  @override
  Widget build(BuildContext context) {
    final dates = List.generate(days, (index) {
      final now = DateTime.now();
      return DateTime(now.year, now.month, now.day + index);
    });
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: dates.map((date) {
          final selected = DateUtils.isSameDay(date, selectedDate);
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(formatShortDate(date)),
              selected: selected,
              onSelected: (_) => onSelected(date),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class TimeSlotPicker extends StatelessWidget {
  const TimeSlotPicker({
    super.key,
    required this.selectedSlot,
    required this.onSelected,
    this.availableSlots = AppConstants.timeSlots,
  });

  final String? selectedSlot;
  final ValueChanged<String> onSelected;
  final List<String> availableSlots;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: AppConstants.timeSlots.map((slot) {
        final enabled = availableSlots.contains(slot);
        return ChoiceChip(
          label: Text(slot),
          selected: slot == selectedSlot,
          onSelected: enabled ? (_) => onSelected(slot) : null,
        );
      }).toList(),
    );
  }
}
