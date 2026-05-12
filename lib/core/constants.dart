import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dukaan_zone_flutter/core/theme.dart';
import 'package:dukaan_zone_flutter/models/models.dart';

// ─── Global State ──────────────────────────────────────────
final ValueNotifier<MapState> globalMapState = ValueNotifier(MapState());
final ValueNotifier<String> globalSearchQuery = ValueNotifier('');

final ValueNotifier<List<Map<String, dynamic>>> globalPaymentHistory = ValueNotifier([
  {'merchant': 'Tech Haven', 'date': 'Today, 10:31 AM', 'amount': '₹2,000.00', 'items': 'Noise-Cancelling Pro Earbuds', 'icon': Icons.smartphone_outlined},
  {'merchant': 'Daily Bakes', 'date': 'May 02, 09:10 AM', 'amount': '₹45.00', 'items': 'Butter Croissant', 'icon': Icons.bakery_dining_outlined},
  {'merchant': 'Aman Snacks', 'date': 'April 30, 04:30 PM', 'amount': '₹120.00', 'items': 'Samosa Platter, Tea', 'icon': Icons.restaurant_outlined},
]);

// ─── Mock Product Data ─────────────────────────────────────
const pulseProducts = [
  Product('prod-1', 'Bananas', '₹60.00', 'Pooja General Store', 'Just Restocked', '15 dozen left', Icons.eco, Color(0xFFDCFCE7)),
  Product('prod-3', 'Mixed Veggie Pack', '₹120.00', 'Pooja General Store', 'Fresh', '10 packs left', Icons.shopping_basket, Color(0xFFFFEDD5)),
  Product('prod-4', 'Grade-A Fuji Apples', '₹220.00', 'Pooja General Store', 'Premium', '5 kg left', Icons.local_florist, Color(0xFFFEE2E2)),
  Product('prod-2', 'Noise-Cancelling Pro', '₹12,499.00', 'Tech Haven', 'High Demand', '2 units left', Icons.headphones, Color(0xFFE0E7FF)),
];

const catalogProducts = [
  Product('prod-4', 'Grade-A Fuji Apples (1KG)', '₹220.00', 'Pooja General Store', 'Premium', '5 kg left', Icons.local_florist, Color(0xFFFEE2E2)),
  Product('prod-3', 'Premium Mixed Greens Collection (500g)', '₹120.00', 'Pooja General Store', 'Fresh', '10 units left', Icons.spa, Color(0xFFDFF3E7)),
  Product('prod-1', 'Fresh Organic Bananas (Dozen)', '₹60.00', 'Pooja General Store', 'Just Restocked', '15 dozen left', Icons.eco, Color(0xFFFFF7D6)),
  Product('prod-2', 'Noise Cancelling Earbuds (Space Grey)', '₹12,499.00', 'Tech Haven', 'High Demand', '2 units left', Icons.headphones, Color(0xFFE0E7FF)),
];

const shops = [
  Shop('Pooja General Store', 'Block A', 'Grocery', '4.8', '164', LatLng(17.7300, 83.3160)),
  Shop('Tech Haven', 'Block B', 'Electronics', '4.9', '91', LatLng(17.7285, 83.3130)),
  Shop('Fresh Daily Dairy', 'Block A', 'Essentials', '4.7', '118', LatLng(17.7270, 83.3180)),
];

// ─── Helper Navigation ─────────────────────────────────────
Future<T?> push<T>(BuildContext context, Widget page) =>
    Navigator.of(context).push<T>(PageRouteBuilder<T>(
      pageBuilder: (_, __, ___) => page,
      transitionDuration: const Duration(milliseconds: 240),
      reverseTransitionDuration: const Duration(milliseconds: 200),
      transitionsBuilder: (_, animation, secondaryAnimation, child) {
        final slide = Tween<Offset>(
          begin: const Offset(0, 0.05),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));
        return FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
          child: SlideTransition(position: slide, child: child),
        );
      },
    ));
