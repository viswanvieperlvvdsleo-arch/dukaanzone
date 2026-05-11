import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:dukaan_zone_flutter/dukaan.dart';

class UserScanPage extends StatelessWidget {
  const UserScanPage({super.key});

@override
  Widget build(BuildContext context) {
    return AppPage(
      maxWidth: 680,
      children: [
        const PageTitle('Self-checkout scan', 'Camera scanner and inventory match from the original scan flow.'),
        const SizedBox(height: 20),
        Container(
          height: 360,
          decoration: BoxDecoration(color: ink, borderRadius: BorderRadius.circular(40), boxShadow: shadowLg),
          child: Stack(
            alignment: Alignment.center,
            children: [
              const Icon(Icons.qr_code_scanner, color: Colors.white24, size: 190),
              Container(width: 230, height: 230, decoration: BoxDecoration(border: Border.all(color: primary, width: 4), borderRadius: BorderRadius.circular(34))),
              const Positioned(bottom: 32, child: Text('Align product barcode inside the frame', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w700))),
            ],
          ),
        ),
        const SizedBox(height: 18),
        const SectionHeader('Detected inventory', 'Manual search'),
        for (final p in pulseProducts.take(3)) 
          InkWell(
            onTap: () => push(context, CheckoutPage(product: p)),
            child: CompactProductTile(product: p),
          ),
      ],
    );
  }
}

