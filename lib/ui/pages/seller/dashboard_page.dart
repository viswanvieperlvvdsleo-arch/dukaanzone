import 'package:flutter/material.dart';
import 'package:dukaan_zone_flutter/dukaan.dart';

class SellerDashboardPage extends StatelessWidget {
  const SellerDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPage(
      children: [
        const PageTitle('Command Center', 'Monitor your digital shelf and local operations.'),
        const SizedBox(height: 32),
        const Kicker('REAL-TIME RADAR'),
        const SizedBox(height: 12),
        _buildStatsGrid(context),
        const SizedBox(height: 32),
        const Kicker('PENDING HANDSHAKES'),
        const SizedBox(height: 12),
        _buildFulfillmentRadar(context),
      ],
    );
  }

  Widget _buildStatsGrid(BuildContext context) {
    return GridView.count(
      crossAxisCount: MediaQuery.sizeOf(context).width > 600 ? 4 : 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.2,
      children: [
        _buildStatCard(context, 'Today Revenue', '₹4,250', Icons.account_balance_wallet, success),
        _buildStatCard(context, 'Handshake Radar', '8 Active', Icons.qr_code_scanner, primary),
        _buildStatCard(context, 'Neighbor Pulse', '4.8 Avg', Icons.star, Colors.amber),
        _buildStatCard(context, 'Live Radar', '12 Viewing', Icons.visibility, Colors.purple),
      ],
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(24),
        boxShadow: shadowSm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 28),
          const Spacer(),
          Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(color: muted, fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildFulfillmentRadar(BuildContext context) {
    return Column(
      children: [
        _buildOrderCard(context, 'ORD-001', 'Aryan Malhotra', 'Fresh Organic Bananas (Dozen) x2', '₹120.00'),
        const SizedBox(height: 16),
        _buildOrderCard(context, 'ORD-002', 'Priya Singh', 'Premium Mixed Greens Collection', '₹120.00'),
      ],
    );
  }

  Widget _buildOrderCard(BuildContext context, String id, String name, String items, String amount) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: primary.withOpacity(0.2)),
        boxShadow: shadowSm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(id, style: const TextStyle(color: primary, fontWeight: FontWeight.w900, fontSize: 12)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: Colors.orange.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                child: const Text('Awaiting Verification', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.w800, fontSize: 11)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
          const SizedBox(height: 4),
          Text(items, style: const TextStyle(color: muted, fontWeight: FontWeight.w600, fontSize: 13)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(amount, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
              ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Handover Complete! Inventory updated.')));
                },
                icon: const Icon(Icons.qr_code_scanner, size: 18),
                label: const Text('Verify Handshake'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
