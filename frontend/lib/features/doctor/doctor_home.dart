import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/data/providers.dart';
import '../../core/models/models.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/page_container.dart';
import '../../core/widgets/patient_header.dart';
import '../../core/widgets/queue_list.dart';

class DoctorHome extends ConsumerStatefulWidget {
  const DoctorHome({super.key});

  @override
  ConsumerState<DoctorHome> createState() => _DoctorHomeState();
}

class _DoctorHomeState extends ConsumerState<DoctorHome> {
  QueueItem? _selected;
  final _notes = TextEditingController();
  final _diagnosis = TextEditingController();

  @override
  void dispose() {
    _notes.dispose();
    _diagnosis.dispose();
    super.dispose();
  }

  void _toast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _finish() {
    // TODO: POST /consultations, then move the visit to the next stage.
    _toast('Consultation saved.');
    _notes.clear();
    _diagnosis.clear();
    setState(() => _selected = null);
  }

  Widget _consultation(QueueItem item) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PatientHeader(item.patient),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'History',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Previous diagnoses, prescriptions and lab results '
                        'will appear here.',
                        style: TextStyle(color: AppColors.textMuted),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Consultation',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _notes,
                        maxLines: 5,
                        decoration: appInput('Notes'),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _diagnosis,
                        decoration: appInput('Diagnosis'),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          OutlinedButton.icon(
                            onPressed: () => _toast('Lab order form coming soon.'),
                            icon: const Icon(Icons.science_outlined),
                            label: const Text('Order tests'),
                          ),
                          OutlinedButton.icon(
                            onPressed: () =>
                                _toast('Prescription form coming soon.'),
                            icon: const Icon(Icons.medication_outlined),
                            label: const Text('Prescribe'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton(
              onPressed: _finish,
              child: const Text('Finish consultation'),
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
      title: 'Consultations',
      subtitle: 'Patients waiting to see the doctor',
      child: queue.when(
        data: (all) {
          final mine =
              all.where((q) => q.status == VisitStatus.withDoctor).toList();
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 380,
                child: QueueList(
                  items: mine,
                  selectedId: _selected?.patient.id,
                  onTap: (item) => setState(() => _selected = item),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: _selected == null
                    ? const EmptyState('Select a patient to start.')
                    : _consultation(_selected!),
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
