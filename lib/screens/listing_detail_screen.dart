import 'package:flutter/material.dart';

import '../language_store.dart';
import 'messages_screen.dart';

const _purple = Color(0xFF4B2A8B);

class ListingDetailScreen extends StatelessWidget {
  const ListingDetailScreen({
    super.key,
    required this.title,
    required this.price,
    required this.location,
    required this.image,
    required this.ownerName,
    required this.ownerId,
    this.category,
    this.rating,
    this.reviews,
    this.bedrooms,
    this.area,
    this.description,
  });

  final String title;
  final String price;
  final String location;
  final String image;
  final String ownerName;
  final String ownerId;
  final String? category;
  final String? rating;
  final String? reviews;
  final int? bedrooms;
  final int? area;
  final String? description;

  @override
  Widget build(BuildContext context) {
    final language = LanguageStore.instance;
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FC),
      appBar: AppBar(
        title: Text(
          language.text('listing_details'),
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          AspectRatio(
            aspectRatio: 16 / 10,
            child: Image.asset(
              image,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => const ColoredBox(
                color: Color(0xFFEDE7F7),
                child: Center(
                  child: Icon(Icons.apartment, color: _purple, size: 72),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  price,
                  style: const TextStyle(
                    color: _purple,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      color: Colors.black54,
                      size: 20,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        location,
                        style: TextStyle(color: Colors.grey[700], fontSize: 15),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if (category != null)
                      _DetailChip(icon: Icons.sell_outlined, label: category!),
                    if (bedrooms != null)
                      _DetailChip(
                        icon: Icons.bed_outlined,
                        label: '$bedrooms ${language.text('bedrooms')}',
                      ),
                    if (area != null)
                      _DetailChip(icon: Icons.square_foot, label: '$area m²'),
                    if (rating != null)
                      _DetailChip(
                        icon: Icons.star_outline,
                        label: '$rating ${reviews ?? ''}',
                      ),
                  ],
                ),
                const SizedBox(height: 22),
                Text(
                  language.text('description'),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description ?? language.text('listing_description_default'),
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 15,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 22),
                Text(
                  language.text('owner'),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFECE8F3)),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: const Color(0xFFE9E2F8),
                        child: Text(
                          _initials(ownerName),
                          style: const TextStyle(
                            color: _purple,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          ownerName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      FilledButton.icon(
                        onPressed: () {
                          MessagesScreen.openConversation(
                            context,
                            otherUserId: ownerId,
                            otherUserName: ownerName,
                            property: '$title · $location',
                          );
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: _purple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        icon: const Icon(Icons.chat_bubble_outline, size: 17),
                        label: Text(language.text('contact')),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }
}

class _DetailChip extends StatelessWidget {
  const _DetailChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: const Color(0xFFEDE7F7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 17, color: _purple),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(color: _purple, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
