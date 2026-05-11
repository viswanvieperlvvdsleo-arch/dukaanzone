import 'package:flutter/material.dart';
import 'package:dukaan_zone_flutter/dukaan.dart';

class UserSavedPage extends StatefulWidget {
  const UserSavedPage({super.key});

  @override
  State<UserSavedPage> createState() => _UserSavedPageState();
}

class _UserSavedPageState extends State<UserSavedPage> {
  // Mock state: Start with the first 3 catalog products
  late List<Product> _savedItems;

  @override
  void initState() {
    super.initState();
    _savedItems = catalogProducts.take(3).toList();
  }

  void _unsaveItem(Product product) {
    setState(() {
      _savedItems.removeWhere((p) => p.id == product.id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} removed from saved list.'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _addToCart(Product product) {
    push(context, CheckoutPage(product: product));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 980),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const PageTitle('Your Saved Favourites', 'Neighborhood picks, curated and waiting.'),
                const SizedBox(height: 16),
                
                // Create New List Pill
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF2FF),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Create New List',
                    style: TextStyle(fontWeight: FontWeight.w800, color: ink, fontSize: 13),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Saved Items List
                if (_savedItems.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(40.0),
                      child: Text('No saved items left.', style: TextStyle(color: muted, fontWeight: FontWeight.w600)),
                    ),
                  )
                else
                  for (final product in _savedItems) ...[
                    _SavedItemCard(
                      product: product,
                      onUnsave: () => _unsaveItem(product),
                      onAddToCart: () => _addToCart(product),
                      onTap: () => push(context, ProductDetailPage(product: product)),
                    ),
                    const SizedBox(height: 16),
                  ],

                const SizedBox(height: 24),

                // Show All Bottom Button
                if (_savedItems.isNotEmpty)
                  Center(
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Show All Saved Items',
                        style: TextStyle(color: ink, fontWeight: FontWeight.w800, fontSize: 14),
                      ),
                    ),
                  ),
                  
                const SizedBox(height: 40), // Spacing for FAB
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SavedItemCard extends StatelessWidget {
  const _SavedItemCard({
    required this.product,
    required this.onUnsave,
    required this.onAddToCart,
    required this.onTap,
  });

  final Product product;
  final VoidCallback onUnsave;
  final VoidCallback onAddToCart;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: shadowSm,
        ),
        child: Column(
          children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image / Icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: product.tint,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(product.icon, size: 40, color: ink.withValues(alpha: .5)),
              ),
              const SizedBox(width: 16),
              
              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            product.name,
                            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: ink, height: 1.2),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          product.price,
                          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: ink),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.shop,
                      style: const TextStyle(color: muted, fontWeight: FontWeight.w600, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Bottom Row Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Rating
              Row(
                children: const [
                  Icon(Icons.star, color: Color(0xFFFBBF24), size: 20),
                  SizedBox(width: 4),
                  Text('4.5/5', style: TextStyle(fontWeight: FontWeight.w700, color: muted)),
                ],
              ),
              
              // Buttons
              Row(
                children: [
                  IconButton(
                    onPressed: onUnsave,
                    icon: const Icon(Icons.favorite, color: Colors.redAccent),
                    tooltip: 'Unsave',
                  ),
                  IconButton(
                    onPressed: () {
                      globalMapState.value = MapState(mode: MapMode.routing, destinationName: product.shop);
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                    icon: const Icon(Icons.location_on, color: primary),
                    tooltip: 'Navigate to Shop',
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    height: 40,
                    width: 90,
                    child: GradientButton(
                      'Buy',
                      Icons.shopping_cart,
                      onAddToCart,
                      compact: true,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
}
