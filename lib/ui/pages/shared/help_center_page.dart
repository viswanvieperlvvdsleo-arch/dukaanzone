import 'package:flutter/material.dart';
import 'package:dukaan_zone_flutter/dukaan.dart';

class HelpCenterPage extends StatelessWidget {
  const HelpCenterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: ink),
        title: const Text('Help Center', style: TextStyle(color: ink, fontWeight: FontWeight.w900)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('How can we help?', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
            const SizedBox(height: 24),
            TextField(
              decoration: InputDecoration(
                hintText: 'Search for articles...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Theme.of(context).cardTheme.color,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 32),
            const Kicker('FREQUENTLY ASKED'),
            const SizedBox(height: 16),
            _buildFaqItem(context, 'How do I use a Pickup Token?', 'Show the QR code to the merchant at the shop. They will scan it to complete the transaction.'),
            _buildFaqItem(context, 'What happens if a handshake fails?', 'If the scan fails, the merchant can manually enter the 6-digit code listed below your QR token.'),
            _buildFaqItem(context, 'How do I cancel an order?', 'Orders can be cancelled before the merchant prepares them from your Active Handshakes page.'),
            const SizedBox(height: 32),
            const Kicker('CONTACT SUPPORT'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(24),
                boxShadow: shadowSm,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: primary.withOpacity(0.1), shape: BoxShape.circle), child: const Icon(Icons.chat_bubble_outline, color: primary)),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Live Chat Support', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                            Text('Typical response time: 5 mins', style: TextStyle(color: muted, fontSize: 12, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(backgroundColor: primary, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      child: const Text('Start Chat', style: TextStyle(fontWeight: FontWeight.w800)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqItem(BuildContext context, String question, String answer) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        title: Text(question, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
        childrenPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        children: [
          Text(answer, style: const TextStyle(color: muted, height: 1.5, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
