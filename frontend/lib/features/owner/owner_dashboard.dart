import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/data/providers.dart';
import '../../core/models/models.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/page_container.dart';

class OwnerDashboard extends ConsumerWidget {
  const OwnerDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final income = ref.watch(incomeProvider);

    return PageContainer(
      title: 'Dashboard',
      subtitle: 'Income and activity at a glance',
      child: income.when(
        data: (summary) => _Content(summary: summary),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const ErrorState(),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({required this.summary});

  final IncomeSummary summary;

  @override
  Widget build(BuildContext context) {
    final methodTotal = summary.byMethod.values.fold<int>(0, (a, b) => a + b);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _StatTile('Income today', formatUgx(summary.today)),
              _StatTile('This week', formatUgx(summary.week)),
              _StatTile('This month', formatUgx(summary.month)),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            crossAxisAlignment: WrapCrossAlignment.start,
            children: [
              _Panel(
                title: 'Today by payment method',
                width: 460,
                child: Column(
                  children: [
                    for (final entry in summary.byMethod.entries)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(child: Text(entry.key)),
                                Text(
                                  formatUgx(entry.value),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            LinearProgressIndicator(
                              value: methodTotal == 0
                                  ? 0
                                  : entry.value / methodTotal,
                              minHeight: 8,
                              borderRadius: BorderRadius.circular(8),
                              color: AppColors.brand,
                              backgroundColor: AppColors.border,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              _Panel(
                title: 'Patients this month',
                width: 300,
                child: Column(
                  children: [
                    _Line('New patients', '${summary.newPatients}'),
                    _Line('Review patients', '${summary.reviewPatients}'),
                  ],
                ),
              ),
              _Panel(
                title: 'Low stock',
                width: 300,
                child: Column(
                  children: [
                    for (final drug in summary.lowStock)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.inventory_2_outlined,
                              size: 18,
                              color: AppColors.warning,
                            ),
                            const SizedBox(width: 8),
                            Expanded(child: Text(drug)),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      child: SectionCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: AppColors.textMuted)),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({required this.title, required this.width, required this.child});

  final String title;
  final double width;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: SectionCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }
}

class _Line extends StatelessWidget {
  const _Line(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
