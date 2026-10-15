import 'package:flutter/material.dart';
import '../data/products.dart';
import '../models/product.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import 'product_detail_screen.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppScope.of(context);
    final items = catalog.where((p) => appState.isWishlisted(p.id)).toList();

    return SafeArea(
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 18, 20, 4),
            child: Text('Your Wishlist', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
            child: Text(
              '${items.length} piece${items.length == 1 ? '' : 's'} saved for later',
              style: const TextStyle(color: AppColors.muted, fontSize: 13),
            ),
          ),
          Expanded(
            child: items.isEmpty
                ? const _EmptyState(
                    icon: Icons.favorite_border_rounded,
                    title: 'Nothing saved yet',
                    subtitle: 'Tap the heart on any piece to save it here.',
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 6, 20, 130),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 14),
                    itemBuilder: (context, i) => _WishlistRow(product: items[i]),
                  ),
          ),
        ],
      ),
    );
  }
}

class _WishlistRow extends StatelessWidget {
  final Product product;
  const _WishlistRow({required this.product});

  @override
  Widget build(BuildContext context) {
    final appState = AppScope.of(context);
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product)),
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 14, offset: const Offset(0, 6)),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 72,
              height: 72,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14)),
              child: Image.asset(product.image, fit: BoxFit.contain),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.category.label.toUpperCase(),
                    style: const TextStyle(fontSize: 10, color: AppColors.gold, fontWeight: FontWeight.w800, letterSpacing: 1),
                  ),
                  const SizedBox(height: 2),
                  Text(product.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5)),
                  const SizedBox(height: 4),
                  Text('\$${product.price.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.w800)),
                ],
              ),
            ),
            Column(
              children: [
                GestureDetector(
                  onTap: () => appState.toggleWishlist(product.id),
                  child: const Icon(Icons.favorite_rounded, color: AppColors.danger, size: 20),
                ),
                const SizedBox(height: 14),
                GestureDetector(
                  onTap: () {
                    appState.addToCart(product.id);
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: AppColors.ink,
                        content: Text('${product.name} added to cart'),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(color: AppColors.ink, shape: BoxShape.circle),
                    child: const Icon(Icons.add_shopping_cart_rounded, color: AppColors.gold, size: 15),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const _EmptyState({required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(color: AppColors.card, shape: BoxShape.circle),
              child: Icon(icon, size: 34, color: AppColors.muted),
            ),
            const SizedBox(height: 18),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
            const SizedBox(height: 6),
            Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.muted, fontSize: 13, height: 1.4)),
          ],
        ),
      ),
    );
  }
}
