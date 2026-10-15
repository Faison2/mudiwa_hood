import 'dart:ui';
import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';

class _NavItem {
  final IconData filled;
  final IconData outline;
  final String label;
  const _NavItem(this.filled, this.outline, this.label);
}

const _navItems = [
  _NavItem(Icons.home_rounded, Icons.home_outlined, 'Home'),
  _NavItem(Icons.favorite_rounded, Icons.favorite_border_rounded, 'Saved'),
  _NavItem(Icons.shopping_bag_rounded, Icons.shopping_bag_outlined, 'Cart'),
  _NavItem(Icons.person_rounded, Icons.person_outline_rounded, 'Profile'),
];

/// Floating "liquid glass" style bottom navigation bar — frosted, translucent,
/// with a soft gold-lit pill highlighting the active tab.
class GlassNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const GlassNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final appState = AppScope.of(context);
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 0, 22, 14),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(34),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(34),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withValues(alpha: 0.62),
                    Colors.white.withValues(alpha: 0.30),
                  ],
                ),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.75),
                  width: 1.3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.10),
                    blurRadius: 30,
                    offset: const Offset(0, 16),
                  ),
                  BoxShadow(
                    color: Colors.white.withValues(alpha: 0.6),
                    blurRadius: 1,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              // Opaque hit-test behavior on the whole bar stops stray taps
              // in the gaps between icons from falling through to content
              // behind it (the body extends under the bar via extendBody).
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(_navItems.length, (i) {
                    final item = _navItems[i];
                    final active = i == currentIndex;
                    final badge = i == 2 ? appState.cartCount : 0;
                    return _GlassNavIcon(
                      icon: active ? item.filled : item.outline,
                      active: active,
                      badge: badge,
                      onTap: () => onTap(i),
                    );
                  }),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GlassNavIcon extends StatelessWidget {
  final IconData icon;
  final bool active;
  final int badge;
  final VoidCallback onTap;

  const _GlassNavIcon({
    required this.icon,
    required this.active,
    required this.badge,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
        width: active ? 54 : 44,
        height: active ? 54 : 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: active ? AppTheme.navActiveGradient : null,
          boxShadow: active
              ? [
                  BoxShadow(
                    color: AppColors.gold.withValues(alpha: 0.4),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ]
              : [],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              icon,
              color: active ? AppColors.gold : const Color(0xFF5B5B60),
              size: active ? 24 : 22,
            ),
            if (badge > 0)
              Positioned(
                top: 4,
                right: 4,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  constraints: const BoxConstraints(minWidth: 15, minHeight: 15),
                  decoration: const BoxDecoration(
                    color: AppColors.danger,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '$badge',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      height: 1.1,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// A small frosted circular icon button used in headers / hero sections.
class GlassIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final Color iconColor;
  final double size;

  const GlassIconButton({
    super.key,
    required this.icon,
    this.onTap,
    this.iconColor = AppColors.ink,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(size),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            width: size,
            height: size,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.5),
              border: Border.all(color: Colors.white.withValues(alpha: 0.7)),
            ),
            child: Icon(icon, color: iconColor, size: size * 0.46),
          ),
        ),
      ),
    );
  }
}
