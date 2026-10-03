import '../models/models.dart';

/// Everything the screens need from the backend. Screens only talk to this
/// interface, so swapping the mock for the real API changes one provider.
abstract class ClinicRepository {
  Future<List<Patient>> searchPatients(String query);

  Future<List<QueueItem>> todayQueue();

  Future<List<Patient>> findDuplicates({
    required String name,
    required String phone,
  });

  Future<Patient> registerPatient({
    required String name,
    required String sex,
    required DateTime dateOfBirth,
    required String phone,
    String? nextOfKinName,
    String? nextOfKinPhone,
  });

  Future<List<Invoice>> unpaidInvoices();

  Future<void> recordPayment({
    required String invoiceId,
    required String method,
  });

  /// kind is 'lab' or 'pharmacy'.
  Future<List<WorkItem>> paidOrders(String kind);

  Future<void> completeWorkItem(String kind, String id);

  Future<IncomeSummary> incomeSummary();
}
