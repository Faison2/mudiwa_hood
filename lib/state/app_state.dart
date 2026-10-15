import 'package:flutter/material.dart';
import '../data/products.dart';

class AppState extends ChangeNotifier {
  final Map<String, int> _cart = {};
  final Set<String> _wishlist = {};

  Map<String, int> get cart => Map.unmodifiable(_cart);
  Set<String> get wishlist => Set.unmodifiable(_wishlist);

  int get cartCount => _cart.values.fold(0, (a, b) => a + b);

  double get cartSubtotal {
    double total = 0;
    for (final entry in _cart.entries) {
      total += productById(entry.key).price * entry.value;
    }
    return total;
  }

  void addToCart(String id, {int quantity = 1}) {
    _cart[id] = (_cart[id] ?? 0) + quantity;
    notifyListeners();
  }

  void incrementCartItem(String id) {
    _cart[id] = (_cart[id] ?? 0) + 1;
    notifyListeners();
  }

  void decrementCartItem(String id) {
    if (!_cart.containsKey(id)) return;
    if (_cart[id] == 1) {
      _cart.remove(id);
    } else {
      _cart[id] = _cart[id]! - 1;
    }
    notifyListeners();
  }

  void removeFromCart(String id) {
    _cart.remove(id);
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  bool isWishlisted(String id) => _wishlist.contains(id);

  void toggleWishlist(String id) {
    if (_wishlist.contains(id)) {
      _wishlist.remove(id);
    } else {
      _wishlist.add(id);
    }
    notifyListeners();
  }
}

class AppScope extends InheritedNotifier<AppState> {
  const AppScope({super.key, required AppState state, required super.child})
      : super(notifier: state);

  static AppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'No AppScope found in context');
    return scope!.notifier!;
  }
}
