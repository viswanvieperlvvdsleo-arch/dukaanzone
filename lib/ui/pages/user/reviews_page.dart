import 'package:flutter/material.dart';
import 'package:dukaan_zone_flutter/dukaan.dart';

class ReviewsPage extends StatefulWidget {
  const ReviewsPage({super.key, required this.productId});
  final String productId;

  @override
  State<ReviewsPage> createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage> {
  final TextEditingController _controller = TextEditingController();
  bool _isSubmitting = false;

  Future<void> _submitReview() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() => _isSubmitting = true);
    await reviewService.addReview(widget.productId, text);
    
    if (!mounted) return;
    setState(() {
      _isSubmitting = false;
      _controller.clear();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: const Text('Reviews', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: FutureBuilder<List<String>>(
        // We do not pass a strictly cached future here because we want it to rebuild and fetch the updated list on setState.
        future: reviewService.getReviews(widget.productId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          
          final reviews = snapshot.data!;
          
          return ListView.separated(
            padding: const EdgeInsets.all(24),
            itemCount: reviews.length + 1,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              if (index == 0) {
                // Submit Form
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Add your review', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: 'How was the product?',
                          filled: true,
                          fillColor: bg,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                          suffixIcon: _isSubmitting 
                              ? const Padding(
                                  padding: EdgeInsets.all(12),
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : IconButton(
                                  icon: const Icon(Icons.send, color: primary),
                                  onPressed: _submitReview,
                                ),
                        ),
                        maxLines: 3,
                        minLines: 1,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _submitReview(),
                      ),
                    ],
                  ),
                );
              }
              // Review Item
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CircleAvatar(radius: 16, backgroundColor: bg, child: Icon(Icons.person, size: 16, color: muted)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Verified Buyer', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: muted)),
                          const SizedBox(height: 4),
                          Text(reviews[index - 1], style: const TextStyle(fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
