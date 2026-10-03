import 'package:flutter/material.dart';

import '../models/models.dart';
import '../theme/app_colors.dart';
import 'page_container.dart';

/// Shown at the top of every clinical screen so the wrong patient is never
/// treated. The allergy banner is the one place red is used on purpose.
class PatientHeader extends StatelessWidget {
  const PatientHeader(this.patient, {super.key});

  final Patient patient;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.infoBg,
                child: Text(
                  patient.name.isEmpty ? '?' : patient.name[0].toUpperCase(),
                  style: const TextStyle(
                    color: AppColors.brand,
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      patient.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Age ${patient.age}  |  ${patient.sex}  |  '
                      '${patient.number}  |  ${patient.phone}',
                      style: const TextStyle(color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (patient.allergies.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.dangerBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: AppColors.danger,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Allergy: ${patient.allergies.join(', ')}',
                      style: const TextStyle(
                        color: AppColors.danger,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
