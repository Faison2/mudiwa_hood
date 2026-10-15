import 'dart:async';

import 'package:flutter/material.dart';
import '../data/products.dart';
import '../models/product.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_nav_bar.dart';
import '../widgets/product_card.dart';
import 'product_detail_screen.dart';

class _PromoSlide {
  final String image;
  final String eyebrow;
  final String title;
  final String cta;
  final Product product;

  const _PromoSlide({
    required this.image,
    required this.eyebrow,
    required this.title,
    required this.cta,
    required this.product,
  });
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  ProductCategory? _selectedCategory;
  String _query = '';

  late final AnimationController _entrance;
  final PageController _promoController = PageController();
  Timer? _promoTimer;
  int _promoPage = 0;

  late final List<_PromoSlide> _promoSlides = [
    _PromoSlide(
      image: 'assets/images/hoodies.png',
      eyebrow: 'NEW DROP',
      title: 'Statue Collection',
      cta: 'Shop Now',
      product: productById('statue-boots'),
    ),
    _PromoSlide(
      image: 'assets/images/boots.png',
      eyebrow: 'FRESH FIT',
      title: 'Statue Suede Boots',
      cta: 'View Boots',
      product: productById('statue-boots'),
    ),
    _PromoSlide(
      image: 'assets/images/bottle.png',
      eyebrow: 'GEAR UP',
      title: 'Hydrate In Style',
      cta: 'Shop Bottle',
      product: productById('steel-bottle'),
    ),
  ];

  List<Product> get _filtered {
    return catalog.where((p) {
      final matchesCategory =
          _selectedCategory == null || p.category == _selectedCategory;
      final matchesQuery =
          _query.isEmpty || p.name.toLowerCase().contains(_query.toLowerCase());
      return matchesCategory && matchesQuery;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _entrance = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
    _promoTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!_promoController.hasClients) return;
      final next = (_promoPage + 1) % _promoSlides.length;
      _promoController.animateToPage(
        next,
        duration: const Duration(milliseconds: 550),
        curve: Curves.easeOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _entrance.dispose();
    _promoTimer?.cancel();
    _promoController.dispose();
    super.dispose();
  }

  String get _greeting {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good morning';
    if (h < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppScope.of(context);
    final filtered = _filtered;

    return SafeArea(
      bottom: false,
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _DashboardHeader(greeting: _greeting, appState: appState),
                  const SizedBox(height: 20),
                  _SearchBar(onChanged: (v) => setState(() => _query = v)),
                  const SizedBox(height: 20),
                  _CategoryRow(
                    selected: _selectedCategory,
                    onSelect: (c) => setState(() => _selectedCategory = c),
                  ),
                  const SizedBox(height: 22),
                  _PromoCarousel(
                    slides: _promoSlides,
                    controller: _promoController,
                    currentPage: _promoPage,
                    onPageChanged: (i) => setState(() => _promoPage = i),
                  ),
                  const SizedBox(height: 28),
                  _SectionHeader(
                    title: 'Trending Now',
                    onViewAll: () => setState(() => _selectedCategory = null),
                  ),
                  const SizedBox(height: 14),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
            sliver: filtered.isEmpty
                ? const SliverToBoxAdapter(child: _EmptyResults())
                : SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.66,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, i) => _StaggeredItem(
                        index: i,
                        controller: _entrance,
                        child: ProductCard(product: filtered[i]),
                      ),
                      childCount: filtered.length,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _StaggeredItem extends StatelessWidget {
  final int index;
  final AnimationController controller;
  final Widget child;

  const _StaggeredItem({
    required this.index,
    required this.controller,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final start = (index * 0.08).clamp(0.0, 0.6);
    final end = (start + 0.45).clamp(0.0, 1.0);
    final animation = CurvedAnimation(
      parent: controller,
      curve: Interval(start, end, curve: Curves.easeOutCubic),
    );
    return AnimatedBuilder(
      animation: animation,
      builder: (context, c) => Opacity(
        opacity: animation.value,
        child: Transform.translate(
          offset: Offset(0, (1 - animation.value) * 24),
          child: c,
        ),
      ),
      child: child,
    );
  }
}

class _EmptyResults extends StatelessWidget {
  const _EmptyResults();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Column(
        children: [
          Icon(Icons.search_off_rounded, size: 46, color: AppColors.muted.withValues(alpha: 0.6)),
          const SizedBox(height: 12),
          const Text('No pieces match that search', style: TextStyle(color: AppColors.muted)),
        ],
      ),
    );
  }
}

class _DashboardHeader extends StatelessWidget {
  final String greeting;
  final AppState appState;
  const _DashboardHeader({required this.greeting, required this.appState});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      decoration: BoxDecoration(
        gradient: AppColors.inkGradient,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.22),
            blurRadius: 26,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned(
            right: -46,
            top: -46,
            child: Container(
              width: 170,
              height: 170,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [AppColors.gold.withValues(alpha: 0.28), Colors.transparent],
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      width: 46,
                      height: 46,
                      color: Colors.white.withValues(alpha: 0.06),
                      padding: const EdgeInsets.all(6),
                      child: Image.asset('assets/images/splash_logo.png', fit: BoxFit.contain),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          greeting,
                          style: const TextStyle(
                            color: Colors.white60,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Text(
                          'MUDIWA HOOD',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const GlassIconButton(
                    icon: Icons.notifications_none_rounded,
                    iconColor: Colors.white,
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: _StatPill(
                      icon: Icons.favorite_rounded,
                      label: 'Wishlist',
                      value: '${appState.wishlist.length}',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _StatPill(
                      icon: Icons.shopping_bag_rounded,
                      label: 'In Cart',
                      value: '${appState.cartCount}',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _StatPill(
                      icon: Icons.local_fire_department_rounded,
                      label: 'New Drops',
                      value: '${catalog.where((p) => p.isNew).length}',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _StatPill({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.gold, size: 16),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16)),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white54, fontSize: 10.5, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;
  const _SearchBar({required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.line),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.search_rounded, color: AppColors.muted, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              onChanged: onChanged,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Find your gear',
                hintStyle: TextStyle(color: AppColors.muted, fontSize: 14.5),
                isDense: true,
              ),
              style: const TextStyle(fontSize: 14.5),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(color: AppColors.card, shape: BoxShape.circle),
            child: const Icon(Icons.tune_rounded, size: 16, color: AppColors.ink),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onViewAll;
  const _SectionHeader({required this.title, required this.onViewAll});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 18,
              decoration: BoxDecoration(
                gradient: AppColors.goldGradient,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(width: 8),
            Text(title, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),
          ],
        ),
        GestureDetector(
          onTap: onViewAll,
          child: Row(
            children: const [
              Text(
                'View All',
                style: TextStyle(color: AppColors.gold, fontWeight: FontWeight.w700, fontSize: 13),
              ),
              SizedBox(width: 2),
              Icon(Icons.arrow_forward_rounded, size: 16, color: AppColors.gold),
            ],
          ),
        ),
      ],
    );
  }
}

class _CategoryRow extends StatelessWidget {
  final ProductCategory? selected;
  final ValueChanged<ProductCategory?> onSelect;
  const _CategoryRow({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final items = <MapEntry<String, ProductCategory?>>[
      const MapEntry('All', null),
      ...ProductCategory.values.map((c) => MapEntry(c.label, c)),
    ];

    return SizedBox(
      height: 54,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, i) {
          final entry = items[i];
          final active = entry.value == selected;
          final icon = entry.value?.icon ?? Icons.apps_rounded;
          return GestureDetector(
            onTap: () => onSelect(entry.value),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              padding: const EdgeInsets.only(left: 6, right: 16),
              decoration: BoxDecoration(
                gradient: active ? AppColors.goldGradient : null,
                color: active ? null : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: active ? Colors.transparent : AppColors.line),
                boxShadow: active
                    ? [
                        BoxShadow(
                          color: AppColors.gold.withValues(alpha: 0.35),
                          blurRadius: 14,
                          offset: const Offset(0, 6),
                        ),
                      ]
                    : [],
              ),
              alignment: Alignment.center,
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: active ? AppColors.ink : AppColors.card,
                      border: Border.all(
                        color: active ? Colors.white.withValues(alpha: 0.5) : AppColors.line,
                      ),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Icon(icon, size: 16, color: active ? AppColors.gold : AppColors.muted),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    entry.key,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.ink),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _PromoCarousel extends StatelessWidget {
  final List<_PromoSlide> slides;
  final PageController controller;
  final int currentPage;
  final ValueChanged<int> onPageChanged;

  const _PromoCarousel({
    required this.slides,
    required this.controller,
    required this.currentPage,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          PageView.builder(
            controller: controller,
            onPageChanged: onPageChanged,
            itemCount: slides.length,
            itemBuilder: (context, i) => _PromoSlideCard(slide: slides[i]),
          ),
          Positioned(
            right: 14,
            top: 14,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: List.generate(slides.length, (i) {
                  final active = i == currentPage;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    margin: EdgeInsets.only(left: i == 0 ? 0 : 5),
                    width: active ? 16 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: active ? AppColors.gold : Colors.white.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PromoSlideCard extends StatelessWidget {
  final _PromoSlide slide;
  const _PromoSlideCard({required this.slide});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => ProductDetailScreen(product: slide.product)),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.18),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(slide.image, fit: BoxFit.cover),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.80),
                    Colors.black.withValues(alpha: 0.05),
                  ],
                  stops: const [0, 0.65],
                ),
              ),
            ),
            Positioned(
              left: 18,
              right: 18,
              bottom: 16,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          slide.eyebrow,
                          style: const TextStyle(
                            color: AppColors.gold,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          slide.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      gradient: AppColors.goldGradient,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      slide.cta,
                      style: const TextStyle(
                        color: AppColors.ink,
                        fontWeight: FontWeight.w800,
                        fontSize: 12.5,
                      ),
                    ),
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
