import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:dukaan_zone_flutter/dukaan.dart';

class MainHeader extends StatelessWidget implements PreferredSizeWidget {
  const MainHeader({super.key, required this.role, required this.onExit});
  final Role role;
  final VoidCallback onExit;

@override
  Widget build(BuildContext context) {
    final hint = role == Role.user ? 'Search Milk, Bread...' : role == Role.seller ? 'Search orders, products...' : 'Search platform...';
    final compact = MediaQuery.sizeOf(context).width < 640;
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: 70,
      backgroundColor: Colors.white.withValues(alpha: .96),
      surfaceTintColor: Colors.white,
      titleSpacing: 16,
      title: Row(
        children: [
          const Brand(size: 42),
          const SizedBox(width: 12),
          Expanded(
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('DukaanZone', maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 19, fontWeight: FontWeight.w900, color: ink, letterSpacing: -.4)),
                Row(children: [
                  Icon(Icons.location_on, size: 10, color: primary),
                  SizedBox(width: 3),
                  Text('YOUR NEIGHBORHOOD', maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: primary, letterSpacing: 1.5)),
                ]),
              ],
            ),
          ),
          if (!compact) ...[
            const SizedBox(width: 24),
            Expanded(
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () => push(context, SearchPage(role: role)),
                child: Container(
                  height: 42,
                  constraints: const BoxConstraints(maxWidth: 560),
                  decoration: BoxDecoration(color: const Color(0xFFF4F6F8), borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0xFFEFF2F5))),
                  child: Row(
                    children: [
                      const SizedBox(width: 12),
                      const Icon(Icons.search, size: 18, color: muted),
                      const SizedBox(width: 8),
                      Expanded(child: Text(hint, style: const TextStyle(color: muted, fontSize: 13, fontWeight: FontWeight.w600))),
                      const Icon(Icons.mic_none, size: 17, color: muted),
                      const SizedBox(width: 12),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
      actions: [
        if (compact) IconButton(onPressed: () => push(context, SearchPage(role: role)), icon: const Icon(Icons.search_rounded)),
        IconButton(onPressed: () => push(context, const NotificationsPage()), icon: const Icon(Icons.notifications_none_rounded)),
        IconButton(
          onPressed: () {
            if (role == Role.seller) {
              push(context, const SellerProfilePage());
            } else {
              push(context, ProfilePage(role: role));
            }
          },
          icon: const Icon(Icons.person_outline_rounded),
        ),
      ],
    );
  }

@override
  Size get preferredSize => const Size.fromHeight(70);
}

class KeypadButton extends StatelessWidget {
  const KeypadButton(this.label, this.onTap);
  final String label;
  final ValueChanged<String> onTap;

@override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(label),
      borderRadius: BorderRadius.circular(32),
      child: Center(
        child: label == '<'
            ? const Icon(Icons.backspace_outlined, color: Colors.white, size: 28)
            : Text(label, style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w500)),
      ),
    );
  }
}

class AdminRail extends StatelessWidget {
  const AdminRail({super.key, required this.selected, required this.onSelect, required this.items});
  final int selected;
  final ValueChanged<int> onSelect;
  final List<NavItem> items;

@override
  Widget build(BuildContext context) {
    return Container(
      width: 288,
      color: Colors.white,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Kicker('ENTERPRISE CONTROL'),
          const SizedBox(height: 16),
          for (var i = 0; i < items.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: InkWell(
                borderRadius: BorderRadius.circular(22),
                onTap: () => onSelect(i),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                  decoration: BoxDecoration(color: selected == i ? primary : Colors.transparent, borderRadius: BorderRadius.circular(22)),
                  child: Row(children: [
                    Icon(items[i].icon, color: selected == i ? Colors.white : muted),
                    const SizedBox(width: 12),
                    Expanded(child: Text(items[i].label, style: TextStyle(fontWeight: FontWeight.w900, color: selected == i ? Colors.white : const Color(0xFF64748B)))),
                    if (selected == i) const Icon(Icons.chevron_right, color: Colors.white54),
                  ]),
                ),
              ),
            ),
          const Spacer(),
          OutlinedButton.icon(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.logout), label: const Text('Exit Portal')),
        ],
      ),
    );
  }
}

class HeroCarousel extends StatefulWidget {
  const HeroCarousel({super.key});
  @override
  State<HeroCarousel> createState() => _HeroCarouselState();
}

class _HeroCarouselState extends State<HeroCarousel> {
  late PageController _pageController;
  Timer? _timer;

@override
  void initState() {
    super.initState();
    final initialPage = catalogProducts.length * 1000; // Start high for infinite backwards scrolling
    _pageController = PageController(initialPage: initialPage);

_timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.hasClients) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeOutQuart,
        );
      }
    });
  }

@override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

@override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 420, // Match HeroProductCard height
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: PageView.builder(
          controller: _pageController,
          itemBuilder: (context, index) {
            final product = catalogProducts[index % catalogProducts.length];
            return HeroProductCard(
              key: ValueKey(product.id),
              title: product.name,
              price: product.price,
              shop: product.shop,
              icon: product.icon,
              onBuy: () => push(context, CheckoutPage(product: product)),
            );
          },
        ),
      ),
    );
  }
}

class HeroProductCard extends StatelessWidget {
  const HeroProductCard({super.key, required this.title, required this.price, required this.shop, required this.icon, required this.onBuy});
  final String title;
  final String price;
  final String shop;
  final IconData icon;
  final VoidCallback onBuy;

@override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(40),
      onTap: () => push(context, ProductDetailPage(product: catalogProducts.last)),
      child: Container(
        height: 420,
        decoration: BoxDecoration(
          color: ink,
          borderRadius: BorderRadius.circular(40),
          boxShadow: shadowLg,
          gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF344456), Color(0xFF0B0F17)]),
        ),
        child: Stack(
          children: [
            Positioned(right: 18, top: 44, child: Transform.rotate(angle: -.18, child: Icon(icon, color: Colors.white.withValues(alpha: .55), size: 148))),
            Positioned(left: 132, top: 96, child: Transform.rotate(angle: .12, child: Icon(icon, color: Colors.white.withValues(alpha: .62), size: 132))),
            Positioned(left: 18, top: 18, child: GlassRoundIcon(icon: Icons.location_on, size: 38, iconSize: 19, iconColor: primary, onTap: () {
              globalMapState.value = MapState(mode: MapMode.routing, destinationName: shop);
            })),
            const Positioned(right: 18, top: 18, child: FavoriteButton(size: 38, iconSize: 19)),
            Positioned(
              left: 28,
              right: 28,
              bottom: 28,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const BadgeText('HIGH DEMAND'),
                const SizedBox(height: 12),
                Text(title, style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900, height: 1.02)),
                const SizedBox(height: 8),
                Text(price, style: const TextStyle(color: Color(0xFF10B981), fontSize: 27, fontWeight: FontWeight.w900)),
                const SizedBox(height: 8),
                Row(children: [const Icon(Icons.storefront, color: Colors.white54, size: 15), const SizedBox(width: 6), Text('Sold by $shop', style: const TextStyle(color: Colors.white60, fontWeight: FontWeight.w700))]),
                const SizedBox(height: 4),
                const Text('Active Noise Cancelling • 24h battery', style: TextStyle(color: Colors.white24, fontWeight: FontWeight.w700)),
                const SizedBox(height: 18),
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  SizedBox(width: 118, child: FrostedBuyButton(onTap: onBuy)),
                ]),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

class PremiumProductCard extends StatelessWidget {
  const PremiumProductCard({super.key, required this.product, required this.onTap});
  final Product product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: SizedBox(
        width: 150,
        child: Card(
          margin: EdgeInsets.zero,
          child: InkWell(
            borderRadius: BorderRadius.circular(32),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                height: 132,
                decoration: BoxDecoration(color: product.tint, borderRadius: BorderRadius.circular(24)),
                child: Stack(children: [
                  Center(child: Icon(product.icon, size: 68, color: ink.withValues(alpha: .50))),
                  Positioned(left: 6, top: 6, child: GlassRoundIcon(icon: Icons.location_on, size: 28, iconSize: 14, iconColor: primary, onTap: () {
                    globalMapState.value = MapState(mode: MapMode.routing, destinationName: product.shop);
                  })),
                  const Positioned(right: 6, top: 6, child: FavoriteButton(size: 28, iconSize: 14)),
                  Positioned(left: 8, bottom: 8, child: BadgeText(product.badge.split(' ').first, dark: true)),
                ]),
              ),
              const SizedBox(height: 10),
              Text(product.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, height: 1.02)),
              const SizedBox(height: 6),
              Text(product.price, style: const TextStyle(color: success, fontWeight: FontWeight.w900, fontSize: 17)),
              const Spacer(),
              Row(children: [
                Expanded(child: Text(product.stock, style: const TextStyle(color: ink, fontSize: 11, fontWeight: FontWeight.w700))),
                SizedBox(
                  height: 32,
                  width: 72,
                  child: GradientButton(
                    'Buy',
                    Icons.shopping_cart,
                    () => push(context, CheckoutPage(product: product)),
                    compact: true,
                  ),
                ),
              ]),
            ]),
          ),
        ),
      ),
    ),
  );
  }
}

class ProductCardGrid extends StatelessWidget {
  const ProductCardGrid({super.key, required this.products});
  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final crossAxisCount = constraints.maxWidth > 720 ? 3 : 2;
      return RepaintBoundary(
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: products.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 18,
            childAspectRatio: constraints.maxWidth > 720 ? .58 : .43,
          ),
          itemBuilder: (context, index) => LargeProductCard(product: products[index]),
        ),
      );
    });
  }
}

class LargeProductCard extends StatelessWidget {
  const LargeProductCard({super.key, required this.product});
  final Product product;

@override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        borderRadius: BorderRadius.circular(32),
        onTap: () => push(context, ProductDetailPage(product: product)),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(color: product.tint, borderRadius: BorderRadius.circular(26)),
                child: Stack(children: [
                  Center(child: Icon(product.icon, size: 92, color: ink.withValues(alpha: .50))),
                  Positioned(left: 6, top: 6, child: GlassRoundIcon(icon: Icons.location_on, size: 28, iconSize: 14, iconColor: primary, onTap: () {
                    globalMapState.value = MapState(mode: MapMode.routing, destinationName: product.shop);
                  })),
                  const Positioned(right: 6, top: 6, child: FavoriteButton(size: 28, iconSize: 14)),
                  Positioned(left: 12, bottom: 12, child: BadgeText(product.badge, dark: true)),
                ]),
              ),
            ),
            const SizedBox(height: 12),
            Text(product.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 18, height: 1.04, fontWeight: FontWeight.w900, color: ink)),
            const SizedBox(height: 6),
            Text('Sold by ${product.shop}', maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.w600, height: 1.15)),
            const SizedBox(height: 8),
            Text(product.price, style: const TextStyle(color: success, fontSize: 20, fontWeight: FontWeight.w900)),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(value: product.id == 'prod-2' ? .18 : .72, minHeight: 5, color: primary, backgroundColor: const Color(0xFFE2E8F0)),
            ),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(child: Text(product.stock, maxLines: 2, style: const TextStyle(fontSize: 12, color: ink, fontWeight: FontWeight.w700))),
              SizedBox(height: 40, width: 76, child: GradientButton('Buy', Icons.shopping_cart, () => push(context, CheckoutPage(product: product)), compact: true)),
            ]),
            const SizedBox(height: 4),
          ]),
        ),
      ),
    );
  }
}

class SellerOrderCard extends StatelessWidget {
  const SellerOrderCard({super.key, required this.id, required this.name, required this.amount, required this.status, required this.items});
  final String id;
  final String name;
  final String amount;
  final String status;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              CircleAvatar(radius: 26, backgroundColor: const Color(0xFFEAF2FF), child: Text(id.substring(id.length - 2), style: const TextStyle(color: primary, fontWeight: FontWeight.w900))),
              const SizedBox(width: 14),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(name, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)), Text(id, style: const TextStyle(color: muted, fontSize: 11, fontWeight: FontWeight.w800))])),
              BadgeText(status, dark: true),
            ]),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(20)),
              child: Column(children: [
                for (final item in items)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(children: [Expanded(child: Text(item, style: const TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF475569)))), const Icon(Icons.check_circle, color: success, size: 16)]),
                  ),
              ]),
            ),
            const SizedBox(height: 16),
            Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('TOTAL SETTLEMENT', style: TextStyle(color: muted, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 1.5)), Text(amount, style: const TextStyle(color: success, fontSize: 24, fontWeight: FontWeight.w900))])),
              FilledButton.icon(onPressed: () {}, icon: const Icon(Icons.qr_code_scanner), label: const Text('Verify')),
            ]),
          ]),
        ),
      ),
    );
  }
}

class SellerProductCard extends StatelessWidget {
  const SellerProductCard({super.key, required this.product});
  final Product product;
  @override
  Widget build(BuildContext context) => RepaintBoundary(
        child: Card(
          margin: const EdgeInsets.only(bottom: 14),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: CircleAvatar(radius: 28, backgroundColor: product.tint, child: Icon(product.icon, color: ink)),
            title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.w900)),
            subtitle: Text('${product.shop} • ${product.stock}', style: const TextStyle(color: muted, fontWeight: FontWeight.w600)),
            trailing: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.end, children: [Text(product.price, style: const TextStyle(fontWeight: FontWeight.w900)), const Text('Active', style: TextStyle(color: success, fontSize: 11, fontWeight: FontWeight.w800))]),
          ),
        ),
      );
}

class CompactProductTile extends StatelessWidget {
  const CompactProductTile({super.key, required this.product});
  final Product product;
  @override
  Widget build(BuildContext context) => Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: ListTile(
          contentPadding: const EdgeInsets.all(14),
          leading: CircleAvatar(backgroundColor: product.tint, child: Icon(product.icon, color: ink)),
          title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.w900)),
          subtitle: Text(product.shop, style: const TextStyle(color: muted)),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton.filledTonal(
                onPressed: () {
                  globalMapState.value = MapState(mode: MapMode.routing, destinationName: product.shop);
                },
                icon: const Icon(Icons.directions, size: 18),
                style: IconButton.styleFrom(minimumSize: const Size(32, 32), fixedSize: const Size(32, 32), padding: EdgeInsets.zero, backgroundColor: const Color(0xFFEAF2FF), foregroundColor: primary),
              ),
              const SizedBox(width: 8),
              Text(product.price, style: const TextStyle(fontWeight: FontWeight.w900, color: success)),
            ],
          ),
        ),
      );
}

class ShopListTile extends StatelessWidget {
  const ShopListTile({super.key, required this.shop});
  final Shop shop;
  @override
  Widget build(BuildContext context) => Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          leading: const CircleAvatar(radius: 28, backgroundColor: Color(0xFFEAF2FF), child: Icon(Icons.store, color: primary)),
          title: Text(shop.name, style: const TextStyle(fontWeight: FontWeight.w900)),
          subtitle: Text('${shop.block} • ${shop.type} • ${shop.rating}★', style: const TextStyle(color: muted, fontWeight: FontWeight.w600)),
          trailing: Text('${shop.orders}\norders', textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.w900, color: ink)),
        ),
      );
}

class ResponsiveStats extends StatelessWidget {
  const ResponsiveStats({super.key, required this.stats});
  final List<Stat> stats;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final crossAxisCount = width > 900 ? 4 : width > 560 ? 2 : 1;
    return GridView.count(
      crossAxisCount: crossAxisCount,
      crossAxisSpacing: 14,
      mainAxisSpacing: 14,
      childAspectRatio: width > 560 ? 1.55 : 2.8,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [for (final stat in stats) StatCard(stat: stat)],
    );
  }
}

class StatCard extends StatelessWidget {
  const StatCard({super.key, required this.stat});
  final Stat stat;
  @override
  Widget build(BuildContext context) => RepaintBoundary(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                CircleAvatar(radius: 25, backgroundColor: stat.bg, child: Icon(stat.icon, color: primary)),
                BadgeText(stat.trend, dark: true),
              ]),
              Text(stat.value, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: ink)),
              Text(stat.label.toUpperCase(), style: const TextStyle(fontSize: 10, letterSpacing: 1.5, fontWeight: FontWeight.w900, color: muted)),
            ]),
          ),
        ),
      );
}

class LayoutBuilderChart extends StatelessWidget {
  const LayoutBuilderChart({super.key});
  @override
  Widget build(BuildContext context) => LayoutBuilder(builder: (context, c) {
        final wide = c.maxWidth > 760;
        final children = [const Expanded(flex: 2, child: FakeChart(title: 'Neighborhood Search Intent')), const SizedBox(width: 18, height: 18), const Expanded(child: CategoryBreakdown())];
        return wide ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: children) : Column(children: [const FakeChart(title: 'Neighborhood Search Intent'), const SizedBox(height: 18), const CategoryBreakdown()]);
      });
}

class FakeChart extends StatelessWidget {
  const FakeChart({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) => RepaintBoundary(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w900)),
              const SizedBox(height: 8),
              const Text('Daily request pattern across Silver Towers', style: TextStyle(color: muted, fontWeight: FontWeight.w600)),
              const SizedBox(height: 22),
              SizedBox(
                height: 230,
                child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  for (final h in [72.0, 104.0, 168.0, 128.0, 204.0, 226.0, 190.0])
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Container(height: h, decoration: BoxDecoration(color: h == 226 ? primary : const Color(0xFFE2E8F0), borderRadius: BorderRadius.circular(12))),
                      ),
                    ),
                ]),
              ),
            ]),
          ),
        ),
      );
}

class CategoryBreakdown extends StatelessWidget {
  const CategoryBreakdown({super.key});
  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(children: const [
            Align(alignment: Alignment.centerLeft, child: Text('Active Categories', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w900))),
            SizedBox(height: 28),
            SizedBox(width: 170, height: 170, child: CircularProgressIndicator(value: .45, strokeWidth: 18, color: primary, backgroundColor: Color(0xFFE2E8F0))),
            SizedBox(height: 18),
            CategoryLine('Grocery', '45%', primary),
            CategoryLine('Electronics', '25%', ink),
            CategoryLine('Fashion', '15%', muted),
          ]),
        ),
      );
}

class CategoryLine extends StatelessWidget {
  const CategoryLine(this.name, this.value, this.color, {super.key});
  final String name;
  final String value;
  final Color color;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Row(children: [CircleAvatar(radius: 5, backgroundColor: color), const SizedBox(width: 10), Expanded(child: Text(name, style: const TextStyle(fontWeight: FontWeight.w800))), Text(value, style: const TextStyle(fontWeight: FontWeight.w900))]),
      );
}

class SignalCard extends StatelessWidget {
  const SignalCard({super.key, required this.title, required this.body, required this.icon});
  final String title;
  final String body;
  final IconData icon;
  @override
  Widget build(BuildContext context) => Card(
        margin: const EdgeInsets.only(bottom: 14),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(children: [
            CircleAvatar(radius: 26, backgroundColor: const Color(0xFFEAF2FF), child: Icon(icon, color: primary)),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)), const SizedBox(height: 5), Text(body, style: const TextStyle(color: muted, fontWeight: FontWeight.w600))])),
          ]),
        ),
      );
}

class SummaryLine extends StatelessWidget {
  const SummaryLine(this.label, this.value, {super.key});
  final String label;
  final String value;

@override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(children: [
          Expanded(child: Text(label, style: const TextStyle(color: muted, fontWeight: FontWeight.w700))),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w900, color: ink)),
        ]),
      );
}

class AdminPulseCard extends StatelessWidget {
  const AdminPulseCard({super.key, required this.text, required this.time, required this.icon});
  final String text;
  final String time;
  final IconData icon;
  @override
  Widget build(BuildContext context) => Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: ListTile(leading: CircleAvatar(backgroundColor: const Color(0xFFF8FAFC), child: Icon(icon, color: primary)), title: Text(text, style: const TextStyle(fontWeight: FontWeight.w900)), subtitle: Text(time, style: const TextStyle(color: muted, fontWeight: FontWeight.w700))),
      );
}

class UserTile extends StatelessWidget {
  const UserTile(this.name, this.block, this.orders, {super.key});
  final String name;
  final String block;
  final String orders;
  @override
  Widget build(BuildContext context) => Card(margin: const EdgeInsets.only(bottom: 12), child: ListTile(contentPadding: const EdgeInsets.all(16), leading: const CircleAvatar(child: Icon(Icons.person)), title: Text(name, style: const TextStyle(fontWeight: FontWeight.w900)), subtitle: Text(block), trailing: Text(orders, style: const TextStyle(fontWeight: FontWeight.w900))));
}

class AppInput extends StatelessWidget {
  const AppInput(this.label, {super.key, this.lines = 1});
  final String label;
  final int lines;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: TextField(maxLines: lines, decoration: InputDecoration(labelText: label, filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(22), borderSide: BorderSide.none))),
      );
}

class SectionHeader extends StatelessWidget {
  const SectionHeader(this.title, this.action, {super.key});
  final String title;
  final String action;
  @override
  Widget build(BuildContext context) => Row(children: [Expanded(child: Text(title, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w900, color: ink))), Text(action, style: const TextStyle(color: primary, fontWeight: FontWeight.w900))]);
}

class Kicker extends StatelessWidget {
  const Kicker(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) => Text(text, style: const TextStyle(fontSize: 10, letterSpacing: 2.4, fontWeight: FontWeight.w900, color: muted));
}

class CategoryPill extends StatelessWidget {
  const CategoryPill(this.label, this.icon, {super.key});
  final String label;
  final IconData icon;
  @override
  Widget build(BuildContext context) => Container(
        width: 112,
        height: 92,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(26), boxShadow: shadowSm),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(icon, color: primary), const SizedBox(height: 8), Text(label, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12))]),
      );
}

class GradientButton extends StatelessWidget {
  const GradientButton(this.label, this.icon, this.onTap, {super.key, this.compact = false});
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool compact;
  @override
  Widget build(BuildContext context) => InkWell(
        borderRadius: BorderRadius.circular(compact ? 22 : 28),
        onTap: onTap,
        child: Container(
          height: compact ? 48 : 58,
          decoration: BoxDecoration(gradient: navGradient, borderRadius: BorderRadius.circular(compact ? 22 : 28), boxShadow: [BoxShadow(color: primary.withValues(alpha: .24), blurRadius: 22, offset: const Offset(0, 10))]),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(icon, color: Colors.white, size: compact ? 18 : 22), const SizedBox(width: 8), Text(label, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: compact ? 12 : 16))]),
        ),
      );
}

class Brand extends StatelessWidget {
  const Brand({super.key, required this.size});
  final double size;
  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(gradient: navGradient, borderRadius: BorderRadius.circular(size * .32), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: .08), blurRadius: 18, offset: const Offset(0, 8))]),
        child: Icon(Icons.shopping_bag, color: Colors.white, size: size * .52),
      );
}

class BadgeText extends StatelessWidget {
  const BadgeText(this.text, {super.key, this.dark = false});
  final String text;
  final bool dark;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(color: dark ? const Color(0xFFF1F5F9) : Colors.white.withValues(alpha: .2), borderRadius: BorderRadius.circular(12)),
        child: Text(text.toUpperCase(), style: TextStyle(color: dark ? const Color(0xFF475569) : Colors.white, fontSize: 8, fontWeight: FontWeight.w900, letterSpacing: 1.2)),
      );
}

class SearchToken extends StatelessWidget {
  const SearchToken(this.label, {super.key});
  final String label;
  @override
  Widget build(BuildContext context) => Chip(
        label: Text(label, style: const TextStyle(fontWeight: FontWeight.w900)),
        avatar: const Icon(Icons.history, size: 16),
        backgroundColor: Colors.white,
        side: const BorderSide(color: Color(0xFFEFF2F5)),
      );
}

class FrostedBuyButton extends StatelessWidget {
  const FrostedBuyButton({super.key, required this.onTap});
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          height: 50,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .72),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [BoxShadow(color: Colors.white.withValues(alpha: .25), blurRadius: 14)],
          ),
          child: const Text('Buy', style: TextStyle(color: ink, fontWeight: FontWeight.w900, fontSize: 16)),
        ),
      );
}

class GlassIcon extends StatelessWidget {
  const GlassIcon({super.key, required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(width: 48, height: 48, decoration: BoxDecoration(color: Colors.white.withValues(alpha: .18), borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.white24)), child: Icon(icon, color: Colors.white)),
      );
}

class GlassRoundIcon extends StatelessWidget {
  const GlassRoundIcon({super.key, required this.icon, required this.onTap, this.size = 38, this.iconSize = 19, this.iconColor = muted});
  final IconData icon;
  final VoidCallback onTap;
  final double size;
  final double iconSize;
  final Color iconColor;
  Widget build(BuildContext context) => RepaintBoundary(
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withValues(alpha: .78)),
          child: InkWell(
            onTap: onTap,
            customBorder: const CircleBorder(),
            child: Icon(icon, size: iconSize, color: iconColor),
          ),
        ),
      );
}

class FavoriteButton extends StatefulWidget {
  const FavoriteButton({this.size = 28, this.iconSize = 14});
  final double size;
  final double iconSize;
  @override
  State<FavoriteButton> createState() => FavoriteButtonState();
}

class FavoriteButtonState extends State<FavoriteButton> {
  bool _isSaved = false;
  @override
  Widget build(BuildContext context) {
    return GlassRoundIcon(
      icon: _isSaved ? Icons.favorite : Icons.favorite_border,
      iconColor: _isSaved ? const Color(0xFFE53935) : muted,
      size: widget.size,
      iconSize: widget.iconSize,
      onTap: () => setState(() => _isSaved = !_isSaved),
    );
  }
}

class IconPanel extends StatelessWidget {
  const IconPanel({super.key, required this.icon});
  final IconData icon;
  @override
  Widget build(BuildContext context) => Container(width: 54, height: 54, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: shadowSm), child: Icon(icon, color: primary));
}

class MapChip extends StatelessWidget {
  const MapChip({super.key, required this.text, required this.icon, required this.active});
  final String text;
  final IconData icon;
  final bool active;
  @override
  Widget build(BuildContext context) => Chip(avatar: Icon(icon, size: 16, color: active ? Colors.white : primary), label: Text(text), backgroundColor: active ? primary : Colors.white, labelStyle: TextStyle(color: active ? Colors.white : ink, fontWeight: FontWeight.w900), side: BorderSide.none);
}

class MapRoad extends StatelessWidget {
  const MapRoad({super.key, required this.width, required this.height, this.turn = false});
  final double width;
  final double height;
  final bool turn;

@override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: turn ? -.34 : .14,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: .70),
          borderRadius: BorderRadius.circular(42),
          border: Border.all(color: Colors.white, width: 8),
        ),
      ),
    );
  }
}

class RouteDot extends StatelessWidget {
  const RouteDot({super.key, required this.color, required this.icon});
  final Color color;
  final IconData icon;

@override
  Widget build(BuildContext context) {
    return Container(
      width: 58,
      height: 58,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color, border: Border.all(color: Colors.white, width: 5), boxShadow: shadowSm),
      child: Icon(icon, color: Colors.white, size: 24),
    );
  }
}

class ActionPill extends StatelessWidget {
  const ActionPill(this.label, this.icon, this.active, {super.key});
  final String label;
  final IconData icon;
  final bool active;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(color: active ? ink : Colors.white, borderRadius: BorderRadius.circular(18), boxShadow: shadowSm),
        child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(icon, size: 16, color: active ? Colors.white : muted), const SizedBox(width: 6), Text(label, style: TextStyle(color: active ? Colors.white : ink, fontWeight: FontWeight.w900, fontSize: 12))]),
      );
}

class SettingsTile extends StatelessWidget {
  const SettingsTile({
    super.key,
    required this.title,
    required this.icon,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.danger = false,
  });

  final String title;
  final String? subtitle;
  final IconData icon;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: danger ? Colors.red.withValues(alpha: .1) : primary.withValues(alpha: .1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: danger ? Colors.red : primary, size: 24),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 16,
            color: danger ? Colors.red : ink,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle!,
                style: const TextStyle(
                  color: muted,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              )
            : null,
        trailing: trailing ?? const Icon(Icons.chevron_right, color: muted, size: 20),
      ),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.name,
    required this.location,
    required this.shopsFollowed,
    required this.neighborsFollowing,
  });

  final String name;
  final String location;
  final int shopsFollowed;
  final int neighborsFollowing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: navGradient,
        borderRadius: BorderRadius.circular(32),
        boxShadow: shadowLg,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                  image: const DecorationImage(
                    image: NetworkImage('https://api.dicebear.com/7.x/avataaars/png?seed=Aryan'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.verified, color: Colors.blueAccent, size: 18),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      location,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: .7),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStat('Shops Followed', shopsFollowed.toString()),
              _buildStat('Neighbors Following', neighborsFollowing.toString()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label.toUpperCase(),
          style: TextStyle(
            color: Colors.white.withValues(alpha: .6),
            fontSize: 9,
            letterSpacing: 1.2,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class SocialButton extends StatelessWidget {
  const SocialButton({super.key, required this.label, required this.icon, required this.onTap, this.color});
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 20, color: color ?? primary),
      label: Text(label, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(56),
        foregroundColor: color ?? primary,
        side: BorderSide(color: (color ?? primary).withValues(alpha: .2), width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
    );
  }
}

class OtpInput extends StatefulWidget {
  const OtpInput({super.key, required this.onCompleted});
  final Function(String) onCompleted;

  @override
  State<OtpInput> createState() => _OtpInputState();
}

class _OtpInputState extends State<OtpInput> {
  final List<TextEditingController> _controllers = List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  @override
  void dispose() {
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value, int index) {
    if (value.length == 1 && index < 3) {
      _focusNodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
    
    final code = _controllers.map((c) => c.text).join();
    if (code.length == 4) {
      widget.onCompleted(code);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(4, (index) {
        return SizedBox(
          width: 64,
          height: 64,
          child: TextField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: ink),
            decoration: InputDecoration(
              counterText: '',
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: primary, width: 2)),
            ),
            onChanged: (v) => _onChanged(v, index),
          ),
        );
      }),
    );
  }
}

class ProfilePicPicker extends StatelessWidget {
  const ProfilePicPicker({super.key, this.imageUrl, required this.onTap});
  final String? imageUrl;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: primary.withValues(alpha: .05),
              border: Border.all(color: primary.withValues(alpha: .1), width: 4),
              image: imageUrl != null ? DecorationImage(image: NetworkImage(imageUrl!), fit: BoxFit.cover) : null,
            ),
            child: imageUrl == null ? const Icon(Icons.person_outline, size: 48, color: primary) : null,
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(color: primary, shape: BoxShape.circle),
                child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

