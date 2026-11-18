import 'package:flutter/material.dart';

const _privacyPurple = Color(0xFF4B2A8B);

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FC),
      appBar: AppBar(
        title: const Text('Confidentialité'),
        backgroundColor: const Color(0xFFF8F7FC),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        children: const [
          _PrivacyIntroduction(),
          SizedBox(height: 18),
          _PrivacySection(
            icon: Icons.person_outline,
            title: 'Informations du profil',
            content:
                'Le nom, l’adresse email et le numéro de téléphone que vous '
                'renseignez servent à afficher votre profil. Dans la version '
                'actuelle, ces informations restent en mémoire pendant '
                'l’utilisation de l’application et ne sont pas envoyées à un '
                'serveur de compte.',
          ),
          _PrivacySection(
            icon: Icons.favorite_border,
            title: 'Favoris et messages',
            content:
                'Vos favoris et les messages saisis dans l’application sont '
                'gérés localement pendant la session. Cette version ne les '
                'transmet pas à un serveur et ne les conserve pas après la '
                'fermeture de l’application.',
          ),
          _PrivacySection(
            icon: Icons.location_on_outlined,
            title: 'Localisation et carte',
            content:
                'La localisation de l’appareil est demandée uniquement si '
                'vous choisissez « Utiliser ma position actuelle ». Elle sert '
                'à afficher votre position dans l’application et n’est pas '
                'enregistrée par celle-ci. La carte charge des tuiles depuis '
                'OpenStreetMap : ce service peut recevoir des données '
                'techniques de connexion, comme votre adresse IP et les zones '
                'de carte consultées.',
          ),
          _PrivacySection(
            icon: Icons.tune,
            title: 'Vos choix',
            content:
                'Vous pouvez modifier les informations de votre profil, vous '
                'déconnecter pour effacer le profil chargé en mémoire ou '
                'désactiver l’autorisation de localisation dans les réglages '
                'de votre appareil.',
          ),
          _PrivacySection(
            icon: Icons.info_outline,
            title: 'Version actuelle',
            content:
                'Cette page décrit le fonctionnement actuel d’ImmoFinder. '
                'Si l’application ajoute ultérieurement un compte en ligne '
                'ou d’autres services, cette information devra être mise à '
                'jour.',
          ),
          SizedBox(height: 8),
          Text(
            'Pour toute question, contactez-nous à support@immofinder.tn.',
            style: TextStyle(color: Colors.black54, height: 1.5),
          ),
          SizedBox(height: 12),
          Text(
            'Cartographie : © OpenStreetMap contributors',
            style: TextStyle(color: Colors.black54, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _PrivacyIntroduction extends StatelessWidget {
  const _PrivacyIntroduction();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFEDE7F6),
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.privacy_tip_outlined, color: _privacyPurple, size: 30),
          SizedBox(height: 12),
          Text(
            'Votre vie privée compte',
            style: TextStyle(
              color: _privacyPurple,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Voici comment les informations sont utilisées dans la version '
            'actuelle de l’application.',
            style: TextStyle(height: 1.5),
          ),
        ],
      ),
    );
  }
}

class _PrivacySection extends StatelessWidget {
  const _PrivacySection({
    required this.icon,
    required this.title,
    required this.content,
  });

  final IconData icon;
  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFECE8F3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: _privacyPurple),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(content, style: const TextStyle(height: 1.5)),
          ],
        ),
      ),
    );
  }
}
