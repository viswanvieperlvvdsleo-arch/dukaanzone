import 'package:flutter/material.dart';
import 'package:dukaan_zone_flutter/dukaan.dart';

class AdminFinancialsPage extends StatelessWidget {
  const AdminFinancialsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPage(
      children: [
        const PageTitle('Transaction Hub', 'Platform-wide cash flow and payout settlement.'),
        const SizedBox(height: 32),

        const Kicker('SETTLEMENT CARDS'),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildMiniCard(context, 'Settled Rev', '₹1.2M', success),
            const SizedBox(width: 12),
            _buildMiniCard(context, 'Pending Payouts', '₹45k', Colors.orange),
            const SizedBox(width: 12),
            _buildMiniCard(context, 'Dispute Vol', '₹2.4k', Colors.redAccent),
          ],
        ),
        const SizedBox(height: 32),

        const Kicker('GROWTH VELOCITY'),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFF1E293B), Color(0xFF0F172A)]),
            borderRadius: BorderRadius.circular(24),
            boxShadow: neonGlow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Monthly Platform GMV', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w600, fontSize: 12)),
              const SizedBox(height: 4),
              const Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('₹4.8M', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900)),
                  SizedBox(width: 12),
                  Padding(
                    padding: EdgeInsets.only(bottom: 6),
                    child: Text('+22% vs last month', style: TextStyle(color: success, fontWeight: FontWeight.w800, fontSize: 12)),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (var h in [20, 35, 25, 50, 40, 70, 60, 80, 95])
                    Container(
                      width: 20,
                      height: h.toDouble(),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [success, Color(0xFF3B82F6)], begin: Alignment.bottomCenter, end: Alignment.topCenter),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),

        const Kicker('TRANSACTION STREAM'),
        const SizedBox(height: 12),
        _buildTransactionRow(context, 'TXN-991', 'Priya S.', 'Tech Haven', '₹12,499', 'Pending'),
        const SizedBox(height: 12),
        _buildTransactionRow(context, 'TXN-990', 'Aryan M.', 'Pooja Store', '₹120', 'Settled'),
      ],
    );
  }

  Widget _buildMiniCard(BuildContext context, String title, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(color: muted, fontSize: 10, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Text(value, style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.w900)),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionRow(BuildContext context, String id, String customer, String shop, String amount, String status) {
    final isPending = status == 'Pending';
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: shadowSm,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: (isPending ? Colors.orange : success).withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(isPending ? Icons.pending_actions : Icons.check_circle, color: isPending ? Colors.orange : success, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(id, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: (isPending ? Colors.orange : success).withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                      child: Text(status, style: TextStyle(color: isPending ? Colors.orange : success, fontSize: 8, fontWeight: FontWeight.w900)),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text('$customer → $shop', style: const TextStyle(color: muted, fontSize: 12, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(amount, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
              if (isPending)
                TextButton(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Payout Settled.'))),
                  style: TextButton.styleFrom(minimumSize: Size.zero, padding: EdgeInsets.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                  child: const Text('Settle Now', style: TextStyle(fontSize: 10, color: primary)),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
