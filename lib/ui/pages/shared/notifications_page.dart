import 'package:flutter/material.dart';
import 'package:dukaan_zone_flutter/dukaan.dart';

class NotificationItem {
  final String id;
  final String title;
  final String? subtitle;
  final String timestamp;
  final IconData icon;
  final bool isDark;
  final String buttonLabel;
  final bool hasHeart;
  final bool hasLocation;
  bool isRead;
  bool isNew;

  NotificationItem({
    required this.id,
    required this.title,
    this.subtitle,
    required this.timestamp,
    required this.icon,
    required this.isDark,
    required this.buttonLabel,
    this.hasHeart = false,
    this.hasLocation = false,
    this.isRead = false,
    this.isNew = false,
  });
}

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> with SingleTickerProviderStateMixin {
  late List<NotificationItem> _notifications;
  late AnimationController _blinkController;

  @override
  void initState() {
    super.initState();
    _notifications = [
      NotificationItem(
        id: '1',
        isDark: true,
        icon: Icons.eco_outlined,
        title: 'New Stock Alert: Mixed Greens Collection back at Pooja General Store.',
        timestamp: '2 mins ago',
        buttonLabel: 'Go to Shop',
        hasHeart: true,
        isNew: true,
      ),
      NotificationItem(
        id: '2',
        isDark: false,
        icon: Icons.local_shipping_outlined,
        title: 'Order #DZ-4567 is out for delivery.',
        timestamp: '1 hour ago',
        buttonLabel: 'Track Order',
      ),
      NotificationItem(
        id: '3',
        isDark: true,
        icon: Icons.percent_outlined,
        title: 'Weekend Offer: 10% off Fresh Dairy.',
        subtitle: 'Available at all neighborhood stores.',
        timestamp: '3 hours ago',
        buttonLabel: 'See Offer',
        isNew: true,
      ),
      NotificationItem(
        id: '4',
        isDark: false,
        icon: Icons.shopping_bag_outlined,
        title: "New store 'Aman Snacks' is now live near you!",
        subtitle: 'Discover local bites.',
        timestamp: 'Yesterday',
        buttonLabel: 'Visit Store',
        hasLocation: true,
      ),
    ];

    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _blinkController.dispose();
    super.dispose();
  }

  void _markAllAsRead() {
    setState(() {
      for (var n in _notifications) {
        n.isRead = true;
        n.isNew = false;
      }
    });
  }

  void _clearAll() {
    setState(() {
      _notifications.clear();
    });
  }

  void _removeNotification(String id) {
    setState(() {
      _notifications.removeWhere((n) => n.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _notifications.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_off_outlined, size: 64, color: muted),
                  SizedBox(height: 16),
                  Text('All caught up!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: muted)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              itemCount: _notifications.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'Notifications',
                          style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.w900,
                            color: ink,
                            letterSpacing: -0.5,
                          ),
                        ),
                        if (_notifications.isNotEmpty)
                          Row(
                            children: [
                              TextButton(
                                onPressed: _markAllAsRead,
                                style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
                                child: const Text('Mark read', style: TextStyle(color: primary, fontWeight: FontWeight.w700, fontSize: 13)),
                              ),
                              IconButton(
                                onPressed: _clearAll,
                                icon: const Icon(Icons.delete_sweep_outlined, color: Colors.redAccent, size: 20),
                                visualDensity: VisualDensity.compact,
                                tooltip: 'Clear All',
                              ),
                            ],
                          ),
                      ],
                    ),
                  );
                }
                final item = _notifications[index - 1];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Dismissible(
                    key: Key(item.id),
                    direction: DismissDirection.horizontal,
                    onDismissed: (direction) => _removeNotification(item.id),
                    background: _buildDismissBackground(false),
                    secondaryBackground: _buildDismissBackground(true),
                    child: _ModernNotificationCard(
                      item: item,
                      blinkAnimation: _blinkController,
                      onTap: () {
                        setState(() {
                          item.isRead = true;
                          item.isNew = false;
                        });
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildDismissBackground(bool isSecondary) {
    return Container(
      alignment: isSecondary ? Alignment.centerRight : Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.redAccent.withValues(alpha: .1),
        borderRadius: BorderRadius.circular(32),
      ),
      child: const Icon(Icons.delete_outline, color: Colors.redAccent),
    );
  }
}

class _ModernNotificationCard extends StatelessWidget {
  const _ModernNotificationCard({
    required this.item,
    required this.blinkAnimation,
    required this.onTap,
  });

  final NotificationItem item;
  final Animation<double> blinkAnimation;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: item.isDark ? const Color(0xFF1E242C) : const Color(0xFFF1F4F9),
            borderRadius: BorderRadius.circular(20),
            boxShadow: item.isDark ? [BoxShadow(color: Colors.black.withValues(alpha: .2), blurRadius: 8, offset: const Offset(0, 4))] : null,
            border: item.isNew ? Border.all(color: primary.withValues(alpha: .3), width: 1.2) : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: item.isDark ? Colors.white.withValues(alpha: .08) : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      item.icon,
                      size: 20,
                      color: item.isDark ? Colors.white70 : primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                item.title,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: item.isDark ? Colors.white : ink,
                                  height: 1.2,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            if (!item.isRead) 
                              FadeTransition(
                                opacity: blinkAnimation,
                                child: Container(
                                  width: 6,
                                  height: 6,
                                  margin: const EdgeInsets.only(top: 4),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF10B981),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        if (item.subtitle != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            item.subtitle!,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: item.isDark ? Colors.white54 : muted,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item.timestamp,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: item.isDark ? Colors.white30 : muted,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: navGradient,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 12),
                        const SizedBox(width: 4),
                        Text(
                          item.buttonLabel,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
