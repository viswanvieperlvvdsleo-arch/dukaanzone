import 'package:flutter/material.dart';
import 'package:dukaan_zone_flutter/dukaan.dart';

class AdminShopsPage extends StatefulWidget {
  const AdminShopsPage({super.key});

  @override
  State<AdminShopsPage> createState() => _AdminShopsPageState();
}

class _AdminShopsPageState extends State<AdminShopsPage> {
  @override
  Widget build(BuildContext context) {
    return AppPage(
      children: [
        const PageTitle('Merchant Hub', 'Manage the lifecycle of local businesses.'),
        const SizedBox(height: 32),
        TextField(
          decoration: InputDecoration(
            hintText: 'Search shops by name or ID...',
            prefixIcon: const Icon(Icons.search),
            filled: true,
            fillColor: Theme.of(context).cardTheme.color,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
          ),
        ),
        const SizedBox(height: 32),

        const Kicker('PENDING APPROVALS'),
        const SizedBox(height: 12),
        _buildShopCard(context, 'Tech Haven', 'Rohan Sharma', 'Electronics', 'Pending', Colors.orange),
        
        const SizedBox(height: 32),
        const Kicker('ACTIVE MERCHANTS'),
        const SizedBox(height: 12),
        _buildShopCard(context, 'Pooja General Store', 'Pooja M.', 'Grocery', 'Active', success),
        const SizedBox(height: 16),
        _buildShopCard(context, 'Fresh Daily Dairy', 'Amit K.', 'Grocery', 'Suspended', Colors.redAccent),
      ],
    );
  }

  Widget _buildShopCard(BuildContext context, String name, String owner, String category, String status, Color statusColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: statusColor.withOpacity(0.3)),
        boxShadow: shadowSm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 48, height: 48, decoration: BoxDecoration(color: primary.withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.store, color: primary)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                    Text('$owner • $category', style: const TextStyle(color: muted, fontSize: 12, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                child: Text(status, style: TextStyle(color: statusColor, fontWeight: FontWeight.w800, fontSize: 11)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (status == 'Pending') ...[
                OutlinedButton(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Shop Rejected.'))),
                  style: OutlinedButton.styleFrom(foregroundColor: Colors.redAccent),
                  child: const Text('Reject'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Shop Approved! Status is now Active.'))),
                  style: ElevatedButton.styleFrom(backgroundColor: success, foregroundColor: Colors.white),
                  child: const Text('Approve'),
                ),
              ] else if (status == 'Active') ...[
                OutlinedButton(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Shop Suspended. Inventory hidden.'))),
                  style: OutlinedButton.styleFrom(foregroundColor: Colors.orange),
                  child: const Text('Suspend'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(backgroundColor: primary, foregroundColor: Colors.white),
                  child: const Text('Audit'),
                ),
              ] else ...[
                ElevatedButton(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Shop Reinstated.'))),
                  style: ElevatedButton.styleFrom(backgroundColor: primary, foregroundColor: Colors.white),
                  child: const Text('Reinstate'),
                ),
              ]
            ],
          ),
        ],
      ),
    );
  }
}
