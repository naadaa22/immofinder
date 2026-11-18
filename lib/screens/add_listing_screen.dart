import 'package:flutter/material.dart';

const _purple = Color(0xFF4B2A8B);

class AddListingScreen extends StatefulWidget {
  const AddListingScreen({super.key});

  @override
  State<AddListingScreen> createState() => _AddListingScreenState();
}

class _AddListingScreenState extends State<AddListingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedType = 'Vente';

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _publishListing() {
    if (!_formKey.currentState!.validate()) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Votre annonce est prête à être publiée !'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FC),
      appBar: AppBar(
        title: const Text(
          'Déposer une annonce',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFF8F7FC),
        centerTitle: false,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [_purple, Color(0xFF7952C8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.campaign_outlined, color: Colors.white, size: 30),
                  SizedBox(height: 12),
                  Text(
                    'Votre prochain acheteur\nest peut-être ici.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      height: 1.2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Ajoutez les informations de votre bien pour créer votre annonce.',
                    style: TextStyle(color: Colors.white70, height: 1.4),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            const _SectionTitle(title: 'Comment ajouter une annonce ?'),
            const SizedBox(height: 12),
            const _HowToStep(
              number: '1',
              title: 'Présentez votre bien',
              detail: 'Ajoutez un titre, un prix et une localisation.',
            ),
            const _HowToStep(
              number: '2',
              title: 'Ajoutez des détails',
              detail: 'Décrivez le bien et ajoutez de belles photos.',
            ),
            const _HowToStep(
              number: '3',
              title: 'Publiez',
              detail: 'Vérifiez les informations puis validez votre annonce.',
            ),
            const SizedBox(height: 24),
            const _SectionTitle(title: 'Les informations du bien'),
            const SizedBox(height: 14),
            const Text(
              'Type d’annonce',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 10,
              children: ['Vente', 'Location'].map((type) {
                final selected = _selectedType == type;
                return ChoiceChip(
                  label: Text(type),
                  selected: selected,
                  onSelected: (_) => setState(() => _selectedType = type),
                  selectedColor: const Color(0xFFE9E2F8),
                  labelStyle: TextStyle(
                    color: selected ? _purple : Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                  side: BorderSide(color: selected ? _purple : Colors.black12),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            _ListingField(
              controller: _titleController,
              label: 'Titre de l’annonce',
              hint: 'Ex. Appartement lumineux S+2',
              icon: Icons.home_outlined,
              validator: _requiredValidator,
            ),
            const SizedBox(height: 12),
            _ListingField(
              controller: _priceController,
              label: 'Prix (DT)',
              hint: 'Ex. 250 000',
              icon: Icons.payments_outlined,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Veuillez indiquer un prix';
                }
                if (double.tryParse(value.trim()) == null) {
                  return 'Entrez un prix valide';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            _ListingField(
              controller: _locationController,
              label: 'Localisation',
              hint: 'Ville, quartier',
              icon: Icons.location_on_outlined,
              validator: _requiredValidator,
            ),
            const SizedBox(height: 12),
            _ListingField(
              controller: _descriptionController,
              label: 'Description',
              hint: 'Décrivez les atouts de votre bien...',
              icon: Icons.notes_outlined,
              maxLines: 4,
              validator: _requiredValidator,
            ),
            const SizedBox(height: 18),
            const Text(
              'Photos du bien',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Ajout de photos bientôt disponible.'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              icon: const Icon(Icons.add_photo_alternate_outlined),
              label: const Text('Ajouter des photos'),
              style: OutlinedButton.styleFrom(
                foregroundColor: _purple,
                minimumSize: const Size.fromHeight(52),
                side: const BorderSide(color: Color(0xFFD8CDED)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            const SizedBox(height: 22),
            FilledButton.icon(
              onPressed: _publishListing,
              icon: const Icon(Icons.publish),
              label: const Text('Publier mon annonce'),
              style: FilledButton.styleFrom(
                backgroundColor: _purple,
                minimumSize: const Size.fromHeight(54),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String? _requiredValidator(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Ce champ est obligatoire';
  }
  return null;
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
    );
  }
}

class _HowToStep extends StatelessWidget {
  const _HowToStep({
    required this.number,
    required this.title,
    required this.detail,
  });

  final String number;
  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 15,
            backgroundColor: const Color(0xFFE9E2F8),
            child: Text(
              number,
              style: const TextStyle(
                color: _purple,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(detail, style: TextStyle(color: Colors.grey[600])),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ListingField extends StatelessWidget {
  const _ListingField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.keyboardType,
    this.maxLines = 1,
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;
  final int maxLines;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: _purple),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFECE8F3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _purple),
        ),
      ),
    );
  }
}
