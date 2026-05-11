import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:dukaan_zone_flutter/dukaan.dart';

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({super.key, required this.product});
  final Product product;

@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Immersive Header
            Container(
              height: 400,
              decoration: BoxDecoration(
                color: product.tint,
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Hero(
                      tag: 'product_icon_${product.id}',
                      child: Icon(product.icon, size: 160, color: ink.withValues(alpha: .50)),
                    ),
                  ),
                  // Back button
                  Positioned(
                    left: 16,
                    top: 48,
                    child: GlassRoundIcon(
                      icon: Icons.arrow_back,
                      size: 40,
                      iconSize: 20,
                      onTap: () => Navigator.pop(context),
                    ),
                  ),
                  // Location pin
                  Positioned(
                    left: 16,
                    top: 104,
                    child: GlassRoundIcon(
                      icon: Icons.location_on,
                      size: 40,
                      iconSize: 20,
                      iconColor: primary,
                      onTap: () {
                        // Open map route
                        globalMapState.value = MapState(mode: MapMode.routing, destinationName: product.shop);
                        Navigator.popUntil(context, (route) => route.isFirst); // Go back to root
                      },
                    ),
                  ),
                  // Heart
                  const Positioned(
                    right: 16,
                    top: 48,
                    child: FavoriteButton(size: 40, iconSize: 20),
                  ),
                ],
              ),
            ),
            
            // Product Info
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: ink, height: 1.1),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              product.price,
                              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: success),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Merchant Avatar
                      GestureDetector(
                        onTap: () => push(context, MerchantProfilePage(shopName: product.shop)),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundColor: primary.withValues(alpha: .1),
                              child: const Icon(Icons.storefront, color: primary, size: 28),
                            ),
                            const SizedBox(height: 4),
                            Text(product.shop, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: muted)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // Action Row
                  Row(
                    children: [
                      Expanded(
                        child: GradientButton('Start self-checkout', Icons.qr_code_scanner, () {
                          push(context, CheckoutPage(product: product));
                        }),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Reviews
                  const SectionHeader('Reviews', ''),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: () => push(context, ReviewsPage(productId: product.id)),
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: muted.withValues(alpha: .1)),
                      ),
                      child: FutureBuilder<String>(
                        future: reviewService.getCommunityPulse(product.id),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.auto_awesome, color: primary, size: 24),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  snapshot.data!,
                                  style: const TextStyle(fontSize: 14, color: ink, height: 1.4, fontWeight: FontWeight.w500),
                                ),
                              ),
                              const Icon(Icons.chevron_right, color: muted),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Related Products Footer
                  const SectionHeader('More from this Neighborhood', 'View All'),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 290, // Height for horizontal PremiumProductCard
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: catalogProducts.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 16),
                      itemBuilder: (context, index) {
                        final p = catalogProducts[index];
                        return PremiumProductCard(
                          product: p,
                          onTap: () => push(context, ProductDetailPage(product: p)),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

