import 'package:flutter/material.dart';
import 'package:dukaan_zone_flutter/dukaan.dart';

class AdminSignalsPage extends StatefulWidget {
  const AdminSignalsPage({super.key});

  @override
  State<AdminSignalsPage> createState() => _AdminSignalsPageState();
}

class _AdminSignalsPageState extends State<AdminSignalsPage> {
  String _audience = 'All Neighbors';
  String _priority = 'Standard';

  @override
  Widget build(BuildContext context) {
    return AppPage(
      children: [
        const PageTitle('Signals Control', 'Push notifications and critical global alerts.'),
        const SizedBox(height: 32),

        const Kicker('SIGNAL COMPOSER'),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius: BorderRadius.circular(24),
            boxShadow: shadowSm,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _audience,
                      decoration: InputDecoration(labelText: 'Target Audience', border: OutlineInputBorder(borderRadius: BorderRadius.circular(16))),
                      items: ['All Neighbors', 'Merchants Only', 'Block A Hub', 'Cyber Plaza'].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                      onChanged: (v) => setState(() => _audience = v!),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _priority,
                      decoration: InputDecoration(labelText: 'Priority Level', border: OutlineInputBorder(borderRadius: BorderRadius.circular(16))),
                      items: ['Standard', 'Critical (Bypass DND)'].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                      onChanged: (v) => setState(() => _priority = v!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextField(decoration: InputDecoration(labelText: 'Signal Title', border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)))),
              const SizedBox(height: 20),
              TextField(maxLines: 3, decoration: InputDecoration(labelText: 'Message Body', border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)))),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Signal Broadcasted via FCM!'))),
                  icon: const Icon(Icons.send),
                  label: const Text('Broadcast Signal'),
                  style: ElevatedButton.styleFrom(backgroundColor: primary, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),

        const Kicker('SIGNAL HISTORY'),
        const SizedBox(height: 12),
        _buildSignalLog(context, 'System Maintenance', 'Platform will be down for 10 mins tonight.', 'All Neighbors', 'Standard', '2 hours ago'),
        const SizedBox(height: 12),
        _buildSignalLog(context, 'Flash Flood Warning', 'Avoid deliveries in Block B area.', 'Block B Hub', 'Critical', '1 day ago'),
      ],
    );
  }

  Widget _buildSignalLog(BuildContext context, String title, String msg, String audience, String priority, String time) {
    final isCritical = priority.contains('Critical');
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isCritical ? Colors.redAccent.withOpacity(0.3) : muted.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
              Text(time, style: const TextStyle(color: muted, fontSize: 10, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 4),
          Text(msg, style: const TextStyle(color: muted, fontSize: 12)),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: primary.withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: Text('To: $audience', style: const TextStyle(color: primary, fontSize: 10, fontWeight: FontWeight.w900))),
              const SizedBox(width: 8),
              if (isCritical)
                Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: Colors.redAccent.withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: const Text('CRITICAL', style: TextStyle(color: Colors.redAccent, fontSize: 10, fontWeight: FontWeight.w900))),
            ],
          ),
        ],
      ),
    );
  }
}
