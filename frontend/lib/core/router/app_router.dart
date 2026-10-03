import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/auth_controller.dart';
import '../../features/auth/login_screen.dart';
import '../../features/cashier/cashier_home.dart';
import '../../features/doctor/doctor_home.dart';
import '../../features/nurse/nurse_home.dart';
import '../../features/owner/owner_dashboard.dart';
import '../../features/reception/reception_home.dart';
import '../../features/reception/registration_screen.dart';
import '../../features/work_queue/lab_home.dart';
import '../../features/work_queue/pharmacy_home.dart';
import '../models/models.dart';
import 'app_shell.dart';
import 'nav_items.dart';

/// Instant page switches feel faster at a busy front desk.
Page<void> _page(Widget child) => NoTransitionPage<void>(child: child);

final routerProvider = Provider<GoRouter>((ref) {
  final user = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final location = state.matchedLocation;

      if (user == null) return location == '/login' ? null : '/login';

      final allowed = navItemsFor(user.role).map((item) => item.route);
      if (location == '/login' ||
          location == '/' ||
          !allowed.contains(location)) {
        return user.role.homeRoute;
      }
      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/', builder: (_, __) => const SizedBox.shrink()),
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: '/reception',
            pageBuilder: (_, __) => _page(const ReceptionHome()),
          ),
          GoRoute(
            path: '/register',
            pageBuilder: (_, __) => _page(const RegistrationScreen()),
          ),
          GoRoute(
            path: '/nurse',
            pageBuilder: (_, __) => _page(const NurseHome()),
          ),
          GoRoute(
            path: '/doctor',
            pageBuilder: (_, __) => _page(const DoctorHome()),
          ),
          GoRoute(
            path: '/cashier',
            pageBuilder: (_, __) => _page(const CashierHome()),
          ),
          GoRoute(
            path: '/lab',
            pageBuilder: (_, __) => _page(const LabHome()),
          ),
          GoRoute(
            path: '/pharmacy',
            pageBuilder: (_, __) => _page(const PharmacyHome()),
          ),
          GoRoute(
            path: '/owner',
            pageBuilder: (_, __) => _page(const OwnerDashboard()),
          ),
        ],
      ),
    ],
  );
});
