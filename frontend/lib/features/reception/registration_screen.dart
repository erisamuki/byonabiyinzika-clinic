import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/data/providers.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/confirm_dialog.dart';
import '../../core/widgets/page_container.dart';

class RegistrationScreen extends ConsumerStatefulWidget {
  const RegistrationScreen({super.key});

  @override
  ConsumerState<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends ConsumerState<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _kinName = TextEditingController();
  final _kinPhone = TextEditingController();

  String _sex = 'Female';
  DateTime? _dob;
  bool _dobMissing = false;
  bool _busy = false;

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _kinName.dispose();
    _kinPhone.dispose();
    super.dispose();
  }

  Future<void> _pickDob() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dob ?? DateTime(now.year - 30),
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked != null) {
      setState(() {
        _dob = picked;
        _dobMissing = false;
      });
    }
  }

  Future<void> _save() async {
    final valid = _formKey.currentState!.validate();
    if (_dob == null) setState(() => _dobMissing = true);
    if (!valid || _dob == null) return;

    final repository = ref.read(clinicRepositoryProvider);
    final messenger = ScaffoldMessenger.of(context);
    final router = GoRouter.of(context);

    final duplicates = await repository.findDuplicates(
      name: _name.text.trim(),
      phone: _phone.text.trim(),
    );

    if (duplicates.isNotEmpty) {
      if (!mounted) return;
      final first = duplicates.first;
      final proceed = await showConfirmDialog(
        context,
        title: 'Possible duplicate',
        message: '${first.name} (${first.number}) already uses this name or '
            'phone number. Register as a new patient anyway?',
        confirmLabel: 'Register anyway',
      );
      if (!proceed || !mounted) return;
    }

    setState(() => _busy = true);
    final patient = await repository.registerPatient(
      name: _name.text.trim(),
      sex: _sex,
      dateOfBirth: _dob!,
      phone: _phone.text.trim(),
      nextOfKinName: _kinName.text.trim(),
      nextOfKinPhone: _kinPhone.text.trim(),
    );
    ref.invalidate(queueProvider);

    if (!mounted) return;
    setState(() => _busy = false);
    messenger.showSnackBar(
      SnackBar(content: Text('${patient.name} registered as ${patient.number}')),
    );
    router.go('/reception');
  }

  @override
  Widget build(BuildContext context) {
    return PageContainer(
      title: 'Register new patient',
      subtitle: 'Only the essentials. Everything else can be added later.',
      child: SingleChildScrollView(
        child: Align(
          alignment: Alignment.topLeft,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _name,
                    textInputAction: TextInputAction.next,
                    decoration: appInput('Full name'),
                    validator: (v) => (v == null || v.trim().length < 3)
                        ? 'Enter the patient\'s full name'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  const Text('Sex', style: TextStyle(color: AppColors.textMuted)),
                  const SizedBox(height: 8),
                  SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(value: 'Female', label: Text('Female')),
                      ButtonSegment(value: 'Male', label: Text('Male')),
                    ],
                    selected: {_sex},
                    onSelectionChanged: (s) => setState(() => _sex = s.first),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: _pickDob,
                    icon: const Icon(Icons.calendar_today_outlined),
                    label: Text(
                      _dob == null
                          ? 'Select date of birth'
                          : DateFormat('d MMM yyyy').format(_dob!),
                    ),
                  ),
                  if (_dobMissing)
                    const Padding(
                      padding: EdgeInsets.only(top: 6),
                      child: Text(
                        'Please select the date of birth.',
                        style: TextStyle(color: AppColors.warning),
                      ),
                    ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _phone,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    decoration: appInput('Phone number'),
                    validator: (v) => (v == null || v.trim().length < 9)
                        ? 'Enter a valid phone number'
                        : null,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Next of kin (optional)',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _kinName,
                    textInputAction: TextInputAction.next,
                    decoration: appInput('Name'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _kinPhone,
                    keyboardType: TextInputType.phone,
                    decoration: appInput('Phone number'),
                  ),
                  const SizedBox(height: 28),
                  FilledButton(
                    onPressed: _busy ? null : _save,
                    child: const Text('Register patient'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
