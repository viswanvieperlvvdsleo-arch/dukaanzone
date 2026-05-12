import 'package:flutter/material.dart';
import 'package:dukaan_zone_flutter/dukaan.dart';

class SearchResultsPage extends StatelessWidget {
  const SearchResultsPage({super.key, required this.query, required this.role});
  final String query;
  final Role role;

  void _goHome(BuildContext context) {
    Navigator.pop(context); // Pop SearchResultsPage
    Navigator.pop(context); // Pop SearchPage
  }

  @override
  Widget build(BuildContext context) {
    // Filter logic
    final results = catalogProducts.where((p) => 
      p.name.toLowerCase().contains(query.toLowerCase()) || 
      p.shop.toLowerCase().contains(query.toLowerCase()) ||
      p.badge.toLowerCase().contains(query.toLowerCase())
    ).toList();

    return Scaffold(
      backgroundColor: bg,
      appBar: MainHeader(
        role: role,
        onExit: () => Navigator.pop(context),
      ),
      body: results.isEmpty 
          ? _buildEmptyState() 
          : _buildResultsList(results),
      floatingActionButton: role == Role.user
          ? GestureDetector(
              onTap: () => _goHome(context),
              child: Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: primary,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))],
                ),
                child: const Icon(Icons.qr_code_scanner, size: 28, color: Colors.white),
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: role == Role.user 
          ? NavigationBar(
              selectedIndex: 0,
              height: 72,
              onDestinationSelected: (i) => _goHome(context),
              destinations: const [
                NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
                NavigationDestination(icon: Icon(Icons.map_outlined), label: 'Map'),
                NavigationDestination(icon: Icon(Icons.qr_code_scanner, color: Colors.transparent), label: 'Scan'),
                NavigationDestination(icon: Icon(Icons.favorite_border), label: 'Saved'),
                NavigationDestination(icon: Icon(Icons.history_rounded), label: 'History'),
              ],
            )
          : null,
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded, size: 80, color: muted.withOpacity(0.3)),
          const SizedBox(height: 24),
          const Text('No matches found', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: ink)),
          const SizedBox(height: 8),
          const Text('Try adjusting your search terms.', style: TextStyle(color: muted, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildResultsList(List<Product> results) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      physics: const BouncingScrollPhysics(),
      itemCount: results.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Search Results', style: TextStyle(color: ink, fontSize: 14, fontWeight: FontWeight.w600)),
                Text('"$query"', style: const TextStyle(color: primary, fontSize: 22, fontWeight: FontWeight.w900)),
              ],
            ),
          );
        }
        return _SearchResultCard(product: results[index - 1]);
      },
    );
  }
}

class _SearchResultCard extends StatelessWidget {
  const _SearchResultCard({required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: shadowSm,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () => push(context, ProductDetailPage(product: product)),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Product Image / Icon
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: product.tint,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Stack(
                    children: [
                      Center(child: Icon(product.icon, size: 52, color: ink.withOpacity(0.5))),
                      Positioned(
                        left: 4, 
                        top: 4, 
                        child: GlassRoundIcon(
                          icon: Icons.location_on, 
                          size: 24, 
                          iconSize: 12, 
                          iconColor: primary, 
                          onTap: () {
                            globalMapState.value = MapState(mode: MapMode.routing, destinationName: product.shop);
                          }
                        )
                      ),
                      const Positioned(
                        right: 4, 
                        top: 4, 
                        child: FavoriteButton(size: 24, iconSize: 12)
                      ),
                      Positioned(
                        bottom: 4,
                        right: 4,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.star, size: 8, color: Colors.orange),
                              SizedBox(width: 2),
                              Text('4.8', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                
                // Product Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Badge
                      if (product.badge.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          margin: const EdgeInsets.only(bottom: 6),
                          decoration: BoxDecoration(
                            color: primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            product.badge.toUpperCase(),
                            style: const TextStyle(color: primary, fontSize: 8, fontWeight: FontWeight.w900, letterSpacing: 1),
                          ),
                        ),
                      
                      // Name
                      Text(
                        product.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, height: 1.1),
                      ),
                      const SizedBox(height: 4),
                      
                      // Shop
                      Row(
                        children: [
                          const Icon(Icons.storefront, size: 12, color: muted),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              product.shop,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: muted, fontSize: 11, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      
                      // Price & Action
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Text(
                              product.price,
                              style: const TextStyle(color: success, fontSize: 18, fontWeight: FontWeight.w900),
                            ),
                          ),
                          SizedBox(
                            height: 36,
                            width: 80,
                            child: GradientButton(
                              'Buy',
                              Icons.shopping_cart,
                              () => push(context, CheckoutPage(product: product)),
                              compact: true,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
