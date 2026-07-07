import 'package:flutter/material.dart';

import '../../core/utils/formatters.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_cards.dart';
import '../../core/widgets/status_badge.dart';
import '../../providers_or_bloc/app_state.dart';

class MembershipScreen extends StatefulWidget {
  const MembershipScreen({super.key});

  @override
  State<MembershipScreen> createState() => _MembershipScreenState();
}

class _MembershipScreenState extends State<MembershipScreen> {
  String _selectedPlan = 'Monthly';
  int _vipDuration = 45;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.watch(context);
    final repo = state.repository;
    final current = repo.currentMembership;
    return FeaturePage(
      title: 'Membership',
      subtitle: 'Plans, renewals, countdowns, and membership history.',
      children: [
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${current.plan} plan',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  StatusBadge(label: current.status),
                ],
              ),
              const SizedBox(height: 8),
              Text('Started ${formatDate(current.startedAt)}'),
              Text('Expires ${formatDate(current.expiresAt)}'),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: 0.6,
                minHeight: 8,
                borderRadius: BorderRadius.circular(999),
              ),
              const SizedBox(height: 10),
              Text(formatCountdown(current.expiresAt)),
            ],
          ),
        ),
        const SectionHeader(title: 'Choose a plan'),
        ...repo.membershipPlans.map((plan) {
          final selected = _selectedPlan == plan.name;
          final price = plan.name == 'VIP'
              ? plan.price * (_vipDuration / plan.durationDays)
              : plan.price;
          return AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        plan.name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    if (plan.highlight) const StatusBadge(label: 'Popular'),
                    ChoiceChip(
                      label: Text(selected ? 'Selected' : 'Choose'),
                      selected: selected,
                      onSelected: (_) =>
                          setState(() => _selectedPlan = plan.name),
                    ),
                  ],
                ),
                Text('${plan.durationDays} days - ${formatMoney(price)}'),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: plan.features
                      .map((feature) => Chip(label: Text(feature)))
                      .toList(),
                ),
                if (plan.name == 'VIP' && selected) ...[
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [35, 40, 45, 50, 60, 70, 80]
                        .map(
                          (days) => ChoiceChip(
                            label: Text('$days days'),
                            selected: _vipDuration == days,
                            onSelected: (_) =>
                                setState(() => _vipDuration = days),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ],
            ),
          );
        }),
        AppButton(
          label: 'Renew $_selectedPlan',
          icon: Icons.workspace_premium_outlined,
          expand: true,
          onPressed: () {},
        ),
        const SectionHeader(title: 'Membership history'),
        ...repo.membershipHistory.map(
          (item) => AppCard(
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.history_outlined),
              title: Text(item.plan),
              subtitle: Text(
                '${formatDate(item.startedAt)} - ${formatDate(item.expiresAt)}',
              ),
              trailing: StatusBadge(label: item.status, compact: true),
            ),
          ),
        ),
        const SectionHeader(title: 'Blocked and expired states'),
        const AppCard(
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.block_outlined),
            title: Text('Blocked Membership Screen'),
            subtitle: Text(
              'Shown when admin suspends access or payment remains overdue.',
            ),
            trailing: StatusBadge(label: 'Blocked', compact: true),
          ),
        ),
        const AppCard(
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.timer_off_outlined),
            title: Text('Expired Membership Screen'),
            subtitle: Text('Shown when membership countdown reaches zero.'),
            trailing: StatusBadge(label: 'Expired', compact: true),
          ),
        ),
      ],
    );
  }
}
