import 'package:flutter/material.dart';

import '../../core/widgets/app_cards.dart';
import '../../core/widgets/app_charts.dart';
import '../../providers_or_bloc/app_state.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = AppScope.watch(context).repository;
    return FeaturePage(
      title: 'Analytics',
      subtitle:
          'Revenue trends, booking patterns, utilization, growth, cancellations, and payments.',
      children: [
        const ResponsiveGrid(
          children: [
            StatCard(
              label: 'Peak hour',
              value: '6 PM',
              icon: Icons.access_time_outlined,
              change: 'Busy',
            ),
            StatCard(
              label: 'Cancellations',
              value: '4.2%',
              icon: Icons.cancel_outlined,
              change: '-2%',
            ),
            StatCard(
              label: 'Payment success',
              value: '96%',
              icon: Icons.verified_outlined,
              change: '+3%',
            ),
            StatCard(
              label: 'Growth',
              value: '16%',
              icon: Icons.trending_up_outlined,
              change: '+16%',
            ),
          ],
        ),
        const SectionHeader(title: 'Revenue charts'),
        AppCard(child: AppLineChart(points: repo.revenueTrend)),
        const SectionHeader(title: 'Booking trends and peak hours'),
        AppCard(child: AppBarChart(points: repo.bookingTrend)),
        const SectionHeader(title: 'Equipment utilization'),
        AppCard(child: AppBarChart(points: repo.equipmentUsage)),
        const SectionHeader(title: 'Trainer performance'),
        const AppCard(
          child: Column(
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.star_outline),
                title: Text('Brian Kariuki'),
                subtitle: Text('4.9 rating - 32 sessions - 92% attendance'),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.star_outline),
                title: Text('Maya Wanjiku'),
                subtitle: Text('4.8 rating - 29 sessions - 89% attendance'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
