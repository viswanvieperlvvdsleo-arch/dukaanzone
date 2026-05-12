import 'package:flutter/material.dart';
import 'package:dukaan_zone_flutter/dukaan.dart';

class UserHistoryPage extends StatelessWidget {
  const UserHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ValueListenableBuilder<List<Map<String, dynamic>>>(
        valueListenable: globalPaymentHistory,
        builder: (context, history, child) {
          return AppPage(
            maxWidth: 1000,
            children: [
              const PageTitle('Purchase History', 'Your neighborhood spending at a glance.'),
              const SizedBox(height: 24),
              
              if (history.isEmpty)
                const Center(child: Padding(
                  padding: EdgeInsets.all(40.0),
                  child: Text('No transactions yet.', style: TextStyle(color: muted, fontWeight: FontWeight.w600)),
                )),

              for (final tx in history.reversed) ...[
                _HistoryItem(
                  merchant: tx['merchant'] as String,
                  date: tx['date'] as String,
                  amount: tx['amount'] as String,
                  items: tx['items'] as String,
                  icon: tx['icon'] as IconData,
                ),
                const SizedBox(height: 16),
              ],
              const SizedBox(height: 32),
            ],
          );
        },
      ),
    );
  }
}

class _HistoryItem extends StatelessWidget {
  const _HistoryItem({
    required this.merchant,
    required this.date,
    required this.amount,
    required this.items,
    required this.icon,
  });

  final String merchant;
  final String date;
  final String amount;
  final String items;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: const Color(0xFFEAF2FF),
            child: Icon(icon, color: primary),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        merchant,
                        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 17, color: ink),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      amount,
                      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 17, color: ink),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  items,
                  style: const TextStyle(color: muted, fontWeight: FontWeight.w600, fontSize: 13),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      date,
                      style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12, fontWeight: FontWeight.w700),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCFCE7),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'SETTLED',
                        style: TextStyle(color: success, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 0.5),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
