import 'dart:ui';
import 'package:flutter/material.dart';

/// Glassmorphism Login Screen Example
/// Run this as a standalone Flutter app to preview.
void main() => runApp(const MaterialApp(
  debugShowCheckedModeBanner: false,
  home: GlassmorphismLoginScreen(),
));

class GlassmorphismLoginScreen extends StatefulWidget {
  const GlassmorphismLoginScreen({super.key});

  @override
  State<GlassmorphismLoginScreen> createState() =>
      _GlassmorphismLoginScreenState();
}

class _GlassmorphismLoginScreenState extends State<GlassmorphismLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email   = TextEditingController();
  final _pass    = TextEditingController();
  bool _obscure  = true;
  bool _loading  = false;

  @override
  void dispose() {
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 2)); // Simulate API call
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ── Background gradient ──────────────────────────────────────────
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF0F0722),
                  Color(0xFF1A0B3B),
                  Color(0xFF0D1B4B),
                ],
              ),
            ),
          ),

          // ── Decorative orbs ─────────────────────────────────────────────
          Positioned(top: -80, left: -60,
            child: _Orb(color: const Color(0xFF7C3AED), size: 280)),
          Positioned(bottom: -60, right: -40,
            child: _Orb(color: const Color(0xFF2563EB), size: 220)),
          Positioned(top: 200, right: -30,
            child: _Orb(color: const Color(0xFF8B5CF6), size: 140)),

          // ── Glass card ──────────────────────────────────────────────────
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.18),
                        width: 1.5,
                      ),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Logo / title
                          const Icon(Icons.bolt_rounded,
                            color: Color(0xFFA78BFA), size: 40),
                          const SizedBox(height: 16),
                          const Text('Welcome back',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.5,
                            )),
                          const SizedBox(height: 6),
                          Text('Sign in to continue',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.55),
                              fontSize: 15,
                            )),
                          const SizedBox(height: 32),

                          // Email field
                          _GlassField(
                            controller: _email,
                            hint: 'Email address',
                            icon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            validator: (v) =>
                              v!.isEmpty ? 'Enter your email' :
                              !v.contains('@') ? 'Invalid email' : null,
                          ),
                          const SizedBox(height: 16),

                          // Password field
                          _GlassField(
                            controller: _pass,
                            hint: 'Password',
                            icon: Icons.lock_outline,
                            obscure: _obscure,
                            suffix: IconButton(
                              icon: Icon(
                                _obscure ? Icons.visibility_off_outlined
                                         : Icons.visibility_outlined,
                                color: Colors.white54, size: 20,
                              ),
                              onPressed: () => setState(() => _obscure = !_obscure),
                            ),
                            validator: (v) =>
                              v!.length < 6 ? 'Min 6 characters' : null,
                          ),
                          const SizedBox(height: 10),

                          // Forgot password
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () {},
                              child: Text('Forgot password?',
                                style: TextStyle(
                                  color: const Color(0xFFA78BFA).withValues(alpha: 0.9),
                                  fontSize: 13,
                                )),
                            ),
                          ),
                          const SizedBox(height: 28),

                          // Sign In button
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: FilledButton(
                              style: FilledButton.styleFrom(
                                backgroundColor: const Color(0xFF7C3AED),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14)),
                              ),
                              onPressed: _loading ? null : _submit,
                              child: _loading
                                ? const SizedBox(width: 20, height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white, strokeWidth: 2))
                                : const Text('Sign In',
                                    style: TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.w600)),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Divider
                          Row(children: [
                            Expanded(child: Divider(color: Colors.white.withValues(alpha: 0.15))),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Text('or',
                                style: TextStyle(color: Colors.white.withValues(alpha: 0.4))),
                            ),
                            Expanded(child: Divider(color: Colors.white.withValues(alpha: 0.15))),
                          ]),
                          const SizedBox(height: 20),

                          // Google sign in
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                side: BorderSide(
                                  color: Colors.white.withValues(alpha: 0.2)),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14)),
                              ),
                              icon: const Icon(Icons.g_mobiledata, size: 24),
                              label: const Text('Continue with Google'),
                              onPressed: () {},
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Sign up link
                          Center(child: GestureDetector(
                            onTap: () {},
                            child: RichText(text: TextSpan(
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.5),
                                fontSize: 14),
                              children: const [
                                TextSpan(text: "Don't have an account? "),
                                TextSpan(text: 'Sign up',
                                  style: TextStyle(
                                    color: Color(0xFFA78BFA),
                                    fontWeight: FontWeight.w600)),
                              ],
                            )),
                          )),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Glass Text Field ─────────────────────────────────────────────────────────
class _GlassField extends StatelessWidget {
  const _GlassField({
    required this.controller,
    required this.hint,
    required this.icon,
    this.validator,
    this.keyboardType,
    this.obscure = false,
    this.suffix,
  });

  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool obscure;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.4)),
        prefixIcon: Icon(icon, color: Colors.white38, size: 20),
        suffixIcon: suffix,
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.07),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.15)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.15)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF7C3AED), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFEF4444)),
        ),
        errorStyle: const TextStyle(color: Color(0xFFEF4444)),
      ),
    );
  }
}

// ─── Decorative Orb ───────────────────────────────────────────────────────────
class _Orb extends StatelessWidget {
  const _Orb({required this.color, required this.size});
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size, height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: 0.3),
        boxShadow: [
          BoxShadow(color: color.withValues(alpha: 0.4),
            blurRadius: size * 0.8, spreadRadius: size * 0.1),
        ],
      ),
    );
  }
}
