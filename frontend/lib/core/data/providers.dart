import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/models.dart';
import 'clinic_repository.dart';
import 'mock_clinic_repository.dart';

/// Swap MockClinicRepository for the real API repository here later.
final clinicRepositoryProvider = Provider<ClinicRepository>(
  (ref) => MockClinicRepository(),
);

final queueProvider = FutureProvider<List<QueueItem>>(
  (ref) => ref.watch(clinicRepositoryProvider).todayQueue(),
);

final invoicesProvider = FutureProvider<List<Invoice>>(
  (ref) => ref.watch(clinicRepositoryProvider).unpaidInvoices(),
);

final workItemsProvider = FutureProvider.family<List<WorkItem>, String>(
  (ref, kind) => ref.watch(clinicRepositoryProvider).paidOrders(kind),
);

final incomeProvider = FutureProvider<IncomeSummary>(
  (ref) => ref.watch(clinicRepositoryProvider).incomeSummary(),
);
