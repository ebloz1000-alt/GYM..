import 'package:flutter/material.dart';

import '../../core/utils/formatters.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_cards.dart';
import '../../core/widgets/app_fields.dart';
import '../../models/app_models.dart';
import '../../providers_or_bloc/app_state.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  String _target = 'Brian Kariuki';
  int _rating = 5;
  final _comment = TextEditingController();

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.watch(context);
    final targets = [
      ...state.repository.trainers.map((trainer) => trainer.name),
      ...state.repository.equipment.map((item) => item.name),
    ];
    return FeaturePage(
      title: 'Feedback',
      subtitle:
          'Rate trainers and equipment, submit comments, and view history.',
      children: [
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                initialValue: _target,
                items: targets
                    .map(
                      (target) =>
                          DropdownMenuItem(value: target, child: Text(target)),
                    )
                    .toList(),
                onChanged: (value) =>
                    setState(() => _target = value ?? _target),
                decoration: const InputDecoration(labelText: 'Feedback target'),
              ),
              const SizedBox(height: 12),
              Row(
                children: List.generate(
                  5,
                  (index) => IconButton(
                    tooltip: '${index + 1} stars',
                    onPressed: () => setState(() => _rating = index + 1),
                    icon: Icon(
                      index < _rating
                          ? Icons.star_rounded
                          : Icons.star_border_rounded,
                      color: Colors.amber.shade700,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              AppTextField(
                label: 'Comments',
                controller: _comment,
                maxLines: 4,
                icon: Icons.comment_outlined,
              ),
              const SizedBox(height: 12),
              AppButton(
                label: 'Submit Feedback',
                icon: Icons.send_outlined,
                expand: true,
                onPressed: () {
                  state.addFeedback(
                    FeedbackEntry(
                      id: 'fb-${DateTime.now().millisecondsSinceEpoch}',
                      target: _target,
                      rating: _rating,
                      comment: _comment.text.isEmpty
                          ? 'No comment'
                          : _comment.text,
                      createdAt: DateTime.now(),
                    ),
                  );
                  _comment.clear();
                },
              ),
            ],
          ),
        ),
        const SectionHeader(title: 'Feedback history'),
        ...state.repository.feedback.map(
          (entry) => AppCard(
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.rate_review_outlined),
              title: Text(entry.target),
              subtitle: Text(
                '${entry.comment}\n${formatDate(entry.createdAt)}',
              ),
              isThreeLine: true,
              trailing: Text('${entry.rating}/5'),
            ),
          ),
        ),
      ],
    );
  }
}
