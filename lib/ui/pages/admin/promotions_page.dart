import 'package:flutter/material.dart';
import 'package:dukaan_zone_flutter/dukaan.dart';

class AdminPromotionsPage extends StatelessWidget {
  const AdminPromotionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPage(
      children: [
        const PageTitle('Promotion Hub', 'Manage high-visibility marketing slots.'),
        const SizedBox(height: 32),

        const Kicker('ACTIVE CAMPAIGNS (LIVE)'),
        const SizedBox(height: 12),
        _buildCampaignCard(context, 'Diwali Mega Sale', '142k Impressions', '12k Clicks', 'Ends in 2 Days'),
        
        const SizedBox(height: 32),
        const Kicker('SLOT SCHEDULER'),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: primary.withOpacity(0.3), style: BorderStyle.solid),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Container(
                      height: 120,
                      width: double.infinity,
                      decoration: BoxDecoration(color: primary.withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_photo_alternate_outlined, color: primary, size: 32),
                          SizedBox(height: 8),
                          Text('Upload Banner Creative (16:9)', style: TextStyle(color: primary, fontWeight: FontWeight.w800)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              TextField(decoration: InputDecoration(labelText: 'Campaign Name', border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)))),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: TextField(decoration: InputDecoration(labelText: 'Start Date', suffixIcon: const Icon(Icons.calendar_today), border: OutlineInputBorder(borderRadius: BorderRadius.circular(16))))),
                  const SizedBox(width: 16),
                  Expanded(child: TextField(decoration: InputDecoration(labelText: 'End Date', suffixIcon: const Icon(Icons.calendar_today), border: OutlineInputBorder(borderRadius: BorderRadius.circular(16))))),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Campaign Scheduled.'))),
                  style: ElevatedButton.styleFrom(backgroundColor: primary, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  child: const Text('Schedule Campaign'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCampaignCard(BuildContext context, String name, String impressions, String clicks, String expiry) {
    return Container(
      decoration: BoxDecoration(color: Theme.of(context).cardTheme.color, borderRadius: BorderRadius.circular(24), boxShadow: shadowSm),
      child: Column(
        children: [
          Container(
            height: 120,
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [primary, Colors.purple]),
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: const Center(child: Icon(Icons.campaign, color: Colors.white54, size: 48)),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(name, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
                    Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: success.withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: const Text('LIVE', style: TextStyle(color: success, fontSize: 10, fontWeight: FontWeight.w900))),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildMetric(Icons.visibility_outlined, impressions),
                    _buildMetric(Icons.touch_app_outlined, clicks),
                    _buildMetric(Icons.timer_outlined, expiry),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetric(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, size: 14, color: muted),
        const SizedBox(width: 4),
        Text(value, style: const TextStyle(color: muted, fontSize: 12, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
