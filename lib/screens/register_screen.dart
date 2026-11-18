import 'package:flutter/material.dart';

import '../user_profile_store.dart';
import 'home_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Créer un compte',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const Text(
                'Rejoignez ImmoFinder',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 30),

              // Champs (Nom, Email, Tel, Mdp, Confirmation)
              _buildTextField(
                'Nom complet',
                Icons.person_outline,
                controller: _nameController,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                'Email',
                Icons.email_outlined,
                controller: _emailController,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                'Téléphone',
                Icons.phone_outlined,
                controller: _phoneController,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                'Mot de passe',
                Icons.lock_outline,
                isPassword: true,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                'Confirmer le mot de passe',
                Icons.lock_outline,
                isPassword: true,
              ),

              const SizedBox(height: 30),

              // Bouton S'inscrire
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    UserProfileStore.instance.register(
                      name: _nameController.text,
                      email: _emailController.text,
                      phone: _phoneController.text,
                    );
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4B2A8B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'S\'inscrire',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),

              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Déjà un compte ? "),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text(
                      'Se connecter',
                      style: TextStyle(
                        color: Color(0xFF4B2A8B),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Fonction utilitaire pour créer les champs de texte rapidement
  Widget _buildTextField(
    String hint,
    IconData icon, {
    bool isPassword = false,
    TextEditingController? controller,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
