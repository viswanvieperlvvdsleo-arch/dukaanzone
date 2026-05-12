import 'package:flutter/material.dart';
import 'package:dukaan_zone_flutter/dukaan.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key, required this.role});
  final Role role;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _submitSearch(String query) {
    if (query.trim().isEmpty) return;
    push(context, SearchResultsPage(query: query.trim(), role: widget.role));
  }

  @override
  Widget build(BuildContext context) {
    final hint = widget.role == Role.admin 
        ? 'Search shops, users, listings...' 
        : widget.role == Role.seller 
            ? 'Search products or order IDs...' 
            : 'Search milk, bread, earbuds...';

    void goBack() {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => RoleShell(role: widget.role)),
        (route) => false,
      );
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        goBack();
      },
      child: Scaffold(
        backgroundColor: bg,
        appBar: AppBar(
          backgroundColor: bg,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: goBack,
          ),
          title: TextField(
          controller: _searchController,
          autofocus: true,
          onChanged: (val) => setState(() => _query = val),
          onSubmitted: _submitSearch,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search, color: primary),
            suffixIcon: _query.isNotEmpty 
                ? IconButton(
                    icon: const Icon(Icons.clear, color: muted),
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _query = '');
                    },
                  ) 
                : null,
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none),
          ),
        ),
      ),
      body: AppPage(
        children: [
          const Kicker('TRENDING NEAR YOU'),
          const SizedBox(height: 14),
          for (final product in catalogProducts.take(3)) 
            CompactProductTile(product: product),
          const SizedBox(height: 24),
          const Kicker('RECENT SEARCHES'),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10, 
            runSpacing: 10, 
            children: [
              _buildClickableToken('Organic Milk'),
              _buildClickableToken('Bananas'),
              _buildClickableToken('Earbuds'),
              _buildClickableToken('Mixed Greens'),
            ],
          ),
        ],
      ),
    ));
  }

  Widget _buildClickableToken(String label) {
    return InkWell(
      onTap: () {
        _searchController.text = label;
        _submitSearch(label);
      },
      borderRadius: BorderRadius.circular(16),
      child: SearchToken(label),
    );
  }
}
