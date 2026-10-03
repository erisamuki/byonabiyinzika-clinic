import 'package:flutter/material.dart';

import '../models/models.dart';

class NavItem {
  const NavItem(this.label, this.icon, this.route);

  final String label;
  final IconData icon;
  final String route;
}

/// The left menu for each role. A role can only open its own routes.
List<NavItem> navItemsFor(UserRole role) => switch (role) {
      UserRole.reception => const [
          NavItem('Queue', Icons.people_alt_outlined, '/reception'),
          NavItem('Register', Icons.person_add_alt_1_outlined, '/register'),
        ],
      UserRole.nurse => const [
          NavItem('Triage', Icons.monitor_heart_outlined, '/nurse'),
        ],
      UserRole.doctor => const [
          NavItem('Consults', Icons.medical_services_outlined, '/doctor'),
        ],
      UserRole.cashier => const [
          NavItem('Payments', Icons.payments_outlined, '/cashier'),
        ],
      UserRole.lab => const [
          NavItem('Lab', Icons.science_outlined, '/lab'),
        ],
      UserRole.pharmacy => const [
          NavItem('Pharmacy', Icons.medication_outlined, '/pharmacy'),
        ],
      UserRole.owner => const [
          NavItem('Dashboard', Icons.insights_outlined, '/owner'),
        ],
    };
