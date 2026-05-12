import 'package:flutter/material.dart';
import 'package:dukaan_zone_flutter/dukaan.dart';

class EntryPage extends StatelessWidget {
  const EntryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: authService.isLoggedIn,
      builder: (context, isLoggedIn, child) {
        return Scaffold(
          body: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430),
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: isLoggedIn ? _buildRoleSelection(context) : _buildLanding(context),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLanding(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        const Brand(size: 96),
        const SizedBox(height: 26),
        const Text('DukaanZone', style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900, color: ink, letterSpacing: -.5)),
        const SizedBox(height: 8),
        const Text(
          'Connecting the world through local shopkeepers.',
          textAlign: TextAlign.center,
          style: TextStyle(color: muted, height: 1.45, fontWeight: FontWeight.w600),
        ),
        const Spacer(),
        GradientButton('Shop with Us', Icons.person_outline, () => push(context, const UserAuthPage())),
        const SizedBox(height: 14),
        OutlinedButton.icon(
          onPressed: () => push(context, const SellerAuthPage()),
          icon: const Icon(Icons.storefront),
          label: const Text('Partner with Us', style: TextStyle(fontWeight: FontWeight.w900)),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(58),
            foregroundColor: primary,
            side: const BorderSide(color: Color(0x33628ECB), width: 2),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          ),
        ),
      ],
    );
  }

  Widget _buildRoleSelection(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        const Brand(size: 84),
        const SizedBox(height: 20),
        const Text('Choose your journey', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: ink)),
        const SizedBox(height: 32),
        GradientButton('Shop as User', Icons.storefront, () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const RoleShell(role: Role.user)), (r) => false)),
        const SizedBox(height: 14),
        OutlinedButton.icon(
          onPressed: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const RoleShell(role: Role.seller)), (r) => false),
          icon: const Icon(Icons.inventory_2_outlined),
          label: const Text('Continue as Seller', style: TextStyle(fontWeight: FontWeight.w900)),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(58),
            foregroundColor: primary,
            side: const BorderSide(color: Color(0x33628ECB), width: 2),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          ),
        ),
        const Spacer(),
        TextButton(
          onPressed: () {
            authService.logout();
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const EntryPage()), (r) => false);
          },
          child: const Text('SIGN OUT', style: TextStyle(letterSpacing: 2, fontSize: 10, fontWeight: FontWeight.w900, color: muted)),
        ),
      ],
    );
  }
}
