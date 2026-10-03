import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/data/providers.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/page_container.dart';

/// Shared by lab and pharmacy: a queue of paid or approved orders, each with
/// one action button. kind is 'lab' or 'pharmacy'.
class WorkQueueScreen extends ConsumerWidget {
  const WorkQueueScreen({
    super.key,
    required this.kind,
    required this.title,
    required this.subtitle,
    required this.actionLabel,
  });

  final String kind;
  final String title;
  final String subtitle;
  final String actionLabel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(workItemsProvider(kind));

    return PageContainer(
      title: title,
      subtitle: subtitle,
      child: items.when(
        data: (list) {
          if (list.isEmpty) return const EmptyState('Nothing waiting right now.');

          return ListView.separated(
            itemCount: list.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final item = list[index];

              return SectionCard(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${item.patient.name}  (${item.patient.number})',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.description,
                            style: const TextStyle(color: AppColors.textMuted),
                          ),
                        ],
                      ),
                    ),
                    FilledButton(
                      onPressed: () async {
                        // TODO: open the result entry or dispensing form
                        // instead of completing straight away.
                        await ref
                            .read(clinicRepositoryProvider)
                            .completeWorkItem(kind, item.id);
                        ref.invalidate(workItemsProvider(kind));
                      },
                      child: Text(actionLabel),
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const ErrorState(),
      ),
    );
  }
}
