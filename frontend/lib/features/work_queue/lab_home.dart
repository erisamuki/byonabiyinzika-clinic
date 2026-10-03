import 'package:flutter/material.dart';

import 'work_queue_screen.dart';

class LabHome extends StatelessWidget {
  const LabHome({super.key});

  @override
  Widget build(BuildContext context) {
    return const WorkQueueScreen(
      kind: 'lab',
      title: 'Lab',
      subtitle: 'Paid and approved test orders',
      actionLabel: 'Mark done',
    );
  }
}
