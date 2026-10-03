import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/data/providers.dart';
import '../../core/models/models.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/page_container.dart';
import '../../core/widgets/patient_header.dart';
import '../../core/widgets/queue_list.dart';

class NurseHome extends ConsumerStatefulWidget {
  const NurseHome({super.key});

  @override
  ConsumerState<NurseHome> createState() => _NurseHomeState();
}

class _NurseHomeState extends ConsumerState<NurseHome> {
  QueueItem? _selected;

  final _temperature = TextEditingController();
  final _systolic = TextEditingController();
  final _diastolic = TextEditingController();
  final _pulse = TextEditingController();
  final _weight = TextEditingController();
  final _notes = TextEditingController();

  List<TextEditingController> get _controllers =>
      [_temperature, _systolic, _diastolic, _pulse, _weight, _notes];

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _save() {
    // TODO: POST /visits/:id/vitals, then move the visit to "with doctor".
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Vitals saved. Patient sent to the doctor.')),
    );
    for (final controller in _controllers) {
      controller.clear();
    }
    setState(() => _selected = null);
  }

  Widget _numberField(TextEditingController controller, String label) {
    return SizedBox(
      width: 180,
      child: TextField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        textInputAction: TextInputAction.next,
        decoration: appInput(label),
      ),
    );
  }

  Widget _vitalsForm(QueueItem item) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PatientHeader(item.patient),
          const SizedBox(height: 16),
          SectionCard(
            child: Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _numberField(_temperature, 'Temperature (C)'),
                _numberField(_systolic, 'BP systolic'),
                _numberField(_diastolic, 'BP diastolic'),
                _numberField(_pulse, 'Pulse (per min)'),
                // Weight matters most: children's doses are worked out from it.
                _numberField(_weight, 'Weight (kg)'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _notes,
            maxLines: 3,
            decoration: appInput('Notes (optional)'),
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton(
              onPressed: _save,
              child: const Text('Save and send to doctor'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final queue = ref.watch(queueProvider);

    return PageContainer(
      title: 'Triage',
      subtitle: 'Patients waiting for vitals',
      child: queue.when(
        data: (all) {
          final waiting =
              all.where((q) => q.status == VisitStatus.waiting).toList();
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 380,
                child: QueueList(
                  items: waiting,
                  selectedId: _selected?.patient.id,
                  onTap: (item) => setState(() => _selected = item),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: _selected == null
                    ? const EmptyState('Select a patient to record vitals.')
                    : _vitalsForm(_selected!),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const ErrorState(),
      ),
    );
  }
}
