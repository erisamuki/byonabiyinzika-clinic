import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/models.dart';

class AuthController extends Notifier<AppUser?> {
  @override
  AppUser? build() => null;

  static const _demoRoles = {
    'reception': UserRole.reception,
    'nurse': UserRole.nurse,
    'doctor': UserRole.doctor,
    'cashier': UserRole.cashier,
    'lab': UserRole.lab,
    'pharmacy': UserRole.pharmacy,
    'owner': UserRole.owner,
  };

  /// Demo sign-in only. Replace with POST /auth/login when the backend is
  /// ready, and store the returned token in tokenProvider.
  Future<bool> login(String username, String password) async {
    final role = _demoRoles[username.trim().toLowerCase()];
    if (role == null || password != 'clinic123') return false;

    state = AppUser(
      id: username.trim().toLowerCase(),
      name: 'Demo ${role.label}',
      role: role,
    );
    return true;
  }

  void logout() => state = null;
}

final authProvider = NotifierProvider<AuthController, AppUser?>(
  AuthController.new,
);
