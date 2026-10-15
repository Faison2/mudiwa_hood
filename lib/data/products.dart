import 'package:flutter/material.dart';
import '../models/product.dart';

/// Placeholder catalog — prices are illustrative, not live pricing.
final List<Product> catalog = [
  Product(
    id: 'statue-boots',
    name: 'Statue Suede Boots',
    category: ProductCategory.footwear,
    image: 'assets/images/boots.png',
    price: 128,
    isNew: true,
    rating: 4.9,
    description:
        'Premium suede high-tops with a studded strap closure and a cushioned white midsole. '
        'Built for the street, finished like a statement piece.',
    sizes: const ['S', 'M', 'L', 'XL', 'XXL'],
    colours: const [Color(0xFF0C3B3A), Color(0xFF1C1C1F), Color(0xFF5A4632)],
  ),
  Product(
    id: 'crest-slides',
    name: 'Crest Pool Slides',
    category: ProductCategory.footwear,
    image: 'assets/images/slides.png',
    price: 42,
    rating: 4.6,
    description:
        'Lightweight slip-on slides with the MH crest moulded across the strap. '
        'Soft footbed, durable outsole, easy rinse-and-wear comfort.',
    sizes: const ['S', 'M', 'L', 'XL'],
    colours: const [Color(0xFF1540C4), Color(0xFF1C1C1F), Color(0xFFE7E5DD)],
  ),
  Product(
    id: 'classic-white-cap',
    name: 'Classic Crest Cap',
    category: ProductCategory.headwear,
    image: 'assets/images/caps.png',
    price: 34,
    isNew: true,
    rating: 4.8,
    description:
        'A clean six-panel cap in brushed cotton twill with a 3D embroidered MH crest '
        'and an adjustable strap for an all-day fit.',
    sizes: const ['One Size'],
    colours: const [Color(0xFFFAFAF7), Color(0xFF1C1C1F), Color(0xFFC9A227)],
  ),
  Product(
    id: 'stone-grey-cap',
    name: 'Stone Grey Cap',
    category: ProductCategory.headwear,
    image: 'assets/images/img_2.png',
    price: 29,
    rating: 4.5,
    description:
        'Stone-grey dad cap with a raised MH logo patch and a soft unstructured crown '
        'that breaks in fast and wears easy.',
    sizes: const ['One Size'],
    colours: const [Color(0xFFBFBDB4), Color(0xFF1C1C1F)],
  ),
  Product(
    id: 'red-ribbed-beanie',
    name: 'Red Ribbed Beanie',
    category: ProductCategory.headwear,
    image: 'assets/images/img.png',
    price: 26,
    rating: 4.7,
    description:
        'Chunky ribbed-knit beanie in signature red with a tonal MH logo. '
        'Stretch-fit knit keeps it snug through the cold months.',
    sizes: const ['One Size'],
    colours: const [Color(0xFFC21E2B), Color(0xFF1C1C1F)],
  ),
  Product(
    id: 'black-ribbed-beanie',
    name: 'Black Ribbed Beanie',
    category: ProductCategory.headwear,
    image: 'assets/images/img_1.png',
    price: 26,
    rating: 4.8,
    description:
        'The same chunky ribbed-knit silhouette in blackout colourway, with a clean '
        'white-on-black embroidered crest.',
    sizes: const ['One Size'],
    colours: const [Color(0xFF1C1C1F), Color(0xFFC9A227)],
  ),
  Product(
    id: 'crew-socks',
    name: 'MH Crew Socks',
    category: ProductCategory.accessories,
    image: 'assets/images/socks.png',
    price: 14,
    rating: 4.4,
    description:
        'Cushioned crew socks in heavyweight cotton with a woven MH logo and '
        '"inspiring greatness" knit along the sole.',
    sizes: const ['S', 'M', 'L'],
    colours: const [Color(0xFF1C1C1F), Color(0xFFFAFAF7)],
  ),
  Product(
    id: 'steel-bottle',
    name: 'Steel Hydro Bottle',
    category: ProductCategory.accessories,
    image: 'assets/images/bottle.png',
    price: 38,
    isNew: true,
    rating: 4.9,
    description:
        'Double-walled stainless steel bottle, keeps drinks cold for 24 hours. '
        'Printed with "provoke. inspire. motivate." — made for the grind.',
    sizes: const ['One Size'],
    colours: const [Color(0xFF1540C4), Color(0xFF1C1C1F)],
  ),
];

Product productById(String id) => catalog.firstWhere((p) => p.id == id);
