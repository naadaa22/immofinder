import 'package:flutter/material.dart';
import 'dart:ui' show PathMetric;

const _purple = Color(0xFF4B2A8B);

class AddListingScreen extends StatefulWidget {
  const AddListingScreen({super.key});

  @override
  State<AddListingScreen> createState() => _AddListingScreenState();
}

class _AddListingScreenState extends State<AddListingScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  
  // State for Dropdown
  String? _selectedPropertyType;
  final List<String> _propertyTypes = [
    'Appartement',
    'Maison',
    'Terrain',
    'Local Commercial',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
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
      backgroundColor: Colors.white, // Matches screenshot background
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Publier une annonce',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          children: [
            // --- Photo Upload Section ---
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Sélection des photos...')),
                );
              },
              child: CustomPaint(
                painter: DashedRectPainter(
                  color: const Color(0xFFC5C5D3),
                  strokeWidth: 1.5,
                  gap: 5.0,
                ),
                child: Container(
                  height: 140,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F4FA), // Light blue/purple background
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.camera_alt, color: _purple, size: 32),
                      SizedBox(height: 8),
                      Text(
                        'Ajouter des photos',
                        style: TextStyle(
                          color: _purple,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '(Appuyez pour choisir)',
                        style: TextStyle(
                          color: Color(0xFF7A7A9D),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // --- Titre ---
            _buildTextField(
              controller: _titleController,
              hint: 'Titre de l\'annonce *',
              validator: (val) => val!.isEmpty ? 'Requis' : null,
            ),
            const SizedBox(height: 16),

            // --- Description ---
            _buildTextField(
              controller: _descriptionController,
              hint: 'Description *',
              maxLines: 4,
              validator: (val) => val!.isEmpty ? 'Requis' : null,
            ),
            const SizedBox(height: 16),

            // --- Type de bien (Dropdown) ---
            DropdownButtonFormField<String>(
              decoration: _inputDecoration('Type de bien'),
              hint: const Text(
                'Sélectionner...',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              value: _selectedPropertyType,
              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
              items: _propertyTypes.map((String type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedPropertyType = newValue;
                });
              },
            ),
            const SizedBox(height: 16),

            // --- Prix ---
            _buildTextField(
              controller: _priceController,
              hint: 'Prix (DT)',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 30),

            // --- Submit Button ---
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _publishListing,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _purple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Publier l\'annonce',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Helper widget for text fields to keep code clean
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      decoration: _inputDecoration(hint),
      style: const TextStyle(fontSize: 14),
    );
  }

  // Common Input Decoration
  InputDecoration _inputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      filled: true,
      fillColor: Colors.white,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _purple),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
    );
  }
}

// --- Custom Painter to draw the dashed border without external packages ---
class DashedRectPainter extends CustomPainter {
  final double strokeWidth;
  final Color color;
  final double gap;

  DashedRectPainter({
    this.strokeWidth = 1.0,
    this.color = Colors.black,
    this.gap = 5.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final double width = size.width;
    final double height = size.height;
    final double radius = 12.0; // Matches container radius

    // Create path for rounded rectangle
    final Path path = Path()
      ..addRRect(RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, width, height), Radius.circular(radius)));

    // Draw dashes
    final Path dashPath = Path();
    double distance = 0.0;

    for (final PathMetric metric in path.computeMetrics()) {
      while (distance < metric.length) {
        dashPath.addPath(
          metric.extractPath(distance, distance + gap),
          Offset.zero,
        );
        distance += gap * 2;
      }
    }

    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}