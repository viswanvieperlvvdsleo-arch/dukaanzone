import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    globalMapState.addListener(_onMapStateChanged);
    _navKeys = List.generate(destinations(widget.role).length, (_) => GlobalKey<NavigatorState>());
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

    return WillPopScope(
      onWillPop: () async {
        final currentNav = _navKeys[selected].currentState;
        if (currentNav != null && currentNav.canPop()) {
          currentNav.pop();
          return false;
        }
        if (selected != 0) {
          setState(() => selected = 0);
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: MainHeader(
          role: widget.role,
          onExit: () => Navigator.pop(context),
        ),
        body: IndexedStack(
          index: selected,
          children: items.asMap().entries.map((entry) {
            return Navigator(
              key: _navKeys[entry.key],
              onGenerateRoute: (settings) => MaterialPageRoute(
                builder: (_) => entry.value.page(),
              ),
            );
          }).toList(),
        ),
        floatingActionButton: widget.role == Role.user
            ? GestureDetector(
                onTap: () => _navKeys[selected].currentState?.push(
                  MaterialPageRoute(builder: (_) => const ManualPaymentPage()),
                ),
                onLongPress: () => setState(() {
                  if (selected == 2) _navKeys[2].currentState?.popUntil((r) => r.isFirst);
                  selected = 2;
                }),
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


