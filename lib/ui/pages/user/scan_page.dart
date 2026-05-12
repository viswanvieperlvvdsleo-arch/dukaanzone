import 'package:flutter/material.dart';
import 'package:dukaan_zone_flutter/dukaan.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class UserScanPage extends StatefulWidget {
  const UserScanPage({super.key});

  @override
  State<UserScanPage> createState() => _UserScanPageState();
}

class _UserScanPageState extends State<UserScanPage> {
  final MobileScannerController controller = MobileScannerController();
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = authService.currentUser.value;
    return AppPage(
      maxWidth: 680,
      children: [
        PageTitle('Self-checkout scan', 'Scanner active for: ${user?.name ?? 'Guest'}'),
        const SizedBox(height: 20),
        Container(
          height: 360,
          decoration: BoxDecoration(color: ink, borderRadius: BorderRadius.circular(40), boxShadow: shadowLg),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (!_hasError)
                  MobileScanner(
                    controller: controller,
                    onDetect: (capture) {
                      final List<Barcode> barcodes = capture.barcodes;
                      if (barcodes.isNotEmpty) {
                        // In a real app, the barcode would be a shop ID. Here we just map it to Tech Haven.
                        _onDetectedShop('Tech Haven');
                      }
                    },
                    errorBuilder: (context, error) {
                      setState(() {
                        _hasError = true;
                        _errorMessage = error.errorCode.name;
                      });
                      return _buildErrorState();
                    },
                  )
                else
                  _buildErrorState(),
                
                // Scanner Frame
                Container(
                  width: 230, 
                  height: 230, 
                  decoration: BoxDecoration(
                    border: Border.all(color: _hasError ? Colors.redAccent : primary, width: 4), 
                    borderRadius: BorderRadius.circular(34)
                  )
                ),
                
                Positioned(
                  bottom: 32, 
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(20)),
                    child: Text(
                      _hasError ? 'Camera Blocked' : 'Ready to scan items', 
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)
                    ),
                  )
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),
        
        // Simulation / Manual Entry Section
        Row(
          children: [
            const Expanded(child: SectionHeader('Detected Shop', 'Manual search')),
            TextButton.icon(
              onPressed: () => _onDetectedShop('Tech Haven'),
              icon: const Icon(Icons.bolt, size: 16),
              label: const Text('Simulate Scan', style: TextStyle(fontWeight: FontWeight.w900)),
              style: TextButton.styleFrom(foregroundColor: primary),
            ),
          ],
        ),
        
        for (final s in shops.take(3)) 
          RepaintBoundary(
            child: ListTile(
              onTap: () => _onDetectedShop(s.name),
              leading: const CircleAvatar(backgroundColor: Color(0xFFF4F6F8), child: Icon(Icons.storefront, color: ink)),
              title: Text(s.name, style: const TextStyle(fontWeight: FontWeight.w900, color: ink)),
              subtitle: Text(s.type, style: const TextStyle(color: muted, fontSize: 12)),
              trailing: const Icon(Icons.qr_code_scanner, color: muted),
            ),
          ),
      ],
    );
  }

  Widget _buildErrorState() {
    return Container(
      color: const Color(0xFF0F172A),
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.videocam_off_outlined, color: Colors.redAccent, size: 48),
          const SizedBox(height: 16),
          const Text('Camera Access Denied', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18)),
          const SizedBox(height: 8),
          Text(
            'Chrome is blocking the camera. Please check your "chrome://flags" and Site Permissions.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 13),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => setState(() => _hasError = false),
            style: ElevatedButton.styleFrom(backgroundColor: primary, foregroundColor: Colors.white),
            child: const Text('Retry Camera'),
          ),
        ],
      ),
    );
  }

  void _onDetectedShop(String shopName) {
    final user = authService.currentUser.value;
    print('SCAN LOG: User ${user?.id} scanned shop $shopName');
    final shop = shops.firstWhere((s) => s.name == shopName, orElse: () => shops.first);
    push(context, ShopPaymentChatPage(shop: shop, color: Colors.purple));
  }
}

