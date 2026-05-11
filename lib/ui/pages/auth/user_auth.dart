import 'package:flutter/material.dart';
import 'package:dukaan_zone_flutter/dukaan.dart';

enum UserAuthStep { login, register, otp, personalize }

class UserAuthPage extends StatefulWidget {
  const UserAuthPage({super.key, this.isRegister = false});
  final bool isRegister;

  @override
  State<UserAuthPage> createState() => _UserAuthPageState();
}

class _UserAuthPageState extends State<UserAuthPage> {
  late UserAuthStep _currentStep;
  
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  
  bool _loading = false;
  String? _profilePic;

  @override
  void initState() {
    super.initState();
    _currentStep = widget.isRegister ? UserAuthStep.register : UserAuthStep.login;
  }

  Future<void> _handleAction() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() {
      _loading = false;
      _currentStep = UserAuthStep.otp;
    });
  }

  Future<void> _verifyOtp(String code) async {
    setState(() => _loading = true);
    final success = await authService.verifyOtp(code);
    if (!mounted) return;
    setState(() => _loading = false);

    if (success) {
      if (widget.isRegister || _currentStep == UserAuthStep.register) {
        setState(() => _currentStep = UserAuthStep.personalize);
      } else {
        _complete();
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid OTP. Use 1234')));
    }
  }

  void _complete() {
    authService.login(_emailController.text, _passwordController.text, role: Role.user);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const RoleShell(role: Role.user)),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
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
      case UserAuthStep.login: return _buildLogin();
      case UserAuthStep.register: return _buildRegister();
      case UserAuthStep.otp: return _buildOtp();
      case UserAuthStep.personalize: return _buildPersonalize();
    }
  }

  Widget _buildLogin() {
    return Column(
      key: const ValueKey('login'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Brand(size: 64),
        const SizedBox(height: 32),
        const Text('Welcome Back', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: ink)),
        const SizedBox(height: 8),
        const Text('Sign in to your neighborhood world.', style: TextStyle(color: muted, fontWeight: FontWeight.w600)),
        const SizedBox(height: 32),
        TextField(
          controller: _emailController,
          decoration: InputDecoration(labelText: 'Email Address', prefixIcon: const Icon(Icons.email_outlined), border: OutlineInputBorder(borderRadius: BorderRadius.circular(16))),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _passwordController,
          obscureText: true,
          decoration: InputDecoration(labelText: 'Password', prefixIcon: const Icon(Icons.lock_outline), border: OutlineInputBorder(borderRadius: BorderRadius.circular(16))),
        ),
        const SizedBox(height: 12),
        Align(alignment: Alignment.centerRight, child: TextButton(onPressed: () {}, child: const Text('Forgot Password?', style: TextStyle(color: primary, fontWeight: FontWeight.w800)))),
        const SizedBox(height: 32),
        _loading ? const Center(child: CircularProgressIndicator()) : GradientButton('Login', Icons.login, _handleAction),
        const SizedBox(height: 24),
        SocialButton(label: 'Continue with Google', icon: Icons.g_mobiledata, onTap: () {}),
        const SizedBox(height: 24),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text('New here?', style: TextStyle(color: muted, fontWeight: FontWeight.w600)),
          TextButton(onPressed: () => setState(() => _currentStep = UserAuthStep.register), child: const Text('Create Account', style: TextStyle(color: primary, fontWeight: FontWeight.w900))),
        ]),
      ],
    );
  }

  Widget _buildRegister() {
    return Column(
      key: const ValueKey('register'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Brand(size: 64),
        const SizedBox(height: 32),
        const Text('Join DukaanZone', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: ink)),
        const SizedBox(height: 8),
        const Text('Create your global user account.', style: TextStyle(color: muted, fontWeight: FontWeight.w600)),
        const SizedBox(height: 32),
        TextField(
          controller: _nameController,
          decoration: InputDecoration(labelText: 'Full Name', prefixIcon: const Icon(Icons.person_outline), border: OutlineInputBorder(borderRadius: BorderRadius.circular(16))),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _emailController,
          decoration: InputDecoration(labelText: 'Email Address', prefixIcon: const Icon(Icons.email_outlined), border: OutlineInputBorder(borderRadius: BorderRadius.circular(16))),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _mobileController,
          decoration: InputDecoration(labelText: 'Mobile Number', prefixIcon: const Icon(Icons.phone_outlined), prefixText: '+91 ', border: OutlineInputBorder(borderRadius: BorderRadius.circular(16))),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _passwordController,
          obscureText: true,
          decoration: InputDecoration(labelText: 'Password', prefixIcon: const Icon(Icons.lock_outline), border: OutlineInputBorder(borderRadius: BorderRadius.circular(16))),
        ),
        const SizedBox(height: 32),
        _loading ? const Center(child: CircularProgressIndicator()) : GradientButton('Get Started', Icons.arrow_forward, _handleAction),
        const SizedBox(height: 24),
        SocialButton(label: 'Sign up with Google', icon: Icons.g_mobiledata, onTap: () {}),
      ],
    );
  }

  Widget _buildOtp() {
    return Column(
      key: const ValueKey('otp'),
      children: [
        const Icon(Icons.mark_email_read_outlined, size: 84, color: primary),
        const SizedBox(height: 24),
        const Text('Verify Account', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: ink)),
        const SizedBox(height: 12),
        const Text('Enter the 4-digit code sent to you.\nUse 1234 for this demo.', textAlign: TextAlign.center, style: TextStyle(color: muted, fontWeight: FontWeight.w600, height: 1.4)),
        const SizedBox(height: 48),
        OtpInput(onCompleted: _verifyOtp),
      ],
    );
  }

  Widget _buildPersonalize() {
    return Column(
      key: const ValueKey('personalize'),
      children: [
        const Text('Welcome!', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: ink)),
        const SizedBox(height: 8),
        const Text('Let\'s add a profile picture.', style: TextStyle(color: muted, fontWeight: FontWeight.w600)),
        const SizedBox(height: 48),
        ProfilePicPicker(imageUrl: _profilePic, onTap: () => setState(() => _profilePic = 'https://i.pravatar.cc/150?u=aryan')),
        const SizedBox(height: 48),
        GradientButton('Finish Setup', Icons.check, _complete),
        const SizedBox(height: 14),
        TextButton(onPressed: _complete, child: const Text('Skip for now', style: TextStyle(color: muted, fontWeight: FontWeight.w800))),
      ],
    );
  }
}
