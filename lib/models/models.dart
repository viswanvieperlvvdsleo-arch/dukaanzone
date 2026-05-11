import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:dukaan_zone_flutter/dukaan.dart';

enum Role { user, seller, admin }

enum MapMode { standard, routing }

class MapState {
  final MapMode mode;
  final LatLng? destination;
  final String? destinationName;
  MapState({this.mode = MapMode.standard, this.destination, this.destinationName});
}

class Product {
  const Product(this.id, this.name, this.price, this.shop, this.badge, this.stock, this.icon, this.tint);
  final String id;
  final String name;
  final String price;
  final String shop;
  final String badge;
  final String stock;
  final IconData icon;
  final Color tint;
}

class Shop {
  const Shop(this.name, this.block, this.type, this.rating, this.orders);
  final String name;
  final String block;
  final String type;
  final String rating;
  final String orders;
}

class Stat {
  const Stat(this.label, this.value, this.trend, this.icon, this.bg);
  final String label;
  final String value;
  final String trend;
  final IconData icon;
  final Color bg;
}

