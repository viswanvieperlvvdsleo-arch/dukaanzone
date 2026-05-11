import 'package:flutter/material.dart';
import 'package:dukaan_zone_flutter/dukaan.dart';

enum SellerAuthStep { login, register, otp, scan }

class SellerAuthPage extends StatefulWidget {
  const SellerAuthPage({super.key, this.isRegister = false});
  final bool isRegister;

  @override
  State<SellerAuthPage> createState() => _SellerAuthPageState();
}

class _SellerAuthPageState extends State<SellerAuthPage> {
  late SellerAuthStep _currentStep;
  
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  final _addressController = TextEditingController();
  final _webController = TextEditingController();
  
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _currentStep = widget.isRegister ? SellerAuthStep.register : SellerAuthStep.login;
  }

  Future<void> _handleAction() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() {
      _loading = false;
      _currentStep = SellerAuthStep.otp;
    });
  }

  Future<void> _verifyOtp(String code) async {
    setState(() => _loading = true);
    final success = await authService.verifyOtp(code);
    if (!mounted) return;
    setState(() => _loading = false);

    if (success) {
      setState(() => _currentStep = SellerAuthStep.scan);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid OTP. Use 1234')));
    }
  }

  void _complete() {
    authService.login(_emailController.text, _passwordController.text, role: Role.seller);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const RoleShell(role: Role.seller)),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, iconTheme: const IconThemeData(color: ink)),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _buildStep(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStep() {
    switch (_currentStep) {
      case SellerAuthStep.login: return _buildLogin();
      case SellerAuthStep.register: return _buildRegister();
      case SellerAuthStep.otp: return _buildOtp();
      case SellerAuthStep.scan: return _buildScanner();
    }
  }

  Widget _buildLogin() {
    return Column(
      key: const ValueKey('login'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Brand(size: 64),
        const SizedBox(height: 32),
        const Text('Seller Login', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: ink)),
        const SizedBox(height: 8),
        const Text('Manage your digital shelf globally.', style: TextStyle(color: muted, fontWeight: FontWeight.w600)),
        const SizedBox(height: 32),
        TextField(
          controller: _emailController,
          decoration: InputDecoration(labelText: 'Business Email', prefixIcon: const Icon(Icons.business_outlined), border: OutlineInputBorder(borderRadius: BorderRadius.circular(16))),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _passwordController,
          obscureText: true,
          decoration: InputDecoration(labelText: 'Password', prefixIcon: const Icon(Icons.lock_outline), border: OutlineInputBorder(borderRadius: BorderRadius.circular(16))),
        ),
        const SizedBox(height: 32),
        _loading ? const Center(child: CircularProgressIndicator()) : GradientButton('Login to Dashboard', Icons.dashboard_customize, _handleAction),
        const SizedBox(height: 24),
        SocialButton(label: 'Continue with Google', icon: Icons.g_mobiledata, onTap: () {}),
        const SizedBox(height: 24),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text('New shopkeeper?', style: TextStyle(color: muted, fontWeight: FontWeight.w600)),
          TextButton(onPressed: () => setState(() => _currentStep = SellerAuthStep.register), child: const Text('Register Shop', style: TextStyle(color: primary, fontWeight: FontWeight.w900))),
        ]),
      ],
    );
  }

  String _selectedCategory = 'Grocery';
  String _selectedBlock = 'Block A';

  Widget _buildRegister() {
    return Column(
      key: const ValueKey('register'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Brand(size: 64),
        const SizedBox(height: 32),
        const Text('Partner with Us', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: ink)),
        const SizedBox(height: 8),
        const Text('Launch your global digital storefront.', style: TextStyle(color: muted, fontWeight: FontWeight.w600)),
        const SizedBox(height: 32),
        
        // Brand Mark Picker
        Center(
          child: Column(
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(color: primary.withOpacity(0.3), width: 2),
                ),
                child: const Icon(Icons.add_a_photo_outlined, color: primary, size: 32),
              ),
              const SizedBox(height: 8),
              const Text('Upload Brand Mark', style: TextStyle(color: primary, fontWeight: FontWeight.w800, fontSize: 12)),
            ],
          ),
        ),
        const SizedBox(height: 32),

        TextField(
          controller: _nameController,
          decoration: InputDecoration(labelText: 'Shop Name', prefixIcon: const Icon(Icons.store_outlined), border: OutlineInputBorder(borderRadius: BorderRadius.circular(16))),
        ),
        const SizedBox(height: 20),
        
        DropdownButtonFormField<String>(
          value: _selectedCategory,
          decoration: InputDecoration(labelText: 'Category', prefixIcon: const Icon(Icons.category_outlined), border: OutlineInputBorder(borderRadius: BorderRadius.circular(16))),
          items: ['Grocery', 'Electronics', 'Fashion', 'Pharmacy'].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
          onChanged: (v) => setState(() => _selectedCategory = v!),
        ),
        const SizedBox(height: 20),

        DropdownButtonFormField<String>(
          value: _selectedBlock,
          decoration: InputDecoration(labelText: 'Primary Block', prefixIcon: const Icon(Icons.location_city_outlined), border: OutlineInputBorder(borderRadius: BorderRadius.circular(16))),
          items: ['Block A', 'Block B', 'Cyber Plaza', 'Green Valley'].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
          onChanged: (v) => setState(() => _selectedBlock = v!),
        ),
        const SizedBox(height: 20),

        TextField(
          controller: _emailController,
          decoration: InputDecoration(labelText: 'Business Email', prefixIcon: const Icon(Icons.email_outlined), border: OutlineInputBorder(borderRadius: BorderRadius.circular(16))),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _mobileController,
          decoration: InputDecoration(labelText: 'Mobile Number', prefixIcon: const Icon(Icons.phone_outlined), prefixText: '+91 ', border: OutlineInputBorder(borderRadius: BorderRadius.circular(16))),
        ),
        const SizedBox(height: 32),
        _loading ? const Center(child: CircularProgressIndicator()) : GradientButton('Apply for Approval', Icons.handshake_outlined, _handleAction),
      ],
    );
  }

  Widget _buildOtp() {
    return Column(
      key: const ValueKey('otp'),
      children: [
        const Icon(Icons.vibration_outlined, size: 84, color: primary),
        const SizedBox(height: 24),
        const Text('Verify Identity', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: ink)),
        const SizedBox(height: 12),
        const Text('Enter the code sent to your business mobile.\n(Use 1234)', textAlign: TextAlign.center, style: TextStyle(color: muted, fontWeight: FontWeight.w600, height: 1.4)),
        const SizedBox(height: 48),
        OtpInput(onCompleted: _verifyOtp),
      ],
    );
  }

  Widget _buildScanner() {
    return Column(
      key: const ValueKey('scan'),
      children: [
        const Icon(Icons.qr_code_scanner_rounded, size: 84, color: primary),
        const SizedBox(height: 24),
        const Text('Sync Store QR', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: ink)),
        const SizedBox(height: 12),
        const Text('Scan your DukaanZone QR code to link this device to your live shelf.', textAlign: TextAlign.center, style: TextStyle(color: muted, fontWeight: FontWeight.w600, height: 1.4)),
        const SizedBox(height: 48),
        Container(
          height: 240,
          width: double.infinity,
          decoration: BoxDecoration(color: ink, borderRadius: BorderRadius.circular(32)),
          child: const Center(child: Icon(Icons.camera_alt, color: Colors.white12, size: 64)),
        ),
        const SizedBox(height: 48),
        GradientButton('Complete Sync', Icons.sync_rounded, _complete),
      ],
    );
  }
}
