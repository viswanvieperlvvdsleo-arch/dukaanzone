import 'package:flutter/material.dart';
import 'package:dukaan_zone_flutter/dukaan.dart';

class AdminDisputesPage extends StatelessWidget {
  const AdminDisputesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPage(
      children: [
        const PageTitle('Dispute Center', 'Mediate issues regarding handovers and payments.'),
        const SizedBox(height: 32),

        const Kicker('ACTIVE CASES'),
        const SizedBox(height: 12),
        _buildCaseCard(context, 'CASE-4401', 'ORD-992', 'Priya S.', 'Tech Haven', 'Missing Item', '₹1,200'),
        const SizedBox(height: 16),
        _buildCaseCard(context, 'CASE-4399', 'ORD-850', 'Aryan M.', 'Fresh Dairy', 'Quality Issue', '₹250'),
      ],
    );
  }

  Widget _buildCaseCard(BuildContext context, String caseId, String orderId, String plaintiff, String defendant, String reason, String amount) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.redAccent.withOpacity(0.3)),
        boxShadow: shadowSm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('$caseId • $orderId', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12, color: primary)),
              Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Colors.redAccent.withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: const Text('Open', style: TextStyle(color: Colors.redAccent, fontSize: 10, fontWeight: FontWeight.w900))),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Plaintiff (Neighbor)', style: TextStyle(color: muted, fontSize: 10, fontWeight: FontWeight.w800)),
                    Text(plaintiff, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
                  ],
                ),
              ),
              const Icon(Icons.compare_arrows, color: muted),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('Defendant (Shop)', style: TextStyle(color: muted, fontSize: 10, fontWeight: FontWeight.w800)),
                    Text(defendant, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: muted.withOpacity(0.05), borderRadius: BorderRadius.circular(12)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Reason', style: TextStyle(color: muted, fontSize: 10, fontWeight: FontWeight.w800)),
                    Text(reason, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('Contested', style: TextStyle(color: muted, fontSize: 10, fontWeight: FontWeight.w800)),
                    Text(amount, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: Colors.redAccent)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.chat_outlined, size: 16),
                  label: const Text('Chat Log'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Refund Issued. Case Closed.'))),
                  style: ElevatedButton.styleFrom(backgroundColor: primary, foregroundColor: Colors.white),
                  child: const Text('Refund User'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Funds Settled. Case Closed.'))),
                  style: ElevatedButton.styleFrom(backgroundColor: success, foregroundColor: Colors.white),
                  child: const Text('Settle Shop'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
