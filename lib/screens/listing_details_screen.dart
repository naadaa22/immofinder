import 'package:flutter/material.dart';

import '../favorites_store.dart';

class ListingDetailsScreen extends StatelessWidget {
  const ListingDetailsScreen({
    super.key,
    required this.title,
    required this.price,
    required this.location,
    required this.category,
    required this.imagePath,
    required this.description,
    this.rating,
    this.reviews,
    this.photoCredit,
    this.bedrooms,
    this.area,
  });

  final String title;
  final String price;
  final String location;
  final String category;
  final String imagePath;
  final String description;
  final String? rating;
  final String? reviews;
  final String? photoCredit;
  final int? bedrooms;
  final int? area;

  @override
  Widget build(BuildContext context) {
    final favoriteListing = PropertyListing(
      id: 'home-$title',
      title: title,
      price: price,
      location: location,
      bedrooms: bedrooms ?? 0,
      area: area ?? 0,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 330,
            pinned: true,
            backgroundColor: const Color(0xFF1D2430),
            foregroundColor: Colors.white,
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: _CircleIconButton(
                icon: Icons.arrow_back_ios_new_rounded,
                onPressed: () => Navigator.maybePop(context),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: AnimatedBuilder(
                  animation: FavoritesStore.instance,
                  builder: (context, _) {
                    final isFavorite = FavoritesStore.instance.contains(
                      favoriteListing.id,
                    );
                    return _CircleIconButton(
                      icon: isFavorite ? Icons.favorite : Icons.favorite_border,
                      iconColor: isFavorite
                          ? const Color(0xFFE16B6B)
                          : const Color(0xFF4F5C69),
                      onPressed: () =>
                          FavoritesStore.instance.toggle(favoriteListing),
                    );
                  },
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => const ColoredBox(
                      color: Color(0xFFE8EDF3),
                      child: Center(
                        child: Icon(
                          Icons.apartment_rounded,
                          color: Color(0xFF3976CC),
                          size: 72,
                        ),
                      ),
                    ),
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0x660F1720),
                          Colors.transparent,
                          Color(0x250F1720),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 18,
                    top: 74,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 11,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF08A3C),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        category,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xFF20242A),
                      fontSize: 20,
                      height: 1.15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: Color(0xFF8795A3),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          location,
                          style: const TextStyle(
                            color: Color(0xFF8795A3),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      if (rating != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0F4F8),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.star_rounded,
                                size: 15,
                                color: Color(0xFFF2B94B),
                              ),
                              const SizedBox(width: 3),
                              Text(
                                rating!,
                                style: const TextStyle(
                                  color: Color(0xFF596777),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              if (reviews != null)
                                Text(
                                  ' $reviews',
                                  style: const TextStyle(
                                    color: Color(0xFF98A3AE),
                                    fontSize: 9,
                                  ),
                                ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 13,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x100F1C2E),
                          blurRadius: 12,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            price,
                            style: const TextStyle(
                              color: Color(0xFF2D65A1),
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        if (bedrooms != null)
                          _FactItem(
                            icon: Icons.bed_outlined,
                            label:
                                '$bedrooms ${bedrooms == 1 ? 'chambre' : 'chambres'}',
                          ),
                        if (area != null) ...[
                          const SizedBox(width: 10),
                          _FactItem(
                            icon: Icons.square_foot_rounded,
                            label: '$area m²',
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Property Description',
                    style: TextStyle(
                      color: Color(0xFF252B33),
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: const TextStyle(
                      color: Color(0xFF8A95A1),
                      height: 1.55,
                      fontSize: 11,
                    ),
                  ),
                  if (photoCredit != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      photoCredit!,
                      style: const TextStyle(
                        color: Color(0xFFABB4BC),
                        fontSize: 9,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({
    required this.icon,
    required this.onPressed,
    this.iconColor,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Color(0x1A17212B),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, size: 17, color: iconColor ?? const Color(0xFF20272F)),
        padding: EdgeInsets.zero,
      ),
    );
  }
}

class _FactItem extends StatelessWidget {
  const _FactItem({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: const Color(0xFF3976CC)),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF697784),
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
