import 'package:flutter/material.dart';
import 'package:dukaan_zone_flutter/dukaan.dart';

class SellerProfilePage extends StatefulWidget {
  const SellerProfilePage({super.key});

  @override
  State<SellerProfilePage> createState() => _SellerProfilePageState();
}

class _SellerProfilePageState extends State<SellerProfilePage> {
  bool _isOnline = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Storefront Command', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStorefrontIdentity(context),
            const SizedBox(height: 32),
            _buildActionGrid(context),
            const SizedBox(height: 32),
            const Kicker('DIGITAL SHELF (INVENTORY)'),
            const SizedBox(height: 16),
            _buildUploadTrigger(context),
            const SizedBox(height: 16),
            _buildInventoryItem(context, 'Fresh Organic Bananas', '₹60.00', '15 units left'),
            const SizedBox(height: 12),
            _buildInventoryItem(context, 'Premium Mixed Greens', '₹120.00', '5 units left', lowStock: true),
            const SizedBox(height: 48),
            Center(
              child: TextButton.icon(
                onPressed: () => authService.logout(),
                icon: const Icon(Icons.power_settings_new, color: Colors.redAccent),
                label: const Text('Terminate Session', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w900)),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildStorefrontIdentity(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(32),
        boxShadow: shadowSm,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 84,
                height: 84,
                decoration: BoxDecoration(
                  color: primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(color: primary.withOpacity(0.3), width: 2),
                ),
                child: const Icon(Icons.store, color: primary, size: 40),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: _isOnline ? success.withOpacity(0.1) : muted.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Container(width: 8, height: 8, decoration: BoxDecoration(color: _isOnline ? success : muted, shape: BoxShape.circle)),
                    const SizedBox(width: 8),
                    Text(_isOnline ? 'Online' : 'Offline', style: TextStyle(color: _isOnline ? success : muted, fontWeight: FontWeight.w900, fontSize: 13)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Row(
            children: [
              Text('Pooja General Store', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 22)),
              SizedBox(width: 8),
              Icon(Icons.verified, color: Colors.blueAccent, size: 20),
            ],
          ),
          const SizedBox(height: 8),
          const Row(
            children: [
              Icon(Icons.location_on, color: primary, size: 14),
              SizedBox(width: 4),
              Text('Block A Hub • Grocery', style: TextStyle(color: muted, fontWeight: FontWeight.w600, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: _buildStat('Followers', '1,204')),
              Container(width: 1, height: 40, color: muted.withOpacity(0.2)),
              Expanded(child: _buildStat('Rating', '4.9★')),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), padding: const EdgeInsets.symmetric(vertical: 14)),
                  child: const Text('Preview Storefront', style: TextStyle(fontWeight: FontWeight.w800, color: primary)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => setState(() => _isOnline = !_isOnline),
                  style: ElevatedButton.styleFrom(backgroundColor: _isOnline ? const Color(0xFF1E293B) : primary, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), padding: const EdgeInsets.symmetric(vertical: 14)),
                  child: Text(_isOnline ? 'Go Offline' : 'Go Online', style: const TextStyle(fontWeight: FontWeight.w800)),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildStat(String label, String val) {
    return Column(
      children: [
        Text(val, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 20)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: muted, fontWeight: FontWeight.w600, fontSize: 11)),
      ],
    );
  }

  Widget _buildActionGrid(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _buildActionCard(context, 'Identity', Icons.badge_outlined)),
        const SizedBox(width: 16),
        Expanded(child: _buildActionCard(context, 'Payouts', Icons.account_balance_wallet_outlined)),
        const SizedBox(width: 16),
        Expanded(child: _buildActionCard(context, 'Auto-Reply', Icons.quickreply_outlined)),
      ],
    );
  }

  Widget _buildActionCard(BuildContext context, String label, IconData icon) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: shadowSm,
        ),
        child: Column(
          children: [
            Icon(icon, color: primary, size: 24),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadTrigger(BuildContext context) {
    return InkWell(
      onTap: () => push(context, const ProductFormPage()),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: primary.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: primary.withOpacity(0.2), style: BorderStyle.solid),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_circle_outline, color: primary),
            SizedBox(width: 12),
            Text('Upload New Product', style: TextStyle(color: primary, fontWeight: FontWeight.w900, fontSize: 15)),
          ],
        ),
      ),
    );
  }

  Widget _buildInventoryItem(BuildContext context, String name, String price, String stock, {bool lowStock = false}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: shadowSm,
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(color: primary.withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
            child: const Icon(Icons.inventory_2_outlined, color: primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(price, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: primary)),
                    const SizedBox(width: 12),
                    Text(stock, style: TextStyle(color: lowStock ? Colors.orange : muted, fontWeight: FontWeight.w800, fontSize: 10)),
                  ],
                ),
              ],
            ),
          ),
          IconButton(onPressed: () {}, icon: const Icon(Icons.edit_outlined, color: muted)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.delete_outline, color: Colors.redAccent)),
        ],
      ),
    );
  }
}
