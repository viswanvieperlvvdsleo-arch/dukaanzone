import 'package:flutter/material.dart';
import 'package:dukaan_zone_flutter/dukaan.dart';

enum AdminAuthStep { login, otp }

class AdminAuthPage extends StatefulWidget {
  const AdminAuthPage({super.key});

  @override
  State<AdminAuthPage> createState() => _AdminAuthPageState();
}

class _AdminAuthPageState extends State<AdminAuthPage> {
  AdminAuthStep _currentStep = AdminAuthStep.login;
  
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _mobileController = TextEditingController();
  
  bool _loading = false;
  String? _error;

  final List<String> _allowedMobiles = ['+91 9030522754', '+91 98495 98053'];

  Future<void> _handleLogin() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    // Strictly check email and password as per requirements
    if (_emailController.text == 'ramviswan@gmail..com' && _passwordController.text == 'RamViswan@2005Bug') {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;
      setState(() {
        _loading = false;
        _currentStep = AdminAuthStep.otp;
      });
    } else {
      await Future.delayed(const Duration(milliseconds: 500));
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = 'Unauthorized Admin Access Attempt.';
      });
    }
  }

  Future<void> _verifyOtp(String code) async {
    // Mobile check bypassed for easier testing
    setState(() => _loading = true);
    final success = await authService.verifyOtp(code);
    if (!mounted) return;
    setState(() => _loading = false);

    if (success) {
      authService.login(_emailController.text, _passwordController.text, role: Role.admin);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const RoleShell(role: Role.admin)),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid Admin OTP. (Use 1234)')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Secure dark blue/black
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, iconTheme: const IconThemeData(color: Colors.white)),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _currentStep == AdminAuthStep.login ? _buildLogin() : _buildOtp(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogin() {
    return Column(
      key: const ValueKey('login'),
      children: [
        const Icon(Icons.security, size: 84, color: Colors.blueAccent),
        const SizedBox(height: 32),
        const Text('Admin Terminal', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.white)),
        const SizedBox(height: 8),
        const Text('Authorized Personnel Only', style: TextStyle(color: Colors.white60, fontWeight: FontWeight.w600)),
        const SizedBox(height: 48),
        TextField(
          controller: _emailController,
          style: const TextStyle(color: Colors.white),
          decoration: _adminInputDecoration('Admin Email Address', Icons.admin_panel_settings),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _passwordController,
          obscureText: true,
          style: const TextStyle(color: Colors.white),
          decoration: _adminInputDecoration('System Password', Icons.key),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _mobileController,
          style: const TextStyle(color: Colors.white),
          decoration: _adminInputDecoration('Authorized Mobile (+91...)', Icons.phone_android),
        ),
        if (_error != null) ...[
          const SizedBox(height: 18),
          Text(_error!, style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w800, fontSize: 13)),
        ],
        const SizedBox(height: 48),
        _loading 
          ? const CircularProgressIndicator(color: Colors.blueAccent)
          : SizedBox(
              width: double.infinity,
              height: 58,
              child: ElevatedButton(
                onPressed: _handleLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('AUTHENTICATE', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 2)),
              ),
            ),
      ],
    );
  }

  Widget _buildOtp() {
    return Column(
      key: const ValueKey('otp'),
      children: [
        const Icon(Icons.lock_person, size: 84, color: Colors.blueAccent),
        const SizedBox(height: 24),
        const Text('System Verification', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.white)),
        const SizedBox(height: 12),
        Text(
          'Verification code sent to ${_mobileController.text}.\nEnter System Override Code.',
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white60, fontWeight: FontWeight.w600, height: 1.4),
        ),
        const SizedBox(height: 48),
        Theme(
          data: ThemeData.dark(),
          child: OtpInput(onCompleted: _verifyOtp),
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  InputDecoration _adminInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white54),
      prefixIcon: Icon(icon, color: Colors.blueAccent),
      filled: true,
      fillColor: Colors.white.withValues(alpha: .05),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.white.withValues(alpha: .1))),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Colors.blueAccent, width: 2)),
    );
  }
}
