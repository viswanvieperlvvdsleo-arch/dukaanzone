import 'package:flutter/material.dart';
import 'package:dukaan_zone_flutter/dukaan.dart';

class PurchaseHistoryPage extends StatelessWidget {
  const PurchaseHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: ink),
        title: const Text('Purchase History', style: TextStyle(color: ink, fontWeight: FontWeight.w900)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        physics: const BouncingScrollPhysics(),
        children: [
          const Kicker('THIS MONTH'),
          const SizedBox(height: 12),
          _buildHistoryCard(context, 'Fresh Daily Dairy', 'Organic Milk (1L)', '₹80.00', 'Completed • Oct 24'),
          const SizedBox(height: 12),
          _buildHistoryCard(context, 'Tech Haven', 'USB-C Cable', '₹450.00', 'Completed • Oct 22'),
          const SizedBox(height: 32),
          const Kicker('SEPTEMBER 2026'),
          const SizedBox(height: 12),
          _buildHistoryCard(context, 'Pooja General Store', 'Weekly Groceries', '₹1,240.00', 'Completed • Sep 28'),
        ],
      ),
    );
  }

  Widget _buildHistoryCard(BuildContext context, String shop, String items, String total, String status) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: muted.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(color: success.withOpacity(0.1), shape: BoxShape.circle),
            child: const Icon(Icons.check_circle, color: success, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(shop, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
                Text(items, style: const TextStyle(color: muted, fontSize: 13, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(status, style: const TextStyle(color: muted, fontSize: 11, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          Text(total, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
        ],
      ),
    );
  }
}
