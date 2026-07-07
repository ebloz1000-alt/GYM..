import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_cards.dart';
import '../../core/widgets/app_fields.dart';
import '../../core/widgets/pickers.dart';
import '../../core/widgets/status_badge.dart';
import '../../models/app_models.dart';
import '../../providers_or_bloc/app_state.dart';

class EquipmentScreen extends StatefulWidget {
  const EquipmentScreen({super.key});

  @override
  State<EquipmentScreen> createState() => _EquipmentScreenState();
}

class _EquipmentScreenState extends State<EquipmentScreen> {
  String _query = '';
  String _category = 'All';

  @override
  Widget build(BuildContext context) {
    final repo = AppScope.watch(context).repository;
    final items = repo.equipment.where((item) {
      final matchesQuery =
          item.name.toLowerCase().contains(_query.toLowerCase()) ||
          item.category.toLowerCase().contains(_query.toLowerCase());
      final matchesCategory = _category == 'All' || item.category == _category;
      return matchesQuery && matchesCategory;
    }).toList();
    return FeaturePage(
      title: 'Equipment',
      subtitle:
          'Search, filter, inspect capacity, and book available equipment.',
      children: [
        AppSearchBar(
          hint: 'Search equipment',
          onChanged: (value) => setState(() => _query = value),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: AppConstants.equipmentCategories
                .map(
                  (category) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(category),
                      selected: _category == category,
                      onSelected: (_) => setState(() => _category = category),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        const SectionHeader(title: 'Equipment list'),
        ...items.map(
          (item) => EquipmentCard(
            item: item,
            onBook: () => _showEquipmentDetails(context, item),
          ),
        ),
      ],
    );
  }

  void _showEquipmentDetails(BuildContext context, EquipmentItem item) {
    var selectedDate = DateTime.now();
    var selectedSlot = AppConstants.timeSlots.first;
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(item.imageIcon),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            item.name,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        StatusBadge(label: item.status.label),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(item.description),
                    const SizedBox(height: 16),
                    const SectionHeader(title: 'Availability calendar'),
                    DateChipPicker(
                      selectedDate: selectedDate,
                      onSelected: (value) =>
                          setSheetState(() => selectedDate = value),
                    ),
                    const SizedBox(height: 12),
                    const SectionHeader(title: 'Time slots'),
                    TimeSlotPicker(
                      selectedSlot: selectedSlot,
                      onSelected: (value) =>
                          setSheetState(() => selectedSlot = value),
                    ),
                    const SizedBox(height: 16),
                    AppButton(
                      label: 'Review Booking',
                      icon: Icons.fact_check_outlined,
                      expand: true,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
