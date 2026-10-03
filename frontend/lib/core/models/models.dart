enum UserRole { reception, nurse, doctor, cashier, lab, pharmacy, owner }

extension UserRoleX on UserRole {
  String get label => switch (this) {
        UserRole.reception => 'Reception',
        UserRole.nurse => 'Nurse',
        UserRole.doctor => 'Doctor',
        UserRole.cashier => 'Cashier',
        UserRole.lab => 'Lab technician',
        UserRole.pharmacy => 'Pharmacist',
        UserRole.owner => 'Owner',
      };

  String get homeRoute => '/$name';
}

class AppUser {
  const AppUser({required this.id, required this.name, required this.role});

  final String id;
  final String name;
  final UserRole role;
}

class Patient {
  const Patient({
    required this.id,
    required this.number,
    required this.name,
    required this.sex,
    required this.dateOfBirth,
    required this.phone,
    this.allergies = const [],
  });

  final String id;
  final String number;
  final String name;
  final String sex;
  final DateTime dateOfBirth;
  final String phone;
  final List<String> allergies;

  int get age {
    final now = DateTime.now();
    var years = now.year - dateOfBirth.year;
    final hadBirthday = now.month > dateOfBirth.month ||
        (now.month == dateOfBirth.month && now.day >= dateOfBirth.day);
    if (!hadBirthday) years--;
    return years;
  }
}

enum VisitStatus { waiting, withNurse, withDoctor, toPay, toLab, toPharmacy, done }

enum VisitType { newVisit, review, emergency }

class QueueItem {
  const QueueItem({
    required this.patient,
    required this.status,
    required this.type,
    required this.since,
  });

  final Patient patient;
  final VisitStatus status;
  final VisitType type;
  final DateTime since;
}

class InvoiceLine {
  const InvoiceLine(this.description, this.amount);

  final String description;
  final int amount;
}

class Invoice {
  const Invoice({required this.id, required this.patient, required this.lines});

  final String id;
  final Patient patient;
  final List<InvoiceLine> lines;

  int get total => lines.fold(0, (sum, line) => sum + line.amount);
}

/// A paid or insurance-approved order waiting in lab or pharmacy.
class WorkItem {
  const WorkItem({
    required this.id,
    required this.patient,
    required this.description,
  });

  final String id;
  final Patient patient;
  final String description;
}

class IncomeSummary {
  const IncomeSummary({
    required this.today,
    required this.week,
    required this.month,
    required this.byMethod,
    required this.newPatients,
    required this.reviewPatients,
    required this.lowStock,
  });

  final int today;
  final int week;
  final int month;
  final Map<String, int> byMethod;
  final int newPatients;
  final int reviewPatients;
  final List<String> lowStock;
}
