import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_cards.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FeaturePage(
      title: 'Help',
      subtitle:
          'Support, frequently asked questions, issue reporting, and policy links.',
      children: [
        AppCard(
          child: Column(
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.email_outlined),
                title: const Text('Email support'),
                subtitle: const Text(AppConstants.supportEmail),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.phone_outlined),
                title: const Text('Call front desk'),
                subtitle: const Text(AppConstants.supportPhone),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
            ],
          ),
        ),
        const SectionHeader(title: 'FAQs'),
        const AppCard(
          child: ExpansionTile(
            tilePadding: EdgeInsets.zero,
            title: Text('How do I cancel a booking?'),
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: Text(
                  'Open Booking History, select the booking, then use Cancel Booking.',
                ),
              ),
            ],
          ),
        ),
        const AppCard(
          child: ExpansionTile(
            tilePadding: EdgeInsets.zero,
            title: Text('What happens when membership expires?'),
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: Text(
                  'The expired membership screen blocks new bookings until renewal.',
                ),
              ),
            ],
          ),
        ),
        AppButton(
          label: 'Create Support Ticket',
          icon: Icons.support_agent_outlined,
          expand: true,
          onPressed: () {},
        ),
      ],
    );
  }
}
