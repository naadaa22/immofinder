import 'package:flutter/material.dart';

import '../user_profile_store.dart';
import 'home_screen.dart';
import 'privacy_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signIn() {
    UserProfileStore.instance.signIn(email: _emailController.text);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute<void>(builder: (_) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final contentWidth = constraints.maxWidth > 440
                ? 390.0
                : constraints.maxWidth - 48;

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 32,
                ),
                child: Center(
                  child: SizedBox(
                    width: contentWidth,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 26),
                        const _BrandLogo(),
                        const SizedBox(height: 24),
                        const Text(
                          'Se connecter',
                          style: TextStyle(
                            color: Color(0xFF20212A),
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Connectez-vous pour continuer',
                          style: TextStyle(
                            color: Color(0xFFA2A3A9),
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 24),
                        _LoginField(
                          controller: _emailController,
                          hint: 'Email',
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 12),
                        _LoginField(
                          controller: _passwordController,
                          hint: 'Mot de passe',
                          icon: Icons.lock_outline,
                          obscureText: _obscurePassword,
                          suffix: IconButton(
                            onPressed: () => setState(() {
                              _obscurePassword = !_obscurePassword;
                            }),
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              size: 17,
                              color: const Color(0xFFB2B3BA),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: 44,
                          child: ElevatedButton(
                            onPressed: _signIn,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF5938D7),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(9),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                            ),
                            child: const Text(
                              'Se connecter',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        const Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: Color(0xFFE7E7EC),
                                thickness: 1,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                'or',
                                style: TextStyle(
                                  color: Color(0xFF777984),
                                  fontSize: 10,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: Color(0xFFE7E7EC),
                                thickness: 1,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _SocialButton(
                              label: 'Google',
                              icon: const Text(
                                'G',
                                style: TextStyle(
                                  color: Color(0xFF4285F4),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              onPressed: () {},
                            ),
                            const SizedBox(width: 10),
                            _SocialButton(
                              label: 'Apple',
                              icon: const Icon(
                                Icons.apple,
                                size: 21,
                                color: Color(0xFF202126),
                              ),
                              onPressed: () {},
                            ),
                          ],
                        ),
                        const SizedBox(height: 22),
                        Wrap(
                          alignment: WrapAlignment.center,
                          children: [
                            const Text(
                              "Vous n'avez pas de compte ? ",
                              style: TextStyle(
                                color: Color(0xFF777984),
                                fontSize: 11,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (_) => const RegisterScreen(),
                                ),
                              ),
                              child: const Text(
                                "S'inscrire",
                                style: TextStyle(
                                  color: Color(0xFF5938D7),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (_) => const PrivacyScreen(),
                            ),
                          ),
                          style: TextButton.styleFrom(
                            foregroundColor: const Color(0xFF9A9BA3),
                            minimumSize: Size.zero,
                            padding: EdgeInsets.zero,
                          ),
                          child: const Text(
                            'Politique de confidentialité',
                            style: TextStyle(fontSize: 9),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _BrandLogo extends StatelessWidget {
  const _BrandLogo();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 38,
          height: 38,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              const Icon(
                Icons.home_rounded,
                size: 38,
                color: Color(0xFF5938D7),
              ),
              Positioned(
                right: 8,
                top: 12,
                child: Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 3),
        const Text(
          'Immofinder',
          style: TextStyle(
            color: Color(0xFF5938D7),
            fontSize: 18,
            height: 1,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _LoginField extends StatelessWidget {
  const _LoginField({
    required this.controller,
    required this.hint,
    required this.icon,
    this.obscureText = false,
    this.keyboardType,
    this.suffix,
  });

  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F9),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: const Color(0xFFE6E6EB)),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: const TextStyle(
          color: Color(0xFF343540),
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFFB1B2BA), fontSize: 11),
          prefixIcon: Icon(icon, size: 16, color: const Color(0xFF777984)),
          suffixIcon: suffix,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 13),
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final Widget icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 88,
      height: 44,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF33343B),
          backgroundColor: Colors.white,
          side: const BorderSide(color: Color(0xFFE6E6EB)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
          padding: EdgeInsets.zero,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
