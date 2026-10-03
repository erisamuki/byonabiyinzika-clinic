import 'package:flutter/material.dart';

import '../models/models.dart';
import '../theme/app_colors.dart';

/// Soft chip with a text label, so meaning never depends on colour alone.
class StatusChip extends StatelessWidget {
  const StatusChip(this.status, {super.key});

  final VisitStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, fg, bg) = switch (status) {
      VisitStatus.waiting => ('Waiting', AppColors.warning, AppColors.warningBg),
      VisitStatus.withNurse => ('With nurse', AppColors.info, AppColors.infoBg),
      VisitStatus.withDoctor => ('With doctor', AppColors.info, AppColors.infoBg),
      VisitStatus.toPay => ('To pay', AppColors.warning, AppColors.warningBg),
      VisitStatus.toLab => ('To lab', AppColors.info, AppColors.infoBg),
      VisitStatus.toPharmacy => ('To pharmacy', AppColors.info, AppColors.infoBg),
      VisitStatus.done => ('Done', AppColors.success, AppColors.successBg),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(color: fg, fontWeight: FontWeight.w600, fontSize: 13),
      ),
    );
  }
}
