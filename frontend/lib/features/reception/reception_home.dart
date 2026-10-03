import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/data/providers.dart';
import '../../core/widgets/page_container.dart';
import '../../core/widgets/queue_list.dart';

class ReceptionHome extends ConsumerWidget {
  const ReceptionHome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queue = ref.watch(queueProvider);

    return PageContainer(
      title: "Today's queue",
      subtitle: 'Patients registered at the front desk today',
      action: FilledButton.icon(
        onPressed: () => context.go('/register'),
        icon: const Icon(Icons.person_add_alt_1),
        label: const Text('Register new patient'),
      ),
      child: queue.when(
        data: (items) => QueueList(items: items),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const ErrorState(),
      ),
    );
  }
}
