import 'package:flutter/material.dart';

enum ProductCategory { headwear, footwear, accessories }

extension ProductCategoryX on ProductCategory {
  String get label {
    switch (this) {
      case ProductCategory.headwear:
        return 'Headwear';
      case ProductCategory.footwear:
        return 'Footwear';
      case ProductCategory.accessories:
        return 'Accessories';
    }
  }

  IconData get icon {
    switch (this) {
      case ProductCategory.headwear:
        return Icons.checkroom_rounded;
      case ProductCategory.footwear:
        return Icons.ice_skating_rounded;
      case ProductCategory.accessories:
        return Icons.shopping_bag_rounded;
    }
  }
}

class Product {
  final String id;
  final String name;
  final ProductCategory category;
  final String image;
  final double price;
  final String description;
  final List<String> sizes;
  final List<Color> colours;
  final bool isNew;
  final double rating;

  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.image,
    required this.price,
    required this.description,
    required this.sizes,
    required this.colours,
    this.isNew = false,
    this.rating = 4.8,
  });
}
