import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:dukaan_zone_flutter/dukaan.dart';

class UserHomePage extends StatelessWidget {
  const UserHomePage({super.key});

@override
  Widget build(BuildContext context) {
    return AppPage(
      maxWidth: 1180,
      children: [
        const HeroCarousel(),
        const SizedBox(height: 34),
        const Kicker('FRESH & PREMIUM PICKS'),
        const SizedBox(height: 14),
        SizedBox(
          height: 294,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: catalogProducts.length,
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemBuilder: (_, i) => PremiumProductCard(product: catalogProducts[i], onTap: () => push(context, ProductDetailPage(product: catalogProducts[i]))),
          ),
        ),
        const SizedBox(height: 26),
        const Kicker('LIVE NEIGHBORHOOD SHELF'),
        const SizedBox(height: 14),
        const SectionHeader('Trending Now', 'View all'),
        const SizedBox(height: 14),
        ProductCardGrid(products: catalogProducts),
        const SizedBox(height: 40),
      ],
    );
  }
}

