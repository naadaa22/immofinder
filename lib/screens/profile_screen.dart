import 'package:flutter/material.dart';

import '../user_profile_store.dart';
import 'add_listing_screen.dart';
import 'favorites_screen.dart';
import 'login_screen.dart';
import 'privacy_screen.dart';

const _purple = Color(0xFF4B2A8B);

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notificationsEnabled = true;

  Future<void> _editProfile() async {
    final current =
        UserProfileStore.instance.current ??
        const UserProfile(name: 'Utilisateur', email: '', phone: '');
    final profile = await showDialog<_ProfileInfo>(
      context: context,
      builder: (_) => _EditProfileDialog(
        name: current.name,
        email: current.email,
        phone: current.phone,
      ),
    );

    if (profile == null || !mounted) return;
    UserProfileStore.instance.update(
      UserProfile(
        name: profile.name,
        email: profile.email,
        phone: profile.phone,
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Votre profil a été mis à jour.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _logout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Se déconnecter ?'),
        content: const Text('Voulez-vous vraiment quitter votre compte ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: _purple),
            child: const Text('Déconnexion'),
          ),
        ],
      ),
    );

    if (shouldLogout != true || !mounted) return;
    UserProfileStore.instance.clear();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }

  void _showHelp() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.support_agent, color: _purple, size: 32),
        title: const Text('Besoin d’aide ?'),
        content: const Text(
          'Notre équipe est là pour vous accompagner. '
          'Écrivez-nous à support@immofinder.tn.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FC),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(0, 12, 0, 24),
          children: [
            const _GroupLabel(title: 'Mon espace'),
            const SizedBox(height: 14),
            _ProfileActionTile(
              icon: Icons.home_outlined,
              title: 'Mes annonces',
              subtitle: 'Gérer et publier vos biens',
              iconColor: const Color(0xFF5E37A7),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const _MyListingsScreen(),
                ),
              ),
            ),
            _ProfileActionTile(
              icon: Icons.favorite_border,
              title: 'Mes favoris',
              subtitle: 'Les biens que vous avez enregistrés',
              iconColor: const Color(0xFFE83E57),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const FavoritesScreen(),
                ),
              ),
            ),
            _ProfileActionTile(
              icon: Icons.person_outline,
              title: 'Informations personnelles',
              subtitle: 'Nom, email et téléphone',
              iconColor: const Color(0xFF6D78C7),
              onTap: _editProfile,
            ),
            const SizedBox(height: 22),
            const _GroupLabel(title: 'Préférences'),
            const SizedBox(height: 14),
            Card(
              margin: const EdgeInsets.fromLTRB(14, 0, 14, 12),
              color: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: Color(0xFFF0EEF4)),
              ),
              child: SwitchListTile(
                contentPadding: const EdgeInsets.fromLTRB(16, 8, 14, 8),
                secondary: const _ActionIcon(
                  icon: Icons.notifications_none,
                  iconColor: Color(0xFFEFAC21),
                ),
                title: const Text(
                  'Notifications',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
                ),
                subtitle: const Text(
                  'Nouveaux messages et annonces',
                  style: TextStyle(color: Color(0xFF77757D), fontSize: 14),
                ),
                value: _notificationsEnabled,
                activeThumbColor: _purple,
                onChanged: (enabled) {
                  setState(() => _notificationsEnabled = enabled);
                },
              ),
            ),
            _ProfileActionTile(
              icon: Icons.help_outline,
              title: 'Centre d’aide',
              subtitle: 'Questions fréquentes et assistance',
              iconColor: const Color(0xFF35AFA7),
              onTap: _showHelp,
            ),
            _ProfileActionTile(
              icon: Icons.privacy_tip_outlined,
              title: 'Confidentialité',
              subtitle: 'Consulter la politique de confidentialité',
              iconColor: const Color(0xFF555F9C),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const PrivacyScreen()),
              ),
            ),
            const SizedBox(height: 18),
            Center(
              child: TextButton.icon(
                onPressed: _logout,
                icon: const Icon(Icons.logout, color: Color(0xFFE53935)),
                label: const Text(
                  'Se déconnecter',
                  style: TextStyle(
                    color: Color(0xFFE53935),
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GroupLabel extends StatelessWidget {
  const _GroupLabel({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 14),
      child: Text(
        title,
        textAlign: TextAlign.left,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
      ),
    );
  }
}

class _ProfileActionTile extends StatelessWidget {
  const _ProfileActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.iconColor = _purple,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(14, 0, 14, 12),
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFF0EEF4)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.fromLTRB(16, 8, 14, 8),
        leading: _ActionIcon(icon: icon, iconColor: iconColor),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            color: Color(0xFF77757D),
            fontSize: 14,
            height: 1.25,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: Color(0xFF9D91AF),
          size: 24,
        ),
        onTap: onTap,
      ),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  const _ActionIcon({required this.icon, this.iconColor = _purple});

  final IconData icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      height: 48,
      child: Center(child: Icon(icon, color: iconColor, size: 26)),
    );
  }
}

class _ProfileInfo {
  const _ProfileInfo({
    required this.name,
    required this.email,
    required this.phone,
  });

  final String name;
  final String email;
  final String phone;
}

class _EditProfileDialog extends StatefulWidget {
  const _EditProfileDialog({
    required this.name,
    required this.email,
    required this.phone,
  });

  final String name;
  final String email;
  final String phone;

  @override
  State<_EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<_EditProfileDialog> {
  final _formKey = GlobalKey<FormState>();
  late final _nameController = TextEditingController(text: widget.name);
  late final _emailController = TextEditingController(text: widget.email);
  late final _phoneController = TextEditingController(text: widget.phone);

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pop(
      context,
      _ProfileInfo(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Modifier mon profil'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _EditField(
                controller: _nameController,
                label: 'Nom complet',
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Le nom est obligatoire'
                    : null,
              ),
              const SizedBox(height: 12),
              _EditField(
                controller: _emailController,
                label: 'Adresse email',
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || !value.contains('@')) {
                    return 'Entrez une adresse email valide';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              _EditField(
                controller: _phoneController,
                label: 'Téléphone',
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),
        FilledButton(
          onPressed: _save,
          style: FilledButton.styleFrom(backgroundColor: _purple),
          child: const Text('Enregistrer'),
        ),
      ],
    );
  }
}

class _EditField extends StatelessWidget {
  const _EditField({
    required this.controller,
    required this.label,
    this.keyboardType,
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

class _MyListingsScreen extends StatelessWidget {
  const _MyListingsScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FC),
      appBar: AppBar(
        title: const Text(
          'Mes annonces',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFF8F7FC),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircleAvatar(
                radius: 38,
                backgroundColor: Color(0xFFEDE7F7),
                child: Icon(Icons.home_work_outlined, color: _purple, size: 36),
              ),
              const SizedBox(height: 16),
              const Text(
                'Aucune annonce pour le moment',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Publiez votre premier bien et faites-le découvrir aux acheteurs.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600], height: 1.4),
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const AddListingScreen(),
                  ),
                ),
                icon: const Icon(Icons.add),
                label: const Text('Déposer une annonce'),
                style: FilledButton.styleFrom(
                  backgroundColor: _purple,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
