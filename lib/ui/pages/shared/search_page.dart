import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:dukaan_zone_flutter/dukaan.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key, required this.role});
  final Role role;

@override
  Widget build(BuildContext context) {
    final hint = role == Role.admin ? 'Search shops, users, listings...' : role == Role.seller ? 'Search products or order IDs...' : 'Search items...';
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bg,
        title: TextField(
          autofocus: true,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search, color: primary),
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none),
          ),
        ),
      ),
      body: AppPage(
        children: [
          const Kicker('TRENDING NEAR YOU'),
          const SizedBox(height: 14),
          for (final product in catalogProducts) CompactProductTile(product: product),
          const SizedBox(height: 18),
          const Kicker('RECENT SEARCHES'),
          const SizedBox(height: 14),
          const Wrap(spacing: 10, runSpacing: 10, children: [
            SearchToken('Organic Milk'),
            SearchToken('Bananas'),
            SearchToken('Earbuds'),
            SearchToken('Mixed Greens'),
          ]),
        ],
      ),
    );
  }
}

