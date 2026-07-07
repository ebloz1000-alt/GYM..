import 'package:flutter/material.dart';

import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_cards.dart';
import '../../core/widgets/app_charts.dart';
import '../../core/widgets/status_badge.dart';
import '../../providers_or_bloc/app_state.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  String _range = 'Monthly';

  @override
  Widget build(BuildContext context) {
    final repo = AppScope.watch(context).repository;
    return FeaturePage(
      title: 'Reports',
      subtitle:
          'Daily, monthly, revenue, trainer, equipment, membership, and feedback reports.',
      children: [
        SegmentedButton<String>(
          segments: const [
            ButtonSegment(value: 'Daily', label: Text('Daily')),
            ButtonSegment(value: 'Monthly', label: Text('Monthly')),
            ButtonSegment(value: 'Custom', label: Text('Custom')),
          ],
          selected: {_range},
          onSelectionChanged: (value) => setState(() => _range = value.first),
        ),
        const SizedBox(height: 12),
        AppCard(child: AppBarChart(points: repo.revenueTrend)),
        AppCard(
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              AppButton(
                label: 'Export PDF',
                icon: Icons.picture_as_pdf_outlined,
                onPressed: () {},
              ),
              AppButton(
                label: 'Export Excel',
                icon: Icons.table_chart_outlined,
                onPressed: () {},
              ),
              AppButton(
                label: 'Preview',
                icon: Icons.visibility_outlined,
                variant: AppButtonVariant.secondary,
                onPressed: () {},
              ),
            ],
          ),
        ),
        const SectionHeader(title: 'Report preview'),
        ...repo.reportRows.map(
          (row) => AppCard(
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.summarize_outlined),
              title: Text(row.title),
              subtitle: Text('${row.metric} - ${row.change}'),
              trailing: StatusBadge(label: row.status, compact: true),
            ),
          ),
        ),
        const SectionHeader(title: 'Download history'),
        const AppCard(
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.download_done_outlined),
            title: Text('Monthly revenue report'),
            subtitle: Text('PDF and Excel generated for admin review'),
            trailing: StatusBadge(label: 'Ready', compact: true),
          ),
        ),
      ],
    );
  }
}
