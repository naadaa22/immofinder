import 'package:flutter/material.dart';

import '../favorites_store.dart';
import '../user_profile_store.dart';
import 'add_listing_screen.dart';
import 'favorites_screen.dart';
import 'login_screen.dart';

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
      appBar: AppBar(
        title: const Text(
          'Mon profil',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFF8F7FC),
        actions: [
          IconButton(
            tooltip: 'Modifier mon profil',
            onPressed: _editProfile,
            icon: const Icon(Icons.edit_outlined, color: _purple),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        children: [
          AnimatedBuilder(
            animation: UserProfileStore.instance,
            builder: (context, _) {
              final profile =
                  UserProfileStore.instance.current ??
                  const UserProfile(name: 'Utilisateur', email: '', phone: '');
              return _ProfileHeader(
                name: profile.name,
                email: profile.email,
                phone: profile.phone,
                onEdit: _editProfile,
              );
            },
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              const Expanded(
                child: _ProfileStat(
                  icon: Icons.home_work_outlined,
                  value: '0',
                  label: 'Annonces',
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: AnimatedBuilder(
                  animation: FavoritesStore.instance,
                  builder: (context, _) => _ProfileStat(
                    icon: Icons.favorite_border,
                    value: '${FavoritesStore.instance.favorites.length}',
                    label: 'Favoris',
                  ),
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: _ProfileStat(
                  icon: Icons.star_outline,
                  value: '4.8',
                  label: 'Note',
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const _GroupLabel(title: 'Mon espace'),
          const SizedBox(height: 8),
          _ProfileActionTile(
            icon: Icons.campaign_outlined,
            title: 'Mes annonces',
            subtitle: 'Gérer et publier vos biens',
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
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const FavoritesScreen()),
            ),
          ),
          _ProfileActionTile(
            icon: Icons.person_outline,
            title: 'Informations personnelles',
            subtitle: 'Nom, email et téléphone',
            onTap: _editProfile,
          ),
          const SizedBox(height: 20),
          const _GroupLabel(title: 'Préférences'),
          const SizedBox(height: 8),
          Card(
            margin: const EdgeInsets.only(bottom: 10),
            color: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: Color(0xFFECE8F3)),
            ),
            child: SwitchListTile(
              secondary: const _ActionIcon(icon: Icons.notifications_none),
              title: const Text(
                'Notifications',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: const Text('Nouveaux messages et annonces'),
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
            onTap: _showHelp,
          ),
          _ProfileActionTile(
            icon: Icons.privacy_tip_outlined,
            title: 'Confidentialité',
            subtitle: 'Gérer la sécurité de votre compte',
            onTap: () => _showInfo(
              'Confidentialité',
              'Les paramètres de confidentialité seront bientôt disponibles.',
            ),
          ),
          const SizedBox(height: 10),
          TextButton.icon(
            onPressed: _logout,
            icon: const Icon(Icons.logout, color: Color(0xFFB3261E)),
            label: const Text(
              'Se déconnecter',
              style: TextStyle(
                color: Color(0xFFB3261E),
                fontWeight: FontWeight.w600,
              ),
            ),
            style: TextButton.styleFrom(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            ),
          ),
        ],
      ),
    );
  }

  void _showInfo(String title, String message) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({
    required this.name,
    required this.email,
    required this.phone,
    required this.onEdit,
  });

  final String name;
  final String email;
  final String phone;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_purple, Color(0xFF7952C8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 34,
            backgroundColor: Colors.white.withValues(alpha: 0.2),
            child: Text(
              _initials(name),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  email.isEmpty ? 'Adresse email non renseignée' : email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 3),
                Text(
                  phone.isEmpty ? 'Téléphone non renseigné' : phone,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onEdit,
            tooltip: 'Modifier',
            icon: const Icon(Icons.edit_outlined, color: Colors.white),
          ),
        ],
      ),
    );
  }

  String _initials(String value) {
    final parts = value.trim().split(RegExp(r'\s+'));
    if (parts.length < 2) return parts.first.characters.first.toUpperCase();
    return '${parts.first.characters.first}${parts.last.characters.first}'
        .toUpperCase();
  }
}

class _ProfileStat extends StatelessWidget {
  const _ProfileStat({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFECE8F3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: _purple, size: 20),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 11)),
        ],
      ),
    );
  }
}

class _GroupLabel extends StatelessWidget {
  const _GroupLabel({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
    );
  }
}

class _ProfileActionTile extends StatelessWidget {
  const _ProfileActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFECE8F3)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        leading: _ActionIcon(icon: icon),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right, color: Colors.black38),
        onTap: onTap,
      ),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  const _ActionIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: const Color(0xFFEDE7F7),
      child: Icon(icon, color: _purple, size: 21),
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
