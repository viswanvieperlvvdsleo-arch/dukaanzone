import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:dukaan_zone_flutter/dukaan.dart';

class MerchantProfilePage extends StatefulWidget {
  const MerchantProfilePage({super.key, required this.shopName});
  final String shopName;

  @override
  State<MerchantProfilePage> createState() => _MerchantProfilePageState();
}

class _MerchantProfilePageState extends State<MerchantProfilePage> {
  bool _isFollowing = false;

  void _toggleFollow() {
    setState(() => _isFollowing = !_isFollowing);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isFollowing ? 'You are now following ${widget.shopName}' : 'Unfollowed ${widget.shopName}'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

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
            Text(widget.shopName, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: ink)),
            const SizedBox(height: 8),
            Text('${_isFollowing ? '1,201' : '1,200'} Followers • 4.8 Rating', 
              style: const TextStyle(color: muted, fontWeight: FontWeight.w700)),
            const SizedBox(height: 24),
            
            // Premium Follow/Unfollow Button
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: ElevatedButton.icon(
                onPressed: _toggleFollow,
                icon: Icon(_isFollowing ? Icons.check : Icons.add, size: 20),
                label: Text(_isFollowing ? 'Following' : 'Follow Shop', 
                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isFollowing ? success : primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  elevation: _isFollowing ? 0 : 4,
                ),
              ),
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

