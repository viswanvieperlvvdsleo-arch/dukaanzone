import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:dukaan_zone_flutter/dukaan.dart';

// --- Services ---

abstract class PaymentService {
  Future<bool> processPayment({required double amount, required String orderId});
}

class MockPaymentService implements PaymentService {
  @override
  Future<bool> processPayment({required double amount, required String orderId}) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network
    return true; // Always succeed for now
  }
}

abstract class ReviewService {
  Future<List<String>> getReviews(String productId);
  Future<String> getCommunityPulse(String productId);
  Future<void> addReview(String productId, String review);
}

class MockReviewService implements ReviewService {
  final Map<String, List<String>> _reviews = {};

  @override
  Future<List<String>> getReviews(String productId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (!_reviews.containsKey(productId)) {
      _reviews[productId] = [
        'Excellent quality, very fresh!',
        'Fast delivery and great packaging.',
        'Will definitely buy again.'
      ];
    }
    return _reviews[productId]!;
  }

  @override
  Future<void> addReview(String productId, String review) async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (!_reviews.containsKey(productId)) {
      _reviews[productId] = [];
    }
    _reviews[productId]!.insert(0, review); // Add to the top
  }

@override
  Future<String> getCommunityPulse(String productId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return 'Community pulse is highly positive. 95% of buyers recommend this product for its quality and fast delivery.';
  }
}

// Global service locators (for simplicity without extra packages)
final PaymentService paymentService = MockPaymentService();

final ReviewService reviewService = MockReviewService();

abstract class AuthService {
  ValueNotifier<bool> get isLoggedIn;
  ValueNotifier<Role?> get currentRole;
  Future<bool> login(String email, String password, {Role role = Role.user});
  Future<bool> register({required String name, required String email, required String mobile, required String password, bool isSeller = false});
  Future<bool> verifyOtp(String code);
  Future<void> logout();
}

class MockAuthService implements AuthService {
  final _isLoggedIn = ValueNotifier<bool>(false);
  final _currentRole = ValueNotifier<Role?>(null);
  
  @override
  ValueNotifier<bool> get isLoggedIn => _isLoggedIn;
  @override
  ValueNotifier<Role?> get currentRole => _currentRole;

  @override
  Future<bool> login(String email, String password, {Role role = Role.user}) async {
    await Future.delayed(const Duration(seconds: 1));
    
    // Strict Admin Logic
    if (role == Role.admin) {
      if (email == 'ramviswan@gmail..com' && password == 'RamViswan@2005Bug') {
        _isLoggedIn.value = true;
        _currentRole.value = Role.admin;
        return true;
      }
      return false;
    }

    _isLoggedIn.value = true;
    _currentRole.value = role;
    return true;
  }

  @override
  Future<bool> register({required String name, required String email, required String mobile, required String password, bool isSeller = false}) async {
    await Future.delayed(const Duration(seconds: 1));
    _isLoggedIn.value = true;
    _currentRole.value = isSeller ? Role.seller : Role.user;
    return true;
  }

  @override
  Future<bool> verifyOtp(String code) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return true; // Accept any OTP for testing
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _isLoggedIn.value = false;
    _currentRole.value = null;
  }
}

final AuthService authService = MockAuthService();

// Elite Neighbor Engine Controllers
class ThemeController {
  static final ThemeController instance = ThemeController._();
  ThemeController._();
  
  final ValueNotifier<ThemeMode> themeMode = ValueNotifier(ThemeMode.light);
  
  void toggleTheme() {
    themeMode.value = themeMode.value == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }
}

class LocationHub {
  final String id;
  final String name;
  final String address;
  LocationHub(this.id, this.name, this.address);
}

class LocationController {
  static final LocationController instance = LocationController._();
  LocationController._();
  
  final ValueNotifier<List<LocationHub>> hubsNotifier = ValueNotifier([
    LocationHub('home', 'Home Hub', 'Silver Towers, Block A'),
    LocationHub('work', 'Work Hub', 'Cyber Plaza, 5th Floor'),
    LocationHub('parents', 'Parents\' Apt', 'Green Valley, Sector 12'),
  ]);
  
  late final ValueNotifier<LocationHub> activeHub = ValueNotifier(hubsNotifier.value[0]);
  
  void switchHub(String id) {
    activeHub.value = hubsNotifier.value.firstWhere((h) => h.id == id);
  }

  void addHub(String name, String address) {
    final newHub = LocationHub(DateTime.now().millisecondsSinceEpoch.toString(), name, address);
    hubsNotifier.value = [...hubsNotifier.value, newHub];
  }

  void updateHub(String id, String name, String address) {
    hubsNotifier.value = hubsNotifier.value.map((h) => h.id == id ? LocationHub(id, name, address) : h).toList();
    if (activeHub.value.id == id) {
      activeHub.value = LocationHub(id, name, address);
    }
  }

  void deleteHub(String id) {
    if (hubsNotifier.value.length <= 1) return; // Prevent deleting the last hub
    hubsNotifier.value = hubsNotifier.value.where((h) => h.id != id).toList();
    if (activeHub.value.id == id) {
      activeHub.value = hubsNotifier.value.first;
    }
  }
}

final themeController = ThemeController.instance;
final locationController = LocationController.instance;

