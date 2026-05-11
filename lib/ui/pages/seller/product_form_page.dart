import 'package:flutter/material.dart';
import 'package:dukaan_zone_flutter/dukaan.dart';

class ProductFormPage extends StatefulWidget {
  const ProductFormPage({super.key});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _descController = TextEditingController();
  bool _alertEnabled = true;
  bool _loadingAi = false;

  void _generateAiDescription() async {
    setState(() => _loadingAi = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() {
      _loadingAi = false;
      _descController.text = "Sourced directly from local organic farms, these fresh bananas are naturally sweet and packed with potassium. Perfect for a quick energy boost or your morning smoothie bowl. Handpicked daily to guarantee neighborhood freshness.";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Add to Shelf', style: TextStyle(fontWeight: FontWeight.w900)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Kicker('VISUAL IDENTITY'),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {},
                    child: Container(
                      height: 120,
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardTheme.color,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: primary.withOpacity(0.3), style: BorderStyle.solid),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt_outlined, color: primary, size: 32),
                          SizedBox(height: 8),
                          Text('Open Live Lens', style: TextStyle(fontWeight: FontWeight.w800, color: primary)),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: InkWell(
                    onTap: () {},
                    child: Container(
                      height: 120,
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardTheme.color,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.photo_library_outlined, color: muted, size: 32),
                          SizedBox(height: 8),
                          Text('Gallery', style: TextStyle(fontWeight: FontWeight.w800, color: muted)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            const Kicker('FULFILLMENT DETAILS'),
            const SizedBox(height: 12),
            TextField(decoration: InputDecoration(labelText: 'Item Name', border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)))),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: TextField(keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Rate (₹)', border: OutlineInputBorder(borderRadius: BorderRadius.circular(16))))),
                const SizedBox(width: 16),
                Expanded(child: TextField(keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Stock Count', border: OutlineInputBorder(borderRadius: BorderRadius.circular(16))))),
              ],
            ),
            const SizedBox(height: 32),

            const Kicker('AI MARKETING COPY'),
            const SizedBox(height: 12),
            TextField(
              controller: _descController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Describe your product...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: _loadingAi ? null : _generateAiDescription,
                icon: _loadingAi ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.auto_awesome),
                label: const Text('Generate with Genkit AI'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E293B),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 32),

            const Kicker('INVENTORY SIGNALS'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Theme.of(context).cardTheme.color, borderRadius: BorderRadius.circular(20)),
              child: Row(
                children: [
                  const Icon(Icons.notifications_active_outlined, color: Colors.orange),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Critical Restock Alert', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
                        Text('Send Voice Signal to neighbors when restocked', style: TextStyle(color: muted, fontSize: 11)),
                      ],
                    ),
                  ),
                  Switch.adaptive(value: _alertEnabled, onChanged: (v) => setState(() => _alertEnabled = v), activeColor: primary),
                ],
              ),
            ),
            const SizedBox(height: 48),

            GradientButton('Publish to Shelf', Icons.cloud_upload_outlined, () => Navigator.pop(context)),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
