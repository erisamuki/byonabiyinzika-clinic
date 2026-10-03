import '../models/models.dart';
import 'clinic_repository.dart';

/// In-memory sample data so the app runs before the backend exists.
class MockClinicRepository implements ClinicRepository {
  final List<Patient> _patients = [
    Patient(
      id: 'p1',
      number: 'P-000101',
      name: 'Namukasa Grace',
      sex: 'Female',
      dateOfBirth: DateTime(1990, 4, 12),
      phone: '0772000101',
    ),
    Patient(
      id: 'p2',
      number: 'P-000102',
      name: 'Okello Peter',
      sex: 'Male',
      dateOfBirth: DateTime(1978, 9, 3),
      phone: '0701000102',
    ),
    Patient(
      id: 'p3',
      number: 'P-000103',
      name: 'Nakato Brenda',
      sex: 'Female',
      dateOfBirth: DateTime(2016, 1, 25),
      phone: '0753000103',
    ),
    Patient(
      id: 'p4',
      number: 'P-000104',
      name: 'Ssemwogerere David',
      sex: 'Male',
      dateOfBirth: DateTime(1985, 11, 30),
      phone: '0782000104',
    ),
    Patient(
      id: 'p5',
      number: 'P-000105',
      name: 'Atim Joan',
      sex: 'Female',
      dateOfBirth: DateTime(1969, 6, 8),
      phone: '0775000105',
      allergies: ['Penicillin'],
    ),
  ];

  late final List<QueueItem> _queue = [
    _queueItem(0, VisitStatus.waiting, VisitType.review, 14),
    _queueItem(1, VisitStatus.waiting, VisitType.newVisit, 9),
    _queueItem(2, VisitStatus.withDoctor, VisitType.newVisit, 22),
    _queueItem(3, VisitStatus.toPay, VisitType.review, 31),
    _queueItem(4, VisitStatus.withDoctor, VisitType.review, 5),
  ];

  late final List<Invoice> _invoices = [
    Invoice(
      id: 'INV-1001',
      patient: _patients[3],
      lines: const [
        InvoiceLine('Review consultation', 10000),
        InvoiceLine('Malaria test', 10000),
      ],
    ),
    Invoice(
      id: 'INV-1002',
      patient: _patients[2],
      lines: const [
        InvoiceLine('Consultation', 20000),
        InvoiceLine('Amoxicillin syrup', 8000),
      ],
    ),
  ];

  late final Map<String, List<WorkItem>> _work = {
    'lab': [
      WorkItem(
        id: 'L1',
        patient: _patients[3],
        description: 'Malaria test (blood slip)',
      ),
    ],
    'pharmacy': [
      WorkItem(
        id: 'R1',
        patient: _patients[2],
        description: 'Amoxicillin syrup, 5 ml three times a day for 5 days',
      ),
    ],
  };

  QueueItem _queueItem(
    int patientIndex,
    VisitStatus status,
    VisitType type,
    int minutesAgo,
  ) {
    return QueueItem(
      patient: _patients[patientIndex],
      status: status,
      type: type,
      since: DateTime.now().subtract(Duration(minutes: minutesAgo)),
    );
  }

  @override
  Future<List<Patient>> searchPatients(String query) async {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return _patients.take(5).toList();
    return _patients
        .where(
          (p) =>
              p.name.toLowerCase().contains(q) ||
              p.phone.contains(q) ||
              p.number.toLowerCase().contains(q),
        )
        .toList();
  }

  @override
  Future<List<QueueItem>> todayQueue() async => List.of(_queue);

  @override
  Future<List<Patient>> findDuplicates({
    required String name,
    required String phone,
  }) async {
    return _patients
        .where(
          (p) =>
              p.phone == phone || p.name.toLowerCase() == name.toLowerCase(),
        )
        .toList();
  }

  @override
  Future<Patient> registerPatient({
    required String name,
    required String sex,
    required DateTime dateOfBirth,
    required String phone,
    String? nextOfKinName,
    String? nextOfKinPhone,
  }) async {
    final number = 'P-${(101 + _patients.length).toString().padLeft(6, '0')}';
    final patient = Patient(
      id: 'p${_patients.length + 1}',
      number: number,
      name: name,
      sex: sex,
      dateOfBirth: dateOfBirth,
      phone: phone,
    );
    _patients.add(patient);
    _queue.add(
      QueueItem(
        patient: patient,
        status: VisitStatus.waiting,
        type: VisitType.newVisit,
        since: DateTime.now(),
      ),
    );
    return patient;
  }

  @override
  Future<List<Invoice>> unpaidInvoices() async => List.of(_invoices);

  @override
  Future<void> recordPayment({
    required String invoiceId,
    required String method,
  }) async {
    _invoices.removeWhere((i) => i.id == invoiceId);
  }

  @override
  Future<List<WorkItem>> paidOrders(String kind) async =>
      List.of(_work[kind] ?? const []);

  @override
  Future<void> completeWorkItem(String kind, String id) async {
    _work[kind]?.removeWhere((w) => w.id == id);
  }

  @override
  Future<IncomeSummary> incomeSummary() async {
    return const IncomeSummary(
      today: 2450000,
      week: 14200000,
      month: 58900000,
      byMethod: {
        'Cash': 920000,
        'Mobile money': 1180000,
        'Card': 150000,
        'Insurance': 200000,
      },
      newPatients: 118,
      reviewPatients: 164,
      lowStock: ['Amoxicillin 250 mg', 'Paracetamol 500 mg', 'ORS sachets'],
    );
  }
}
