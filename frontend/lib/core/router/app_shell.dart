import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/auth_controller.dart';
import '../models/models.dart';
import '../theme/app_colors.dart';
import '../widgets/patient_search_bar.dart';
import 'nav_items.dart';

/// Left menu + top bar around every signed-in screen.
class AppShell extends ConsumerWidget {
  const AppShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider);
    if (user == null) return const SizedBox.shrink();

    final location = GoRouterState.of(context).uri.path;

    return Scaffold(
      body: Row(
        children: [
          _SideMenu(items: navItemsFor(user.role), location: location),
          const VerticalDivider(width: 1),
          Expanded(
            child: Column(
              children: [
                _TopBar(user: user),
                const Divider(height: 1),
                Expanded(child: child),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SideMenu extends StatelessWidget {
  const _SideMenu({required this.items, required this.location});

  final List<NavItem> items;
  final String location;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 104,
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 20),
          const Icon(Icons.local_hospital, color: AppColors.brand, size: 32),
          const SizedBox(height: 24),
          for (final item in items)
            _MenuButton(item: item, selected: location == item.route),
        ],
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  const _MenuButton({required this.item, required this.selected});

  final NavItem item;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.brand : AppColors.textMuted;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.go(item.route),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? AppColors.infoBg : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Icon(item.icon, color: color),
              const SizedBox(height: 4),
              Text(
                item.label,
                style: TextStyle(
                  fontSize: 12,
                  color: color,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopBar extends ConsumerWidget {
  const _TopBar({required this.user});

  final AppUser user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 76,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: user.role == UserRole.owner
                  ? const SizedBox.shrink()
                  : const PatientSearchBar(),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                user.name,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(
                user.role.label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
          IconButton(
            tooltip: 'Sign out',
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authProvider.notifier).logout(),
          ),
        ],
      ),
    );
  }
}
