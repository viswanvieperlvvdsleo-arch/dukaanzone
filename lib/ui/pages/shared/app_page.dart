import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:dukaan_zone_flutter/dukaan.dart';

class AppPage extends StatelessWidget {
  const AppPage({super.key, required this.children, this.maxWidth = 980});
  final List<Widget> children;
  final double maxWidth;

@override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: ListView(padding: const EdgeInsets.fromLTRB(18, 22, 18, 34), children: children),
      ),
    );
  }
}

class PageTitle extends StatelessWidget {
  const PageTitle(this.title, this.subtitle, {super.key});
  final String title;
  final String subtitle;
  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 31, fontWeight: FontWeight.w900, color: ink, letterSpacing: -.6)), const SizedBox(height: 5), Text(subtitle, style: const TextStyle(color: muted, fontWeight: FontWeight.w700))]);
}

