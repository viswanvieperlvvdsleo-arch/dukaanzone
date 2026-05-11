import 'package:flutter/material.dart';
import 'package:dukaan_zone_flutter/dukaan.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPage(
      children: [
        const PageTitle('Ecosystem Overview', 'Real-time snapshot of global hyperlocal health.'),
        const SizedBox(height: 32),

        const Kicker('GLOBAL STATS'),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: MediaQuery.sizeOf(context).width > 600 ? 4 : 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.2,
          children: [
            _buildStatCard(context, 'Total Neighbors', '14,205', Icons.people_alt, primary),
            _buildStatCard(context, 'Active Shops', '342', Icons.storefront, success),
            _buildStatCard(context, 'Platform Rev', '₹1.2M', Icons.account_balance_wallet, Colors.purple),
            _buildStatCard(context, 'Search Req', '85k', Icons.search, Colors.orange),
          ],
        ),
        const SizedBox(height: 32),

        const Kicker('MARKET DISTRIBUTION'),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(color: Theme.of(context).cardTheme.color, borderRadius: BorderRadius.circular(24), boxShadow: shadowSm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Category Breakdown', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
              const SizedBox(height: 24),
              Row(
                children: [
                  _buildPieSlice(flex: 45, color: primary, label: 'Grocery (45%)'),
                  const SizedBox(width: 4),
                  _buildPieSlice(flex: 30, color: success, label: 'Electronics (30%)'),
                  const SizedBox(width: 4),
                  _buildPieSlice(flex: 15, color: Colors.orange, label: 'Fashion (15%)'),
                  const SizedBox(width: 4),
                  _buildPieSlice(flex: 10, color: Colors.purple, label: 'Pharmacy (10%)'),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),

        const Kicker('LIVE PLATFORM PULSE'),
        const SizedBox(height: 12),
        _buildPulseItem(context, 'New Shop App', 'Rohan\'s Tech Hub applied for Cyber Plaza.', Icons.store, primary),
        _buildPulseItem(context, 'Dispute Raised', 'Case #4401: Neighbor reported missing item.', Icons.warning_amber, Colors.orange),
        _buildPulseItem(context, 'Payout Settled', 'Batch #992 transferred to 45 merchants.', Icons.check_circle, success),
      ],
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Theme.of(context).cardTheme.color, borderRadius: BorderRadius.circular(24), boxShadow: shadowSm),
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

  Widget _buildPieSlice({required int flex, required Color color, required String label}) {
    return Expanded(
      flex: flex,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(height: 12, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(6))),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: muted)),
        ],
      ),
    );
  }

  Widget _buildPulseItem(BuildContext context, String title, String desc, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Theme.of(context).cardTheme.color, borderRadius: BorderRadius.circular(16), border: Border.all(color: muted.withOpacity(0.1))),
      child: Row(
        children: [
          Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle), child: Icon(icon, color: color, size: 20)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
                Text(desc, style: const TextStyle(color: muted, fontSize: 12, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: muted),
        ],
      ),
    );
  }
}
