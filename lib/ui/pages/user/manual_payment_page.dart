import 'package:flutter/material.dart';
import 'package:dukaan_zone_flutter/dukaan.dart';

class ShopPaymentPage extends StatelessWidget {
  const ShopPaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AppPage(
        maxWidth: 800,
        children: [
          const PageTitle('Pay Shop', 'Scan or select a nearby shop.'),
          const SizedBox(height: 24),
          
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F6F8),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0xFFEFF2F5)),
            ),
            child: const TextField(
              decoration: InputDecoration(
                icon: Icon(Icons.search, color: muted),
                hintText: 'Search shops by name or ID',
                border: InputBorder.none,
                hintStyle: TextStyle(color: muted, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          
          const SizedBox(height: 32),
          const Kicker('RECENT SHOPS'),
          const SizedBox(height: 16),
          
          SizedBox(
            height: 110,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: shops.length,
              itemBuilder: (context, i) => RepaintBoundary(
                child: _RecentShopTile(
                  shop: shops[i], 
                  color: [Colors.blue, Colors.purple, Colors.green][i % 3],
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          const Kicker('ALL SHOPS'),
          const SizedBox(height: 12),
          
          for (final shop in shops)
            RepaintBoundary(child: _ShopListTile(shop: shop)),
            
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _RecentShopTile extends StatelessWidget {
  const _RecentShopTile({required this.shop, required this.color});
  final Shop shop;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: Column(
        children: [
          InkWell(
            onTap: () => push(context, ShopPaymentChatPage(shop: shop, color: color)),
            borderRadius: BorderRadius.circular(32),
            child: CircleAvatar(
              radius: 32,
              backgroundColor: color.withValues(alpha: .15),
              child: Text(shop.name[0], style: TextStyle(color: color, fontWeight: FontWeight.w900, fontSize: 24)),
            ),
          ),
          const SizedBox(height: 8),
          Text(shop.name.split(' ').first, style: const TextStyle(fontWeight: FontWeight.w800, color: ink, fontSize: 13)),
        ],
      ),
    );
  }
}

class _ShopListTile extends StatelessWidget {
  const _ShopListTile({required this.shop});
  final Shop shop;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => push(context, ShopPaymentChatPage(shop: shop, color: Colors.blue)),
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
      leading: CircleAvatar(
        backgroundColor: const Color(0xFFF1F5F9),
        child: Text(shop.name[0], style: const TextStyle(color: ink, fontWeight: FontWeight.w800)),
      ),
      title: Text(shop.name, style: const TextStyle(fontWeight: FontWeight.w900, color: ink)),
      subtitle: Text('${shop.type} • ${shop.block}', style: const TextStyle(color: muted, fontWeight: FontWeight.w600)),
      trailing: const Icon(Icons.chevron_right, color: muted),
    );
  }
}

class ShopPaymentChatPage extends StatefulWidget {
  const ShopPaymentChatPage({super.key, required this.shop, required this.color});
  final Shop shop;
  final Color color;

  @override
  State<ShopPaymentChatPage> createState() => _ShopPaymentChatPageState();
}

class _ShopPaymentChatPageState extends State<ShopPaymentChatPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _history = [
    {'amount': '₹120', 'status': 'PAID', 'time': '9:25 AM', 'date': 'Today', 'isSent': true, 'items': 'Samosa Platter, Tea'},
  ];

  void _showBankSelection(String amountStr) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Select Bank Account', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
              const SizedBox(height: 8),
              Text('Paying $amountStr to ${widget.shop.name}', style: const TextStyle(color: muted)),
              const SizedBox(height: 24),
              ListTile(
                onTap: () {
                  Navigator.pop(ctx);
                  _proceedToPin(amountStr, 'HDFC Bank');
                },
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.account_balance, color: Colors.blue),
                ),
                title: const Text('HDFC Bank', style: TextStyle(fontWeight: FontWeight.w800)),
                subtitle: const Text('**** 1234'),
                trailing: const Icon(Icons.check_circle, color: primary),
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(ctx);
                  _proceedToPin(amountStr, 'SBI Bank');
                },
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.account_balance, color: Colors.green),
                ),
                title: const Text('State Bank of India', style: TextStyle(fontWeight: FontWeight.w800)),
                subtitle: const Text('**** 5678'),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      }
    );
  }

  void _proceedToPin(String amountStr, String bank) {
    push(context, PinEntryPage(
      amount: amountStr, 
      orderId: 'TXN-${DateTime.now().millisecond}',
    )).then((success) {
      if (success == true) {
        final newTx = {
          'merchant': widget.shop.name,
          'date': 'Today, ${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')} ${DateTime.now().hour >= 12 ? 'PM' : 'AM'}',
          'amount': amountStr,
          'items': 'Direct Payment ($bank)',
          'icon': Icons.storefront_outlined,
        };
        
        // Update global history
        globalPaymentHistory.value = [
          newTx,
          ...globalPaymentHistory.value,
        ];

        setState(() {
          _history.add({
            'amount': amountStr,
            'status': 'PAID',
            'time': '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')} ${DateTime.now().hour >= 12 ? 'PM' : 'AM'}',
            'date': 'Today',
            'isSent': true,
            'items': 'Direct Payment',
          });
        });
        _controller.clear();
      }
    });
  }

  void _handleSend() {
    if (_controller.text.isEmpty) return;
    
    // If it's a number, treat as payment. Otherwise, treat as chat message.
    final text = _controller.text;
    final isNumber = double.tryParse(text) != null;
    
    if (isNumber) {
      _showBankSelection('₹$text');
    } else {
      // Just a chat message
      setState(() {
        _history.add({
          'message': text,
          'time': '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')} ${DateTime.now().hour >= 12 ? 'PM' : 'AM'}',
          'date': 'Today',
          'isSent': true,
        });
      });
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        leadingWidth: 40,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: widget.color.withValues(alpha: .15),
              child: Text(widget.shop.name[0], style: TextStyle(color: widget.color, fontWeight: FontWeight.w900, fontSize: 14)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.shop.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: ink)),
                  Text('${widget.shop.type} • ⭐ ${widget.shop.rating}', style: const TextStyle(fontSize: 11, color: muted, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.history_toggle_off_rounded, size: 22)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.storefront_outlined, size: 22)),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              itemCount: _history.length,
              cacheExtent: 400,
              itemBuilder: (context, index) {
                final item = _history[index];
                bool showDate = index == 0 || _history[index]['date'] != _history[index - 1]['date'];
                
                return Column(
                  children: [
                    if (showDate)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Text(item['date'], style: const TextStyle(color: muted, fontSize: 12, fontWeight: FontWeight.w700)),
                      ),
                    
                    if (item.containsKey('message'))
                      _ChatBubble(message: item['message'], time: item['time'], isSent: item['isSent'])
                    else
                      _PaymentBubble(
                        amount: item['amount'],
                        status: item['status'],
                        time: item['time'],
                        isSent: item['isSent'],
                        items: item['items'],
                      ),
                    const SizedBox(height: 16),
                  ],
                );
              },
            ),
          ),
          
          // Input Area
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey.shade100)),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F4F9),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          hintText: 'Enter amount or message',
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: muted, fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.qr_code_scanner, color: muted)),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: _handleSend,
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        gradient: navGradient,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({required this.message, required this.time, required this.isSent});
  final String message;
  final String time;
  final bool isSent;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSent ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 240),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSent ? primary : const Color(0xFFF1F4F9),
          borderRadius: BorderRadius.circular(20).copyWith(
            bottomRight: isSent ? const Radius.circular(4) : null,
            bottomLeft: !isSent ? const Radius.circular(4) : null,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(message, style: TextStyle(color: isSent ? Colors.white : ink, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(time, style: TextStyle(color: isSent ? Colors.white70 : muted, fontSize: 10, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

class _PaymentBubble extends StatelessWidget {
  const _PaymentBubble({
    required this.amount,
    required this.status,
    required this.time,
    required this.isSent,
    required this.items,
  });

  final String amount;
  final String status;
  final String time;
  final bool isSent;
  final String items;

  @override
  Widget build(BuildContext context) {
    final bgColor = isSent ? const Color(0xFFEDE7F6) : const Color(0xFFF1F4F9);
    final statusColor = status == 'PAID' ? Colors.green : Colors.blue;

    return Align(
      alignment: isSent ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        width: 250,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20).copyWith(
            bottomRight: isSent ? const Radius.circular(4) : null,
            bottomLeft: !isSent ? const Radius.circular(4) : null,
          ),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: .03), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  amount,
                  style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: ink),
                ),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: .5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_forward_rounded, size: 16, color: muted),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.check_circle, size: 14, color: statusColor),
                const SizedBox(width: 6),
                Text(
                  status,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.grey.shade600, letterSpacing: 1),
                ),
                const Spacer(),
                Text(time, style: const TextStyle(fontSize: 10, color: muted, fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
                    builder: (ctx) => Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Transaction Details', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
                          const SizedBox(height: 16),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.receipt_long, color: primary),
                            title: const Text('Items Paid For', style: TextStyle(fontWeight: FontWeight.w800)),
                            subtitle: Text(items, style: const TextStyle(color: muted)),
                          ),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.tag, color: primary),
                            title: const Text('Transaction ID', style: TextStyle(fontWeight: FontWeight.w800)),
                            subtitle: Text('TXN-${DateTime.now().millisecondsSinceEpoch}', style: const TextStyle(color: muted)),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: primary,
                  side: BorderSide(color: primary.withValues(alpha: .3)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('View Details', style: TextStyle(fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
