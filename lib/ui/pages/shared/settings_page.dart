import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:dukaan_zone_flutter/dukaan.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key, required this.title, required this.subtitle});
  final String title;
  final String subtitle;
  @override
  Widget build(BuildContext context) => AppPage(children: [
        PageTitle(title, subtitle),
        const SizedBox(height: 18),
        const SignalCard(title: 'Profile', body: 'Name, phone, block, and role information.', icon: Icons.person),
        const SignalCard(title: 'Notifications', body: 'Stock, order, and platform alert preferences.', icon: Icons.notifications),
        const SignalCard(title: 'Security', body: 'Password, OTP and admin access rules.', icon: Icons.lock),
      ]);
}

