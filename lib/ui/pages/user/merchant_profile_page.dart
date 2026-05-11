import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:dukaan_zone_flutter/dukaan.dart';

class MerchantProfilePage extends StatelessWidget {
  const MerchantProfilePage({super.key, required this.shopName});
  final String shopName;

@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: ink),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            CircleAvatar(
              radius: 48,
              backgroundColor: primary.withValues(alpha: .1),
              child: const Icon(Icons.storefront, color: primary, size: 48),
            ),
            const SizedBox(height: 16),
            Text(shopName, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: ink)),
            const SizedBox(height: 8),
            const Text('1.2K Followers • 4.8 Rating', style: TextStyle(color: muted, fontWeight: FontWeight.w700)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              ),
              child: const Text('Follow', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
            ),
            const SizedBox(height: 32),
            const Align(
              alignment: Alignment.centerLeft,
              child: SectionHeader('Digital Shelf', ''),
            ),
            const SizedBox(height: 16),
            ProductCardGrid(products: catalogProducts),
          ],
        ),
      ),
    );
  }
}

