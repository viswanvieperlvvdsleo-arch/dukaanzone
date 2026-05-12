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

class UserModel {
  final String id;
  final String name;
  final String email;
  final String mobile;
  final String? profilePic;
  final Role role;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.mobile,
    this.profilePic,
    required this.role,
  });

  UserModel copyWith({String? name, String? profilePic}) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      email: email,
      mobile: mobile,
      profilePic: profilePic ?? this.profilePic,
      role: role,
    );
  }
}

abstract class AuthService {
  ValueNotifier<bool> get isLoggedIn;
  ValueNotifier<Role?> get currentRole;
  ValueNotifier<UserModel?> get currentUser;
  Future<bool> login(String email, String password, {Role role = Role.user});
  Future<bool> register({required String name, required String email, required String mobile, required String password, bool isSeller = false});
  Future<bool> verifyOtp(String code);
  Future<void> updateProfile({String? name, String? profilePic});
  Future<void> logout();
}

class MockAuthService implements AuthService {
  final _isLoggedIn = ValueNotifier<bool>(false);
  final _currentRole = ValueNotifier<Role?>(null);
  final _currentUser = ValueNotifier<UserModel?>(null);
  
  @override
  ValueNotifier<bool> get isLoggedIn => _isLoggedIn;
  @override
  ValueNotifier<Role?> get currentRole => _currentRole;
  @override
  ValueNotifier<UserModel?> get currentUser => _currentUser;

  @override
  Future<bool> login(String email, String password, {Role role = Role.user}) async {
    await Future.delayed(const Duration(seconds: 1));
    
    // Strict Admin Logic
    if (role == Role.admin) {
      if (email == 'ramviswan@gmail..com' && password == 'RamViswan@2005Bug') {
        _isLoggedIn.value = true;
        _currentRole.value = Role.admin;
        _currentUser.value = UserModel(id: 'admin_1', name: 'Ram Viswan', email: email, mobile: '9999999999', role: Role.admin);
        return true;
      }
      return false;
    }

    _isLoggedIn.value = true;
    _currentRole.value = role;
    _currentUser.value = UserModel(
      id: 'user_123', 
      name: email.split('@')[0].toUpperCase(), 
      email: email, 
      mobile: '9030522754', 
      role: role
    );
    return true;
  }

  @override
  Future<bool> register({required String name, required String email, required String mobile, required String password, bool isSeller = false}) async {
    await Future.delayed(const Duration(seconds: 1));
    final role = isSeller ? Role.seller : Role.user;
    _isLoggedIn.value = true;
    _currentRole.value = role;
    _currentUser.value = UserModel(id: 'user_${DateTime.now().millisecondsSinceEpoch}', name: name, email: email, mobile: mobile, role: role);
    return true;
  }

  @override
  Future<bool> verifyOtp(String code) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return true; // Accept any OTP for testing
  }

  @override
  Future<void> updateProfile({String? name, String? profilePic}) async {
    if (_currentUser.value != null) {
      _currentUser.value = _currentUser.value!.copyWith(name: name, profilePic: profilePic);
    }
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _isLoggedIn.value = false;
    _currentRole.value = null;
    _currentUser.value = null;
  }
}

// ─── LOCALIZATION SERVICE ─────────────────────────────────────

class AppLanguage {
  final String name;
  final String nativeName;
  final String code;
  final String flag;

  AppLanguage({required this.name, required this.nativeName, required this.code, required this.flag});
}

final List<AppLanguage> supportedLanguages = [
  AppLanguage(name: 'English', nativeName: 'English', code: 'en', flag: '🇺🇸'),
  AppLanguage(name: 'Hindi', nativeName: 'हिन्दी', code: 'hi', flag: '🇮🇳'),
  AppLanguage(name: 'Telugu', nativeName: 'తెలుగు', code: 'te', flag: '🇮🇳'),
  AppLanguage(name: 'Tamil', nativeName: 'தமிழ்', code: 'ta', flag: '🇮🇳'),
  AppLanguage(name: 'Bengali', nativeName: 'বাংলা', code: 'bn', flag: '🇮🇳'),
  AppLanguage(name: 'Spanish', nativeName: 'Español', code: 'es', flag: '🇪🇸'),
];

class LocalizationService {
  final currentLanguage = ValueNotifier<AppLanguage>(supportedLanguages[0]);

  void setLanguage(AppLanguage lang) {
    currentLanguage.value = lang;
  }

  String translate(String key) {
    final code = currentLanguage.value.code;
    final map = _translations[key];
    if (map == null) return key;
    return map[code] ?? map['en'] ?? key;
  }

  final Map<String, Map<String, String>> _translations = {
    'Home': {'en': 'Home', 'hi': 'होम', 'te': 'హోమ్'},
    'Settings': {'en': 'Settings', 'hi': 'सेटिंग्स', 'te': 'సెట్టింగులు'},
    'My Settings': {'en': 'My Settings', 'hi': 'मेरी सेटिंग्स', 'te': 'నా సెట్టింగులు'},
    'Scanner': {'en': 'Scanner', 'hi': 'स्कैनर', 'te': 'స్కానర్'},
    'Cart': {'en': 'Cart', 'hi': 'कार्ट', 'te': 'కార్ట్'},
    'Map': {'en': 'Map', 'hi': 'मैप', 'te': 'మ్యాప్'},
  };
}

final localizationService = LocalizationService();

// ─── SUPPORT SERVICE ──────────────────────────────────────────

enum IssueStatus { pending, inProgress, resolved }

class SupportIssue {
  final String id;
  final String category;
  final String description;
  final IssueStatus status;
  final DateTime createdAt;

  SupportIssue({required this.id, required this.category, required this.description, required this.status, required this.createdAt});
}

class SupportService {
  final issues = ValueNotifier<List<SupportIssue>>([]);

  void reportIssue(String category, String description) {
    final newIssue = SupportIssue(
      id: 'TKT-${1000 + issues.value.length}',
      category: category,
      description: description,
      status: IssueStatus.pending,
      createdAt: DateTime.now(),
    );
    issues.value = [...issues.value, newIssue];
  }
}

final supportService = SupportService();

// ─── SAVINGS SERVICE ──────────────────────────────────────────

class SavingsData {
  final double totalSaved;
  final int localTrips;
  final double carbonSaved; // in kg

  SavingsData({required this.totalSaved, required this.localTrips, required this.carbonSaved});
}

class SavingsService {
  final data = ValueNotifier<SavingsData>(SavingsData(totalSaved: 450.0, localTrips: 12, carbonSaved: 3.4));

  void addSavings(double amount) {
    data.value = SavingsData(
      totalSaved: data.value.totalSaved + amount,
      localTrips: data.value.localTrips + 1,
      carbonSaved: data.value.carbonSaved + 0.2,
    );
  }
}

final savingsService = SavingsService();

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

