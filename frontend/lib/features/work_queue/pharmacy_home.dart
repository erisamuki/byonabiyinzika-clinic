import 'package:flutter/material.dart';

import 'work_queue_screen.dart';

class PharmacyHome extends StatelessWidget {
  const PharmacyHome({super.key});

  @override
  Widget build(BuildContext context) {
    return const WorkQueueScreen(
      kind: 'pharmacy',
      title: 'Pharmacy',
      subtitle: 'Paid and approved prescriptions',
      actionLabel: 'Dispense',
    );
  }
}
