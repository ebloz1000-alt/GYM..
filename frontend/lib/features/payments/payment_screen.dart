import 'package:flutter/material.dart';

import '../../core/utils/formatters.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_cards.dart';
import '../../core/widgets/status_badge.dart';
import '../../models/app_models.dart';
import '../../providers_or_bloc/app_state.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _method = 'M-Pesa';
  PaymentStatus _previewStatus = PaymentStatus.pending;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.watch(context);
    final repo = state.repository;
    return FeaturePage(
      title: 'Payments',
      subtitle:
          'M-Pesa STK Push, cash, Pay Later, retry, receipts, and history.',
      children: [
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(title: 'Payment options'),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(
                    value: 'M-Pesa',
                    icon: Icon(Icons.phone_android),
                    label: Text('M-Pesa'),
                  ),
                  ButtonSegment(
                    value: 'Cash',
                    icon: Icon(Icons.payments_outlined),
                    label: Text('Cash'),
                  ),
                  ButtonSegment(
                    value: 'Pay Later',
                    icon: Icon(Icons.schedule_outlined),
                    label: Text('Later'),
                  ),
                ],
                selected: {_method},
                onSelectionChanged: (value) =>
                    setState(() => _method = value.first),
              ),
              const SizedBox(height: 14),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.receipt_long_outlined),
                title: Text('Booking balance ${formatMoney(1200)}'),
                subtitle: Text(
                  _method == 'M-Pesa'
                      ? 'STK Push expires in 04:59'
                      : _method == 'Cash'
                      ? 'Mark as pending until front desk confirms'
                      : 'Due before next booking',
                ),
                trailing: StatusBadge(label: _previewStatus.label),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  AppButton(
                    label: _method == 'M-Pesa'
                        ? 'Send STK Push'
                        : 'Confirm $_method',
                    icon: Icons.send_to_mobile_outlined,
                    onPressed: () {
                      setState(() => _previewStatus = PaymentStatus.confirmed);
                      state.addPayment(
                        PaymentRecord(
                          id: 'pay-${DateTime.now().millisecondsSinceEpoch}',
                          method: _method,
                          amount: 1200,
                          status: PaymentStatus.confirmed,
                          createdAt: DateTime.now(),
                          reference:
                              'TX-${DateTime.now().second}${DateTime.now().millisecond}',
                        ),
                      );
                    },
                  ),
                  AppButton(
                    label: 'Retry',
                    icon: Icons.refresh_outlined,
                    variant: AppButtonVariant.secondary,
                    onPressed: () =>
                        setState(() => _previewStatus = PaymentStatus.pending),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SectionHeader(title: 'Payment history'),
        ...repo.payments.map(
          (payment) => AppCard(
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.receipt_outlined),
              title: Text('${payment.method} - ${formatMoney(payment.amount)}'),
              subtitle: Text(
                '${payment.reference}\n${formatDate(payment.createdAt)}',
              ),
              isThreeLine: true,
              trailing: StatusBadge(label: payment.status.label, compact: true),
            ),
          ),
        ),
      ],
    );
  }
}
