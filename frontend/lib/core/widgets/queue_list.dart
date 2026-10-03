import 'package:flutter/material.dart';

import '../models/models.dart';
import '../theme/app_colors.dart';
import '../utils/format.dart';
import 'page_container.dart';
import 'status_chip.dart';

/// Reusable list of queued patients with a status chip on each row.
class QueueList extends StatelessWidget {
  const QueueList({
    super.key,
    required this.items,
    this.onTap,
    this.selectedId,
  });

  final List<QueueItem> items;
  final ValueChanged<QueueItem>? onTap;
  final String? selectedId;

  String _typeLabel(VisitType type) => switch (type) {
        VisitType.newVisit => 'New',
        VisitType.review => 'Review',
        VisitType.emergency => 'Emergency',
      };

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const EmptyState('No patients in the queue.');
    }

    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final item = items[index];
        final selected = item.patient.id == selectedId;

        return InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap == null ? null : () => onTap!(item),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: selected ? AppColors.infoBg : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: selected ? AppColors.brand : AppColors.border,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.patient.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${item.patient.number}  |  ${_typeLabel(item.type)}  |  '
                        'waiting ${waitingLabel(item.since)}',
                        style: const TextStyle(color: AppColors.textMuted),
                      ),
                    ],
                  ),
                ),
                StatusChip(item.status),
              ],
            ),
          ),
        );
      },
    );
  }
}
