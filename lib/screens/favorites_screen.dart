import 'package:flutter/material.dart';

import '../favorites_store.dart';
import '../language_store.dart';
import 'listing_detail_screen.dart';
import 'messages_screen.dart';

const _purple = Color(0xFF4B2A8B);

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: LanguageStore.instance,
      builder: (context, _) => Scaffold(
        backgroundColor: const Color(0xFFF8F7FC),
        appBar: AppBar(
          title: Text(
            LanguageStore.instance.text('my_favorites'),
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: const Color(0xFFF8F7FC),
          elevation: 0,
        ),
        body: AnimatedBuilder(
          animation: FavoritesStore.instance,
          builder: (context, _) {
            final favorites = FavoritesStore.instance.favorites;
            if (favorites.isEmpty) {
              return const _EmptyFavorites();
            }

            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              children: [
                Text(
                  '${favorites.length} bien${favorites.length > 1 ? 's' : ''} enregistré${favorites.length > 1 ? 's' : ''}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 14),
                for (final listing in favorites)
                  _FavoriteCard(
                    listing: listing,
                    onRemove: () => FavoritesStore.instance.toggle(listing),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _FavoriteCard extends StatelessWidget {
  const _FavoriteCard({required this.listing, required this.onRemove});

  final PropertyListing listing;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      color: Colors.white,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => ListingDetailScreen(
                title: listing.title,
                price: listing.price,
                location: listing.location,
                image: listing.image,
                category: listing.category,
                rating: listing.rating,
                reviews: listing.reviews,
                bedrooms: listing.bedrooms,
                area: listing.area,
                description: listing.description,
                ownerName: listing.ownerName,
                ownerId: listing.ownerId,
              ),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 190,
                  width: double.infinity,
                  child: Image.asset(
                    listing.image,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => const ColoredBox(
                      color: Color(0xFFEDE7F7),
                      child: Center(
                        child: Icon(Icons.apartment, color: _purple, size: 56),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Material(
                    color: Colors.white,
                    shape: const CircleBorder(),
                    child: IconButton(
                      onPressed: onRemove,
                      tooltip: LanguageStore.instance.text('remove_favorite'),
                      icon: const Icon(Icons.favorite, color: Colors.red),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 12,
                  left: 12,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      child: Text(
                        LanguageStore.instance.text('for_sale'),
                        style: const TextStyle(
                          color: _purple,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    listing.price,
                    style: const TextStyle(
                      color: _purple,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    listing.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        color: Colors.black54,
                        size: 17,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        listing.location,
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      _Feature(
                        icon: Icons.bed_outlined,
                        label:
                            '${listing.bedrooms} ${LanguageStore.instance.text('bedrooms')}',
                      ),
                      const SizedBox(width: 18),
                      _Feature(
                        icon: Icons.square_foot,
                        label: '${listing.area} m²',
                      ),
                      const Spacer(),
                      FilledButton.icon(
                        onPressed: () {
                          MessagesScreen.openConversation(
                            context,
                            otherUserId: listing.ownerId,
                            otherUserName: listing.ownerName,
                            property: '${listing.title} · ${listing.location}',
                          );
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: _purple,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        icon: const Icon(Icons.chat_bubble_outline, size: 17),
                        label: Text(LanguageStore.instance.text('contact')),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Feature extends StatelessWidget {
  const _Feature({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 17, color: _purple),
        const SizedBox(width: 5),
        Text(label, style: TextStyle(color: Colors.grey[700], fontSize: 12)),
      ],
    );
  }
}

class _EmptyFavorites extends StatelessWidget {
  const _EmptyFavorites();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundColor: Color(0xFFEDE7F7),
              child: Icon(Icons.favorite_border, color: _purple, size: 38),
            ),
            const SizedBox(height: 18),
            Text(
              LanguageStore.instance.text('no_favorites'),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              LanguageStore.instance.text('no_favorites_hint'),
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600], height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}
