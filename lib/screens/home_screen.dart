import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../favorites_store.dart';
import '../language_store.dart';
import '../notification_store.dart';
import 'add_listing_screen.dart';
import 'favorites_screen.dart';
import 'map_screen.dart';
import 'messages_screen.dart';
import 'listing_detail_screen.dart';
import 'notifications_screen.dart';
import 'profile_screen.dart';

class _ProfileBottomNavigation extends StatelessWidget {
  const _ProfileBottomNavigation({
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    const purple = Color(0xFF4B2A8B);
    final items = [
      (Icons.home_outlined, LanguageStore.instance.text('home')),
      (Icons.favorite_border, LanguageStore.instance.text('favorites')),
      (Icons.message_outlined, LanguageStore.instance.text('messages')),
      (Icons.person_outline, LanguageStore.instance.text('profile')),
    ];

    return Container(
      height: 82,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            _BottomNavItem(
              icon: items[0].$1,
              label: items[0].$2,
              selected: currentIndex == 0,
              onTap: () => onTap(0),
            ),
            _BottomNavItem(
              icon: items[1].$1,
              label: items[1].$2,
              selected: currentIndex == 1,
              onTap: () => onTap(1),
            ),
            Expanded(
              child: Center(
                child: InkResponse(
                  onTap: () => onTap(2),
                  radius: 38,
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: const BoxDecoration(
                      color: purple,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 34),
                  ),
                ),
              ),
            ),
            _BottomNavItem(
              icon: items[2].$1,
              label: items[2].$2,
              selected: currentIndex == 3,
              onTap: () => onTap(3),
            ),
            _BottomNavItem(
              icon: items[3].$1,
              label: items[3].$2,
              selected: currentIndex == 4,
              onTap: () => onTap(4),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  const _BottomNavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const purple = Color(0xFF4B2A8B);
    final color = selected ? purple : const Color(0xFF77777D);
    return Expanded(
      child: InkResponse(
        onTap: onTap,
        radius: 34,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 29),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    const FavoritesScreen(),
    const AddListingScreen(),
    const MessagesScreen(),
    const ProfileScreen(),
  ];

  static const _currentLocationOption = '__current_location__';
  static const _mapLocationOption = '__map_location__';
  static const _listings = [
    _PropertyListing(
      id: 'marsa-apartment-s2',
      category: 'Vente',
      image: 'lib/screens/images/villa_landscape.jpg',
      price: '250 000 DT',
      title: 'Appartement S+2',
      location: 'À La Marsa',
      rating: '4.8',
      reviews: '(120 avis)',
      ownerName: 'Ahmed Ben Ali',
      ownerId: 'ahmed@immofinder.tn',
      bedrooms: 2,
      area: 120,
      description: 'Appartement lumineux avec cuisine équipée, balcon et place de parking.',
    ),
    _PropertyListing(
      id: 'villa-gammarth',
      category: 'Vente',
      image: 'lib/screens/images/villa1.jpg',
      price: '680 000 DT',
      title: 'Villa avec piscine',
      location: 'À Gammarth',
      rating: '4.9',
      reviews: '(86 avis)',
      ownerName: 'Meriem Trabelsi',
      ownerId: 'meriem@immofinder.tn',
      bedrooms: 4,
      area: 260,
      description: 'Villa moderne avec piscine, jardin paysager et terrasse ensoleillée.',
    ),
    _PropertyListing(
      id: 'villa-soukra',
      category: 'Location',
      image: 'lib/screens/images/villa2.jpg',
      price: '3 200 DT / mois',
      title: 'Villa familiale avec jardin',
      location: 'À La Soukra',
      rating: '4.7',
      reviews: '(42 avis)',
      ownerName: 'Youssef Gharbi',
      ownerId: 'youssef@immofinder.tn',
      bedrooms: 3,
      area: 180,
      description: 'Villa familiale avec jardin, garage fermé et espaces de vie généreux.',
    ),
    _PropertyListing(
      id: 'residence-carthage',
      category: 'Neuf',
      image: 'lib/screens/images/villa3.jpg',
      price: '425 000 DT',
      title: 'Résidence neuve S+3',
      location: 'Aux Jardins de Carthage',
      rating: '4.9',
      reviews: '(31 avis)',
      ownerName: 'Ines Mejri',
      ownerId: 'ines@immofinder.tn',
      bedrooms: 3,
      area: 145,
      description: 'Résidence neuve avec finitions modernes, ascenseur et accès sécurisé.',
    ),
    _PropertyListing(
      id: 'terrain-beja',
      category: 'Terrain',
      image: 'lib/screens/images/terrain_agricole.jpg',
      price: '125 000 DT',
      title: 'Parcelle agricole de 2 hectares',
      location: 'À Béja',
      rating: '4.8',
      reviews: '(18 avis)',
      ownerName: 'Slim Bouazizi',
      ownerId: 'slim@immofinder.tn',
      photoCredit: 'Photo illustrative · Unsplash',
      area: 2000,
      description: 'Parcelle agricole de deux hectares avec accès routier et eau disponible.',
    ),
    _PropertyListing(
      id: 'terrain-ain-draham',
      category: 'Terrain',
      image: 'lib/screens/images/terrain_panoramique.jpg',
      price: '280 000 DT',
      title: 'Terrain avec vue panoramique',
      location: 'À Aïn Draham',
      rating: '4.9',
      reviews: '(12 avis)',
      ownerName: 'Nadia Kacem',
      ownerId: 'nadia@immofinder.tn',
      photoCredit: 'Photo illustrative · Unsplash',
      area: 1500,
      description: 'Terrain dégagé avec vue panoramique, proche des commodités et des routes.',
    ),
  ];

  String? _selectedCategory;
  String _selectedLocation = 'Localisation';
  String? _currentCoordinates;
  bool _isLocating = false;

  Future<void> _selectLocation() async {
    final location = await showDialog<String>(
      context: context,
      builder: (context) => SafeArea(
        child: Dialog(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 8),
                  child: Text(
                    'Choisir une localisation',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: [
                      ListTile(
                        leading: const Icon(
                          Icons.my_location,
                          color: Color(0xFF4B2A8B),
                        ),
                        title: const Text('Utiliser ma position actuelle'),
                        onTap: () =>
                            Navigator.pop(context, _currentLocationOption),
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.map_outlined,
                          color: Color(0xFF4B2A8B),
                        ),
                        title: const Text('Choisir sur la carte'),
                        onTap: () => Navigator.pop(context, _mapLocationOption),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (location == _currentLocationOption) {
      await _useCurrentLocation();
    } else if (location == _mapLocationOption && mounted) {
      final position = await Navigator.push<LatLng>(
        context,
        MaterialPageRoute(
          builder: (_) => MapScreen(initialCenter: _initialMapPosition),
        ),
      );

      if (position != null && mounted) {
        setState(() => _isLocating = true);
        try {
          await _setLocationFromCoordinates(
            latitude: position.latitude,
            longitude: position.longitude,
            fallbackLabel: 'Position sur la carte',
          );
        } finally {
          if (mounted) {
            setState(() => _isLocating = false);
          }
        }
      }
    }
  }

  Future<void> _setLocationFromCoordinates({
    required double latitude,
    required double longitude,
    required String fallbackLabel,
  }) async {
    final locationName = await _resolveLocationName(latitude, longitude);
    if (!mounted) return;

    setState(() {
      _selectedLocation = locationName ?? fallbackLabel;
      _currentCoordinates =
          '${latitude.toStringAsFixed(5)}, ${longitude.toStringAsFixed(5)}';
    });
  }

  Future<String?> _resolveLocationName(
    double latitude,
    double longitude,
  ) async {
    if (kIsWeb ||
        !{
          TargetPlatform.android,
          TargetPlatform.iOS,
          TargetPlatform.macOS,
        }.contains(defaultTargetPlatform)) {
      _showLocationMessage(
        'Le nom du lieu est disponible sur Android, iOS et macOS.',
      );
      return null;
    }

    try {
      final placemarks = await Geocoding(locale: const Locale('fr', 'FR'))
          .placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        for (final name in [
          placemark.locality,
          placemark.subAdministrativeArea,
          placemark.administrativeArea,
        ]) {
          if (name != null && name.trim().isNotEmpty) {
            return name.trim();
          }
        }
      }
    } on PlatformException {
      _showLocationMessage(
        'Impossible de déterminer le nom du lieu. Les coordonnées sont '
        'conservées.',
      );
      return null;
    }

    _showLocationMessage(
      'Nom du lieu introuvable. Les coordonnées sont conservées.',
    );
    return null;
  }

  LatLng get _initialMapPosition {
    final coordinates = _currentCoordinates?.split(',');
    if (coordinates != null && coordinates.length == 2) {
      final latitude = double.tryParse(coordinates[0].trim());
      final longitude = double.tryParse(coordinates[1].trim());
      if (latitude != null && longitude != null) {
        return LatLng(latitude, longitude);
      }
    }

    return const LatLng(36.8065, 10.1815);
  }

  Future<void> _useCurrentLocation() async {
    setState(() => _isLocating = true);

    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        _showLocationMessage(
          'Activez la localisation de votre appareil puis réessayez.',
        );
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        _showLocationMessage(
          'Autorisez l’accès à la localisation dans les paramètres de '
          'l’application ou du navigateur.',
        );
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 15),
        ),
      );

      if (!mounted) return;
      await _setLocationFromCoordinates(
        latitude: position.latitude,
        longitude: position.longitude,
        fallbackLabel: 'Ma position',
      );
    } on TimeoutException {
      _showLocationMessage(
        'La localisation a pris trop de temps. Vérifiez le signal GPS.',
      );
    } on LocationServiceDisabledException {
      _showLocationMessage(
        'Activez la localisation de votre appareil puis réessayez.',
      );
    } finally {
      if (mounted) {
        setState(() => _isLocating = false);
      }
    }
  }

  void _showLocationMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final visibleListings = _listings
        .where(
          (listing) =>
              _selectedCategory == null ||
              listing.category == _selectedCategory,
        )
        .toList();

    return AnimatedBuilder(
      animation: LanguageStore.instance,
      builder: (context, _) => Scaffold(
        // Barre de navigation inférieure
        bottomNavigationBar: _ProfileBottomNavigation(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
        ),
        body: _currentIndex == 0
            ? SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // En-tête (Localisation et Notifications)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Semantics(
                              button: true,
                              label:
                                  'Choisir la localisation, $_selectedLocation',
                              child: Material(
                                color: const Color(0xFFF3EFFA),
                                borderRadius: BorderRadius.circular(14),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(14),
                                  onTap: _selectLocation,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 10,
                                    ),
                                    child: Row(
                                      children: [
                                        _isLocating
                                            ? const SizedBox(
                                                width: 20,
                                                height: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                      color: Color(0xFF4B2A8B),
                                                    ),
                                              )
                                            : const Icon(
                                                Icons.location_on,
                                                color: Color(0xFF4B2A8B),
                                                size: 24,
                                              ),
                                        const SizedBox(width: 8),
                                        Flexible(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                _selectedLocation,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                ),
                                              ),
                                              if (_currentCoordinates != null)
                                                Text(
                                                  _currentCoordinates!,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontSize: 13,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                        const Icon(
                                          Icons.keyboard_arrow_down,
                                          size: 24,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          AnimatedBuilder(
                            animation: NotificationStore.instance,
                            builder: (context, _) {
                              return Material(
                                color: const Color(0xFFF1ECFA),
                                shape: const CircleBorder(),
                                child: IconButton(
                                  tooltip: 'Notifications',
                                  icon: const Icon(
                                    Icons.notifications_none_rounded,
                                    color: Color(0xFF4B2A8B),
                                    size: 24,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute<void>(
                                        builder: (_) =>
                                            const NotificationsScreen(),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Barre de recherche
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Rechercher un bien...',
                          prefixIcon: const Icon(Icons.search),
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Catégories
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildCategory(
                            Icons.home,
                            'Vente',
                            const Color(0xFFE8E2FF),
                            const Color(0xFF4B2A8B),
                          ),
                          _buildCategory(
                            Icons.key,
                            'Location',
                            const Color(0xFFFFF3E0),
                            Colors.orange,
                          ),
                          _buildCategory(
                            Icons.apartment,
                            'Neuf',
                            const Color(0xFFE3F2FD),
                            Colors.blue,
                          ),
                          _buildCategory(
                            Icons.park,
                            'Terrain',
                            const Color(0xFFE8F5E9),
                            Colors.green,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Bannière Promotionnelle
                      Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFF4B2A8B),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    16,
                                    16,
                                    8,
                                    16,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Trouvez la maison\nde vos rêves',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Spacer(),
                                      ElevatedButton(
                                        onPressed: () {},
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          foregroundColor: const Color(
                                            0xFF4B2A8B,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                        ),
                                        child: const Text('Découvrir →'),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  'lib/screens/images/villa5.jpg',
                                  width: 105,
                                  height: 118,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Titre Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _selectedCategory == null
                                ? 'Annonces populaires'
                                : 'Annonces $_selectedCategory',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: _selectedCategory == null
                                ? () {}
                                : () =>
                                      setState(() => _selectedCategory = null),
                            child: Text(
                              _selectedCategory == null
                                  ? 'Voir tout >'
                                  : 'Tout voir',
                              style: const TextStyle(color: Color(0xFF4B2A8B)),
                            ),
                          ),
                        ],
                      ),

                      ...visibleListings.map(_buildListingCard),
                      if (visibleListings.isEmpty)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 32),
                            child: Text(
                              'Aucune annonce disponible pour cette catégorie.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              )
            : _pages[_currentIndex - 1],
      ),
    );
  }

  Widget _buildListingCard(_PropertyListing listing) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      color: Colors.white,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: AspectRatio(
                    aspectRatio: 12 / 5,
                    child: Image.asset(listing.image, fit: BoxFit.cover),
                  ),
                ),
                if (listing.photoCredit != null)
                  Positioned(
                    left: 8,
                    bottom: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        listing.photoCredit!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: AnimatedBuilder(
                    animation: FavoritesStore.instance,
                    builder: (context, _) {
                      final isFavorite = FavoritesStore.instance.contains(
                        listing.id,
                      );
                      return Material(
                        color: Colors.white,
                        shape: const CircleBorder(),
                        child: IconButton(
                          tooltip: isFavorite
                              ? LanguageStore.instance.text('remove_favorite')
                              : LanguageStore.instance.text('add_favorite'),
                          onPressed: () {
                            FavoritesStore.instance.toggle(
                              PropertyListing(
                                id: listing.id,
                                title: listing.title,
                                price: listing.price,
                                location: listing.location,
                                bedrooms: listing.bedrooms ?? 0,
                                area: listing.area ?? 0,
                                ownerId: listing.ownerId,
                                ownerName: listing.ownerName,
                                image: listing.image,
                                category: listing.category,
                                rating: listing.rating,
                                reviews: listing.reviews,
                                description: listing.description,
                              ),
                            );
                          },
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.red : Colors.black54,
                          ),
                        ),
                      );
                    },
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
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4B2A8B),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    listing.title,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    listing.location,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        listing.rating,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        listing.reviews,
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                      const Spacer(),
                      FilledButton.icon(
                        onPressed: () {
                          MessagesScreen.openConversation(
                            context,
                            otherUserId: listing.ownerId,
                            otherUserName: listing.ownerName,
                            property:
                                '${listing.title} · ${listing.location.replaceFirst('À ', '')}',
                          );
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF4B2A8B),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        icon: const Icon(Icons.chat_bubble_outline, size: 16),
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

  // Widget pour les catégories (Vente, Location, etc.)
  Widget _buildCategory(
    IconData icon,
    String title,
    Color bgColor,
    Color iconColor,
  ) {
    final isSelected = _selectedCategory == title;

    return Semantics(
      button: true,
      selected: isSelected,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          setState(() {
            _selectedCategory = isSelected ? null : title;
          });
        },
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(16),
                border: isSelected
                    ? Border.all(color: iconColor, width: 2)
                    : null,
              ),
              child: Icon(icon, color: iconColor, size: 28),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

class _PropertyListing {
  const _PropertyListing({
    required this.id,
    required this.category,
    required this.image,
    required this.price,
    required this.title,
    required this.location,
    required this.rating,
    required this.reviews,
    required this.ownerName,
    required this.ownerId,
    this.photoCredit,
    this.bedrooms,
    this.area,
    this.description,
  });

  final String id;
  final String category;
  final String image;
  final String price;
  final String title;
  final String location;
  final String rating;
  final String reviews;
  final String ownerName;
  final String ownerId;
  final String? photoCredit;
  final int? bedrooms;
  final int? area;
  final String? description;
}
