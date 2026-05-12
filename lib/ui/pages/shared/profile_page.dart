import 'package:flutter/material.dart';
import 'package:dukaan_zone_flutter/dukaan.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key, required this.role});
  final Role role;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        title: const Text('My Settings', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24, letterSpacing: -0.5)),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _UserHeader(),
            const SizedBox(height: 32),
            
            const Kicker('MY WALLET & ORDERS'),
            const SizedBox(height: 12),
            const _WalletSection(),
            const SizedBox(height: 32),

            const Kicker('MY NEIGHBORHOODS'),
            const SizedBox(height: 12),
            const _NeighborhoodSection(),
            const SizedBox(height: 32),

            const Kicker('SMART ALERTS'),
            const SizedBox(height: 12),
            const _AlertsSection(),
            const SizedBox(height: 32),

            const Kicker('PRIVACY & PREFERENCES'),
            const SizedBox(height: 12),
            const _PreferencesSection(),
            const SizedBox(height: 32),

            const Kicker('SUPPORT & ACCOUNT'),
            const SizedBox(height: 12),
            const _SupportSection(),
            const SizedBox(height: 48),

            // Sign Out Button
            Center(
              child: TextButton.icon(
                onPressed: () {
                  authService.logout();
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const EntryPage()), (r) => false);
                },
                icon: const Icon(Icons.logout, color: Colors.redAccent),
                label: const Text('Sign Out', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w800, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}

class _UserHeader extends StatelessWidget {
  const _UserHeader();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<UserModel?>(
      valueListenable: authService.currentUser,
      builder: (context, user, _) {
        return Row(
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primary.withOpacity(0.1),
                border: Border.all(color: primary.withOpacity(0.2), width: 2),
              ),
              child: ClipOval(
                child: Image.network(
                  user?.profilePic ?? 'https://api.dicebear.com/7.x/avataaars/png?seed=${user?.name ?? 'Aryan'}',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.person, size: 40, color: primary),
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user?.name ?? 'Anonymous User', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 4),
                  Text(user?.mobile ?? 'No Mobile Number', style: const TextStyle(color: muted, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            IconButton(
              onPressed: () => push(context, const AccountManagementPage()),
              icon: const Icon(Icons.edit_outlined, color: primary),
              style: IconButton.styleFrom(backgroundColor: primary.withOpacity(0.1)),
            )
          ],
        );
      },
    );
  }
}

class _WalletSection extends StatelessWidget {
  const _WalletSection();

  @override
  Widget build(BuildContext context) {
    return _SettingsCard(
      children: [
        _SettingsTile(
          icon: Icons.qr_code_scanner,
          title: 'Active Handshakes',
          subtitle: '2 QR tokens ready for pickup',
          onTap: () => push(context, const ActiveHandshakesPage()),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(12)),
            child: const Text('2', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 12)),
          ),
        ),
        ValueListenableBuilder<SavingsData>(
          valueListenable: savingsService.data,
          builder: (context, data, _) {
            return _SettingsTile(
              icon: Icons.savings_outlined,
              title: 'Total Savings',
              subtitle: 'Saved ₹${data.totalSaved.toStringAsFixed(0)} buying local this month',
              onTap: () => push(context, SavingsDashboardPage()),
              iconColor: success,
            );
          },
        ),
        _SettingsTile(
          icon: Icons.history,
          title: 'Purchase History',
          subtitle: 'View past orders and receipts',
          onTap: () => push(context, const PurchaseHistoryPage()),
          isLast: true,
        ),
      ],
    );
  }
}

class _NeighborhoodSection extends StatelessWidget {
  const _NeighborhoodSection();

  void _showEditHubDialog(BuildContext context, {LocationHub? hub}) {
    final isNew = hub == null;
    final nameCtrl = TextEditingController(text: hub?.name ?? '');
    final addressCtrl = TextEditingController(text: hub?.address ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).cardTheme.color,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 24, right: 24, top: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(isNew ? 'Add Neighborhood' : 'Edit Neighborhood', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
            const SizedBox(height: 24),
            TextField(controller: nameCtrl, decoration: InputDecoration(labelText: 'Hub Name (e.g., Home Hub)', border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)))),
            const SizedBox(height: 16),
            TextField(controller: addressCtrl, decoration: InputDecoration(labelText: 'Address', border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)))),
            const SizedBox(height: 24),
            Row(
              children: [
                if (!isNew)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        locationController.deleteHub(hub.id);
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(foregroundColor: Colors.redAccent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      child: const Text('Delete'),
                    ),
                  ),
                if (!isNew) const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () {
                      if (nameCtrl.text.isEmpty || addressCtrl.text.isEmpty) return;
                      if (isNew) {
                        locationController.addHub(nameCtrl.text, addressCtrl.text);
                      } else {
                        locationController.updateHub(hub.id, nameCtrl.text, addressCtrl.text);
                      }
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: primary, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    child: const Text('Save Location'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<LocationHub>>(
      valueListenable: locationController.hubsNotifier,
      builder: (context, hubs, _) {
        return _SettingsCard(
          children: [
            for (int i = 0; i < hubs.length; i++)
              ValueListenableBuilder<LocationHub>(
                valueListenable: locationController.activeHub,
                builder: (context, activeHub, _) {
                  final hub = hubs[i];
                  final isSelected = activeHub.id == hub.id;
                  return _SettingsTile(
                    icon: isSelected ? Icons.location_on : Icons.location_on_outlined,
                    iconColor: isSelected ? primary : muted,
                    title: hub.name,
                    subtitle: hub.address,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isSelected) const Icon(Icons.check_circle, color: primary),
                        const SizedBox(width: 8),
                        IconButton(icon: const Icon(Icons.edit_outlined, size: 20, color: muted), onPressed: () => _showEditHubDialog(context, hub: hub)),
                      ],
                    ),
                    onTap: () => locationController.switchHub(hub.id),
                  );
                },
              ),
            _SettingsTile(
              icon: Icons.add_location_alt_outlined,
              title: 'Add New Neighborhood',
              iconColor: primary,
              isLast: true,
              onTap: () => _showEditHubDialog(context),
            ),
          ],
        );
      },
    );
  }
}


class _AlertsSection extends StatelessWidget {
  const _AlertsSection();

  @override
  Widget build(BuildContext context) {
    return _SettingsCard(
      children: [
        _SettingsTile(
          icon: Icons.inventory_2_outlined,
          title: 'Restock Alerts',
          subtitle: 'Get notified when followed shops restock',
          trailing: Switch.adaptive(value: true, onChanged: (v) {}, activeColor: primary),
        ),
        _SettingsTile(
          icon: Icons.sell_outlined,
          title: 'Price Drop Pings',
          subtitle: 'Alerts for discounts in your neighborhood',
          trailing: Switch.adaptive(value: true, onChanged: (v) {}, activeColor: primary),
          isLast: true,
        ),
      ],
    );
  }
}

class _PreferencesSection extends StatelessWidget {
  const _PreferencesSection();

  @override
  Widget build(BuildContext context) {
    return _SettingsCard(
      children: [
        _SettingsTile(
          icon: Icons.visibility_off_outlined,
          title: 'Hide Followed Shops',
          subtitle: 'Neighbors won\'t see shops you follow',
          trailing: Switch.adaptive(value: false, onChanged: (v) {}, activeColor: primary),
        ),
        _SettingsTile(
          icon: Icons.dark_mode_outlined,
          title: 'Dark Mode',
          subtitle: 'Switch to the midnight theme',
          trailing: ValueListenableBuilder<ThemeMode>(
            valueListenable: themeController.themeMode,
            builder: (context, mode, _) {
              return Switch.adaptive(
                value: mode == ThemeMode.dark,
                onChanged: (v) => themeController.toggleTheme(),
                activeColor: primary,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _SupportSection extends StatelessWidget {
  const _SupportSection();

  @override
  Widget build(BuildContext context) {
    return _SettingsCard(
      children: [
        _SettingsTile(
          icon: Icons.help_outline,
          title: 'Help Center & FAQs',
          onTap: () => push(context, const HelpCenterPage()),
        ),
        _SettingsTile(
          icon: Icons.report_problem_outlined,
          title: 'Report an Issue',
          subtitle: 'Handshake problems or bad merchants',
          onTap: () => push(context, ReportIssuePage()),
        ),
        _SettingsTile(
          icon: Icons.description_outlined,
          title: 'Terms & Privacy Policy',
          onTap: () => push(context, TermsPrivacyPage()),
          isLast: true,
        ),
      ],
    );
  }
}

// ─── UTILITY WIDGETS ──────────────────────────────────────────

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(24),
        boxShadow: shadowSm,
      ),
      child: Column(children: children),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.trailing,
    this.iconColor,
    this.isLast = false,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;
  final Color? iconColor;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Icon(icon, color: iconColor ?? primary, size: 24),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(subtitle!, style: const TextStyle(color: muted, fontSize: 12, fontWeight: FontWeight.w600)),
                      ],
                    ],
                  ),
                ),
                if (trailing != null) trailing! else if (onTap != null) const Icon(Icons.chevron_right, color: muted),
              ],
            ),
          ),
          if (!isLast) Divider(height: 1, color: muted.withOpacity(0.1), indent: 60, endIndent: 20),
        ],
      ),
    );
  }
}
