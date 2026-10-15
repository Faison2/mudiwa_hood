import 'package:flutter/material.dart';
import '../data/products.dart';
import '../models/product.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_nav_bar.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen>
    with SingleTickerProviderStateMixin {
  late String _selectedSize;
  late int _selectedColour;
  int _quantity = 1;
  late TabController _tabController;

  Product get product => widget.product;

  @override
  void initState() {
    super.initState();
    _selectedSize = product.sizes.first;
    _selectedColour = 0;
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppScope.of(context);
    final related = catalog
        .where((p) => p.category == product.category && p.id != product.id)
        .toList();
    final suggestions = (related.isEmpty
            ? catalog.where((p) => p.id != product.id).toList()
            : related)
        .take(6)
        .toList();

    return Scaffold(
      backgroundColor: AppColors.paper,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: _Hero(
                  product: product,
                  appState: appState,
                  selectedColour: _selectedColour,
                ),
              ),
              SliverToBoxAdapter(
                child: Transform.translate(
                  offset: const Offset(0, -28),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppColors.paper,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                    ),
                    padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _VariantSelectors(
                          product: product,
                          selectedSize: _selectedSize,
                          onSize: (s) => setState(() => _selectedSize = s),
                          selectedColour: _selectedColour,
                          onColour: (i) => setState(() => _selectedColour = i),
                          quantity: _quantity,
                          onQuantity: (q) => setState(() => _quantity = q),
                        ),
                        const SizedBox(height: 22),
                        TabBar(
                          controller: _tabController,
                          labelColor: AppColors.ink,
                          unselectedLabelColor: AppColors.muted,
                          indicatorColor: AppColors.gold,
                          indicatorWeight: 2.6,
                          labelStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                          dividerColor: AppColors.line,
                          tabs: const [Tab(text: 'Details'), Tab(text: 'Reviews')],
                        ),
                        SizedBox(
                          height: 120,
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 14),
                                child: Text(
                                  product.description,
                                  style: const TextStyle(
                                    color: AppColors.muted,
                                    height: 1.55,
                                    fontSize: 13.5,
                                  ),
                                ),
                              ),
                              _ReviewsTab(rating: product.rating),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'You May Like More',
                              style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.w800),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        SizedBox(
                          height: 168,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: suggestions.length,
                            separatorBuilder: (_, __) => const SizedBox(width: 12),
                            itemBuilder: (context, i) {
                              final item = suggestions[i];
                              return _SuggestionCard(product: item);
                            },
                          ),
                        ),
                        const SizedBox(height: 140),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _BottomActionBar(
              product: product,
              quantity: _quantity,
              onAddToCart: () {
                appState.addToCart(product.id, quantity: _quantity);
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: AppColors.ink,
                    content: Text('${product.name} added to cart'),
                  ),
                );
              },
              onBuyNow: () {
                appState.addToCart(product.id, quantity: _quantity);
                _showOrderConfirmation(context, product);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showOrderConfirmation(BuildContext context, Product product) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        margin: const EdgeInsets.all(18),
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                gradient: AppColors.goldGradient,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_rounded, color: AppColors.ink, size: 34),
            ),
            const SizedBox(height: 18),
            const Text('Order Placed!', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Text(
              '${product.name} is on its way to checkout. Thanks for shopping Mudiwa Hood.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.muted, fontSize: 13.5, height: 1.4),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.ink,
                  foregroundColor: AppColors.gold,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('Continue Shopping', style: TextStyle(fontWeight: FontWeight.w800)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  final Product product;
  final AppState appState;
  final int selectedColour;

  const _Hero({required this.product, required this.appState, required this.selectedColour});

  @override
  Widget build(BuildContext context) {
    final wished = appState.isWishlisted(product.id);
    return Container(
      height: 420,
      decoration: const BoxDecoration(
        gradient: AppColors.inkGradient,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(36)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Align(
            alignment: const Alignment(0, -0.3),
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    product.colours[selectedColour].withValues(alpha: 0.35),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GlassIconButton(
                    icon: Icons.arrow_back_ios_new_rounded,
                    iconColor: Colors.white,
                    onTap: () => Navigator.of(context).pop(),
                  ),
                  GlassIconButton(
                    icon: wished ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                    iconColor: wished ? AppColors.danger : Colors.white,
                    onTap: () => appState.toggleWishlist(product.id),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 70,
            left: 0,
            right: 0,
            bottom: 90,
            child: Hero(
              tag: product.id,
              child: Image.asset(product.image, fit: BoxFit.contain),
            ),
          ),
          Positioned(
            left: 22,
            right: 22,
            bottom: 24,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.category.label.toUpperCase(),
                        style: const TextStyle(
                          color: AppColors.gold,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.6,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        product.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 23,
                          fontWeight: FontWeight.w900,
                          height: 1.15,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '\$${product.price.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: AppColors.gold,
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VariantSelectors extends StatelessWidget {
  final Product product;
  final String selectedSize;
  final ValueChanged<String> onSize;
  final int selectedColour;
  final ValueChanged<int> onColour;
  final int quantity;
  final ValueChanged<int> onQuantity;

  const _VariantSelectors({
    required this.product,
    required this.selectedSize,
    required this.onSize,
    required this.selectedColour,
    required this.onColour,
    required this.quantity,
    required this.onQuantity,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Size', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: product.sizes.map((s) {
            final active = s == selectedSize;
            return GestureDetector(
              onTap: () => onSize(s),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: active ? AppColors.ink : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: active ? AppColors.ink : AppColors.line),
                ),
                child: Text(
                  s,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 12.5,
                    color: active ? AppColors.gold : AppColors.ink,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Colour', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
                  const SizedBox(height: 12),
                  Row(
                    children: List.generate(product.colours.length, (i) {
                      final active = i == selectedColour;
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: GestureDetector(
                          onTap: () => onColour(i),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            width: active ? 32 : 26,
                            height: active ? 32 : 26,
                            decoration: BoxDecoration(
                              color: product.colours[i],
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: active ? AppColors.gold : Colors.white,
                                width: active ? 2.4 : 1.4,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.12),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Qty', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.line),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      _QtyButton(
                        icon: Icons.remove_rounded,
                        onTap: () => onQuantity(quantity > 1 ? quantity - 1 : 1),
                      ),
                      SizedBox(
                        width: 28,
                        child: Text(
                          '$quantity',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13.5),
                        ),
                      ),
                      _QtyButton(
                        icon: Icons.add_rounded,
                        onTap: () => onQuantity(quantity + 1),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _QtyButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Icon(icon, size: 15, color: AppColors.ink),
      ),
    );
  }
}

class _ReviewsTab extends StatelessWidget {
  final double rating;
  const _ReviewsTab({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        children: [
          Text(
            rating.toStringAsFixed(1),
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: List.generate(5, (i) {
                  final filled = i < rating.round();
                  return Icon(
                    filled ? Icons.star_rounded : Icons.star_border_rounded,
                    color: AppColors.gold,
                    size: 17,
                  );
                }),
              ),
              const SizedBox(height: 4),
              const Text(
                'Loved by the hood',
                style: TextStyle(color: AppColors.muted, fontSize: 12.5),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SuggestionCard extends StatelessWidget {
  final Product product;
  const _SuggestionCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product)),
      ),
      child: Container(
        width: 128,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
                ),
                child: Image.asset(product.image, fit: BoxFit.contain),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '\$${product.price.toStringAsFixed(0)}',
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: AppColors.goldDeep),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomActionBar extends StatelessWidget {
  final Product product;
  final int quantity;
  final VoidCallback onAddToCart;
  final VoidCallback onBuyNow;

  const _BottomActionBar({
    required this.product,
    required this.quantity,
    required this.onAddToCart,
    required this.onBuyNow,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 24,
              offset: const Offset(0, -6),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: onAddToCart,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: AppColors.ink, width: 1.4),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text(
                  'Add to Cart',
                  style: TextStyle(color: AppColors.ink, fontWeight: FontWeight.w800, fontSize: 13.5),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: onBuyNow,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.ink,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: const Text(
                  'Buy Now',
                  style: TextStyle(color: AppColors.gold, fontWeight: FontWeight.w800, fontSize: 13.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
