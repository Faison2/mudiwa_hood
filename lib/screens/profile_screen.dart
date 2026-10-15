import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppScope.of(context);
    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 140),
        children: [
          const Text('Profile', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
          const SizedBox(height: 22),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppColors.inkGradient,
              borderRadius: BorderRadius.circular(26),
            ),
            child: Row(
              children: [
                Container(
                  width: 62,
                  height: 62,
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                  child: Image.asset('assets/images/logo.png', fit: BoxFit.contain),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Mudiwa Explorer', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16)),
                      SizedBox(height: 4),
                      Text('inspiring greatness', style: TextStyle(color: AppColors.gold, fontSize: 12.5, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                const Icon(Icons.edit_rounded, color: Colors.white54, size: 18),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _StatTile(
                  label: 'Wishlist',
                  value: '${appState.wishlist.length}',
                  icon: Icons.favorite_rounded,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatTile(
                  label: 'In Cart',
                  value: '${appState.cartCount}',
                  icon: Icons.shopping_bag_rounded,
                ),
              ),
            ],
          ),
          const SizedBox(height: 26),
          const _SectionLabel('Account'),
          const SizedBox(height: 10),
          _MenuCard(items: const [
            _MenuData(Icons.receipt_long_rounded, 'My Orders'),
            _MenuData(Icons.location_on_outlined, 'Delivery Addresses'),
            _MenuData(Icons.credit_card_rounded, 'Payment Methods'),
          ]),
          const SizedBox(height: 22),
          const _SectionLabel('Preferences'),
          const SizedBox(height: 10),
          _MenuCard(items: const [
            _MenuData(Icons.notifications_none_rounded, 'Notifications'),
            _MenuData(Icons.settings_outlined, 'Settings'),
            _MenuData(Icons.help_outline_rounded, 'Help & Support'),
          ]),
          const SizedBox(height: 22),
          _MenuCard(items: const [
            _MenuData(Icons.logout_rounded, 'Log Out', danger: true),
          ]),
          const SizedBox(height: 28),
          const Center(
            child: Text(
              'MUDIWA HOOD',
              style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 2, color: AppColors.muted, fontSize: 12),
            ),
          ),
          const SizedBox(height: 4),
          const Center(
            child: Text('v1.0.0', style: TextStyle(color: AppColors.muted, fontSize: 11)),
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  const _StatTile({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 14, offset: const Offset(0, 6)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: const BoxDecoration(color: AppColors.card, shape: BoxShape.circle),
            child: Icon(icon, size: 17, color: AppColors.gold),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
              Text(label, style: const TextStyle(color: AppColors.muted, fontSize: 11.5)),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(color: AppColors.muted, fontSize: 11.5, fontWeight: FontWeight.w800, letterSpacing: 1.2),
    );
  }
}

class _MenuData {
  final IconData icon;
  final String label;
  final bool danger;
  const _MenuData(this.icon, this.label, {this.danger = false});
}

class _MenuCard extends StatelessWidget {
  final List<_MenuData> items;
  const _MenuCard({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 14, offset: const Offset(0, 6)),
        ],
      ),
      child: Column(
        children: List.generate(items.length, (i) {
          final item = items[i];
          return Column(
            children: [
              ListTile(
                onTap: () {},
                leading: Icon(item.icon, color: item.danger ? AppColors.danger : AppColors.ink, size: 20),
                title: Text(
                  item.label,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: item.danger ? AppColors.danger : AppColors.ink,
                  ),
                ),
                trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.muted, size: 20),
              ),
              if (i != items.length - 1) const Divider(height: 1, indent: 56, color: AppColors.line),
            ],
          );
        }),
      ),
    );
  }
}
