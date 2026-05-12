import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:dukaan_zone_flutter/dukaan.dart';

class RoleShell extends StatefulWidget {
  const RoleShell({super.key, required this.role});
  final Role role;

  @override
  State<RoleShell> createState() => _RoleShellState();
}

class _RoleShellState extends State<RoleShell> {
  int selected = 0;
  late List<GlobalKey<NavigatorState>> _navKeys;
  late List<_FabObserver> _fabObservers;
  DateTime? _lastPressedAt;
  bool _showFab = true;

  @override
  void initState() {
    super.initState();
    globalMapState.addListener(_onMapStateChanged);
    final count = destinations(widget.role).length;
    _navKeys = List.generate(count, (_) => GlobalKey<NavigatorState>());
    _fabObservers = List.generate(count, (_) => _FabObserver(onDepthChanged: (_) {}));
  }

  @override
  void dispose() {
    globalMapState.removeListener(_onMapStateChanged);
    super.dispose();
  }

  void _onMapStateChanged() {
    if (globalMapState.value.mode == MapMode.routing && widget.role == Role.user) {
      if (selected != 1) setState(() => selected = 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = destinations(widget.role);
    final wide = MediaQuery.sizeOf(context).width >= 900;

    if (widget.role == Role.admin && wide) {
      return Scaffold(
        appBar: MainHeader(role: widget.role, onExit: () => Navigator.pop(context)),
        body: Row(
          children: [
            AdminRail(selected: selected, onSelect: (i) => setState(() => selected = i), items: items),
            Expanded(child: items[selected].page()),
          ],
        ),
      );
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        final currentNav = _navKeys[selected].currentState;
        if (currentNav != null && currentNav.canPop()) {
          currentNav.pop();
          return;
        }
        if (selected != 0) {
          setState(() => selected = 0);
          return;
        }

        final now = DateTime.now();
        if (_lastPressedAt == null || now.difference(_lastPressedAt!) > const Duration(seconds: 2)) {
          _lastPressedAt = now;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Press back again to exit'),
              duration: Duration(seconds: 2),
            ),
          );
          return;
        }

        SystemNavigator.pop();
      },
      child: Scaffold(
        appBar: MainHeader(
          role: widget.role,
          onExit: () => Navigator.pop(context),
        ),
        body: RepaintBoundary(
          child: IndexedStack(
            index: selected,
            children: items.asMap().entries.map((entry) {
            return _KeepAliveTab(
              child: Navigator(
                key: _navKeys[entry.key],
                observers: [_fabObservers[entry.key]],
                onGenerateRoute: (settings) => PageRouteBuilder(
                  pageBuilder: (_, __, ___) => entry.value.page(),
                  transitionDuration: const Duration(milliseconds: 220),
                  reverseTransitionDuration: const Duration(milliseconds: 180),
                  transitionsBuilder: (_, animation, __, child) {
                    return FadeTransition(
                      opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
                      child: child,
                    );
                  },
                ),
              ),
            );
          }).toList(),
        ),
      ),
        floatingActionButton: widget.role == Role.user
            ? AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                reverseDuration: const Duration(milliseconds: 200),
                switchInCurve: Curves.easeOutBack,
                switchOutCurve: Curves.easeIn,
                transitionBuilder: (child, animation) => ScaleTransition(
                  scale: animation,
                  child: FadeTransition(opacity: animation, child: child),
                ),
                child: MediaQuery.of(context).viewInsets.bottom == 0
                    ? GestureDetector(
                        key: const ValueKey('fab_visible'),
                        onTap: () => _navKeys[selected].currentState?.push(
                          PageRouteBuilder(
                            pageBuilder: (_, __, ___) => const ShopPaymentPage(),
                            transitionDuration: const Duration(milliseconds: 250),
                            reverseTransitionDuration: const Duration(milliseconds: 200),
                            transitionsBuilder: (_, animation, __, child) => FadeTransition(
                              opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
                              child: child,
                            ),
                          ),
                        ),
                        onLongPress: () {
                          Feedback.forLongPress(context);
                          setState(() {
                            if (selected == 2) _navKeys[2].currentState?.popUntil((r) => r.isFirst);
                            selected = 2;
                          });
                        },
                        child: Container(
                          width: 68,
                          height: 68,
                          decoration: const BoxDecoration(
                            color: primary,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0, 4)),
                              BoxShadow(color: primary, blurRadius: 15, spreadRadius: -5),
                            ],
                          ),
                          child: const Icon(Icons.qr_code_scanner, size: 30, color: Colors.white),
                        ),
                      )
                    : const SizedBox.shrink(key: ValueKey('fab_hidden')),
              )
            : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: (widget.role == Role.seller || widget.role == Role.admin)
          ? _buildScrollableBottomNav(items)
          : NavigationBar(
              selectedIndex: selected,
              height: 72,
              onDestinationSelected: (i) => setState(() {
                if (selected == i) {
                  _navKeys[i].currentState?.popUntil((r) => r.isFirst);
                }
                selected = i;
              }),
              destinations: [
                for (int i = 0; i < items.length; i++) 
                  NavigationDestination(
                    icon: (widget.role == Role.user && i == 2)
                        ? Icon(items[i].icon, color: Colors.transparent)
                        : Icon(items[i].icon),
                    label: items[i].label,
                  ),
              ],
            ),
      ),
    );
  }

  Widget _buildScrollableBottomNav(List<NavItem> items) {
    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -2))],
      ),
      child: SafeArea(
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemCount: items.length,
          itemBuilder: (context, i) {
            final isSelected = selected == i;
            // Width calculated to show roughly 4.5 items at a time
            final width = MediaQuery.sizeOf(context).width / 4.5;
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => setState(() {
                if (selected == i) {
                  _navKeys[i].currentState?.popUntil((r) => r.isFirst);
                }
                selected = i;
              }),
              child: SizedBox(
                width: width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(items[i].icon, color: isSelected ? primary : muted, size: 24),
                    const SizedBox(height: 4),
                    Text(
                      items[i].label,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
                        color: isSelected ? primary : muted,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _FabObserver extends NavigatorObserver {
  _FabObserver({required this.onDepthChanged});
  final ValueChanged<bool> onDepthChanged;

  @override
  void didPush(Route route, Route? previousRoute) {
    if (previousRoute != null) onDepthChanged(true);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    if (navigator?.canPop() == false) onDepthChanged(false);
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    if (navigator?.canPop() == false) onDepthChanged(false);
  }
}

class _KeepAliveTab extends StatefulWidget {
  const _KeepAliveTab({required this.child});
  final Widget child;

  @override
  State<_KeepAliveTab> createState() => _KeepAliveTabState();
}

class _KeepAliveTabState extends State<_KeepAliveTab> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}

class NavItem {
  const NavItem(this.label, this.icon, this.page);
  final String label;
  final IconData icon;
  final Widget Function() page;
}

List<NavItem> destinations(Role role) => switch (role) {
      Role.user => [
          const NavItem('Home', Icons.home_outlined, UserHomePage.new),
          const NavItem('Map', Icons.map_outlined, UserMapPage.new),
          const NavItem('Scan', Icons.qr_code_scanner, UserScanPage.new),
          const NavItem('Saved', Icons.favorite_border, UserSavedPage.new),
          const NavItem('History', Icons.history_rounded, UserHistoryPage.new),
        ],
      Role.seller => [
          const NavItem('Dash', Icons.dashboard_outlined, SellerDashboardPage.new),
          const NavItem('Orders', Icons.receipt_long_outlined, SellerOrdersPage.new),
          const NavItem('Revenue', Icons.bar_chart_rounded, SellerRevenuePage.new),
          const NavItem('Feedback', Icons.forum_outlined, SellerFeedbackPage.new),
        ],
      Role.admin => [
          const NavItem('Overview', Icons.admin_panel_settings_outlined, AdminDashboardPage.new),
          const NavItem('Shops', Icons.store_outlined, AdminShopsPage.new),
          const NavItem('Users', Icons.people_alt_outlined, AdminUsersPage.new),
          const NavItem('Products', Icons.inventory_2_outlined, AdminProductsPage.new),
          const NavItem('Financials', Icons.account_balance_wallet_outlined, AdminFinancialsPage.new),
          const NavItem('Signals', Icons.notifications_active_outlined, AdminSignalsPage.new),
          const NavItem('Promos', Icons.campaign_outlined, AdminPromotionsPage.new),
          const NavItem('Disputes', Icons.gavel_outlined, AdminDisputesPage.new),
        ],
    };


