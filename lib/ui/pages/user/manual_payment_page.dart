import 'package:flutter/material.dart';
import 'package:dukaan_zone_flutter/dukaan.dart';

class ManualPaymentPage extends StatelessWidget {
  const ManualPaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AppPage(
        maxWidth: 800,
        children: [
          const PageTitle('Send to Number', 'Enter mobile or select from recent contacts.'),
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
                hintText: 'Enter mobile number or name',
                border: InputBorder.none,
                hintStyle: TextStyle(color: muted, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          
          const SizedBox(height: 32),
          const Kicker('RECENT ACCOUNTS'),
          const SizedBox(height: 16),
          
          SizedBox(
            height: 110,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _RecentContact(name: 'Rahul', initial: 'R', color: Colors.blue),
                _RecentContact(name: 'Sneha', initial: 'S', color: Colors.purple),
                _RecentContact(name: 'Amit', initial: 'A', color: Colors.green),
                _RecentContact(name: 'Priya', initial: 'P', color: Colors.orange),
                _RecentContact(name: 'Vikram', initial: 'V', color: Colors.teal),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          const Kicker('ALL CONTACTS'),
          const SizedBox(height: 12),
          
          for (final contact in _mockContacts)
            _ContactTile(contact: contact),
            
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _RecentContact extends StatelessWidget {
  const _RecentContact({required this.name, required this.initial, required this.color});
  final String name;
  final String initial;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: Column(
        children: [
          InkWell(
            onTap: () => push(context, ContactPaymentChatPage(name: name, color: color)),
            borderRadius: BorderRadius.circular(32),
            child: CircleAvatar(
              radius: 32,
              backgroundColor: color.withValues(alpha: .15),
              child: Text(initial, style: TextStyle(color: color, fontWeight: FontWeight.w900, fontSize: 24)),
            ),
          ),
          const SizedBox(height: 8),
          Text(name, style: const TextStyle(fontWeight: FontWeight.w800, color: ink, fontSize: 13)),
        ],
      ),
    );
  }
}

class _ContactTile extends StatelessWidget {
  const _ContactTile({required this.contact});
  final Map<String, String> contact;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => push(context, ContactPaymentChatPage(name: contact['name']!, color: Colors.blue)),
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
      leading: CircleAvatar(
        backgroundColor: const Color(0xFFF1F5F9),
        child: Text(contact['name']![0], style: const TextStyle(color: ink, fontWeight: FontWeight.w800)),
      ),
      title: Text(contact['name']!, style: const TextStyle(fontWeight: FontWeight.w900, color: ink)),
      subtitle: Text(contact['number']!, style: const TextStyle(color: muted, fontWeight: FontWeight.w600)),
      trailing: const Icon(Icons.chevron_right, color: muted),
    );
  }
}

const _mockContacts = [
  {'name': 'Arjun Mehta', 'number': '+91 98765 43210'},
  {'name': 'Deepika Kaur', 'number': '+91 87654 32109'},
  {'name': 'Karan Singh', 'number': '+91 76543 21098'},
  {'name': 'Sunita Rao', 'number': '+91 65432 10987'},
];

class ContactPaymentChatPage extends StatefulWidget {
  const ContactPaymentChatPage({super.key, required this.name, required this.color});
  final String name;
  final Color color;

  @override
  State<ContactPaymentChatPage> createState() => _ContactPaymentChatPageState();
}

class _ContactPaymentChatPageState extends State<ContactPaymentChatPage> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _history = [
    {'amount': '₹10,300', 'status': 'PAID', 'time': '2:02 PM', 'date': 'April 25, 2026', 'isSent': true},
    {'amount': '₹2,000', 'status': 'RECEIVED', 'time': '10:31 AM', 'date': 'Today', 'isSent': false},
    {'amount': '₹4,600', 'status': 'PAID', 'time': '9:25 AM', 'date': 'Today', 'isSent': true},
  ];

  void _handlePay() {
    if (_controller.text.isEmpty) return;
    final amount = '₹${_controller.text}';
    push(context, PinEntryPage(
      amount: amount, 
      orderId: 'TXN-${DateTime.now().millisecond}',
    )).then((success) {
      if (success == true) {
        setState(() {
          _history.add({
            'amount': amount,
            'status': 'PAID',
            'time': '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')} ${DateTime.now().hour >= 12 ? 'PM' : 'AM'}',
            'date': 'Today',
            'isSent': true,
          });
        });
        _controller.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
              child: Text(widget.name[0], style: TextStyle(color: widget.color, fontWeight: FontWeight.w900, fontSize: 14)),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: ink)),
                const Text('+91 98712 14553', style: TextStyle(fontSize: 11, color: muted, fontWeight: FontWeight.w600)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.history_toggle_off_rounded, size: 22)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.help_outline_rounded, size: 22)),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              itemCount: _history.length,
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
                    _PaymentBubble(
                      amount: item['amount'],
                      status: item['status'],
                      time: item['time'],
                      isSent: item['isSent'],
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
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: 'Enter amount or chat',
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: muted, fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.image_outlined, color: muted)),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.add_circle_outline, color: muted)),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: _handlePay,
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

class _PaymentBubble extends StatelessWidget {
  const _PaymentBubble({
    required this.amount,
    required this.status,
    required this.time,
    required this.isSent,
  });

  final String amount;
  final String status;
  final String time;
  final bool isSent;

  @override
  Widget build(BuildContext context) {
    final bgColor = isSent ? const Color(0xFFEDE7F6) : const Color(0xFFF1F4F9);
    final statusColor = status == 'PAID' ? Colors.green : Colors.blue;

    return Align(
      alignment: isSent ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        width: 240,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
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
              ],
            ),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(time, style: const TextStyle(fontSize: 10, color: muted, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }
}
