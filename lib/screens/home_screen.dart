import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../favorites_store.dart';
import '../user_profile_store.dart';
import 'add_listing_screen.dart';
import 'favorites_screen.dart';
import 'listing_details_screen.dart';
import 'map_screen.dart';
import 'messages_screen.dart';
import 'profile_screen.dart';

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
  static const _initialListingCount = 6;
  static const _listings = [
    _PropertyListing(
      category: 'Vente',
      image: 'lib/screens/images/appartement.jpg',
      price: '250 000 DT',
      title: 'Appartement S+2',
      location: 'À La Marsa',
      rating: '4.8',
      reviews: '(120 avis)',
      bedrooms: 2,
      area: 120,
      description: 'Appartement S+2 de 120 m² situé à La Marsa.',
    ),
    _PropertyListing(
      category: 'Vente',
      image: 'lib/screens/images/photo5.webp',
      price: '680 000 DT',
      title: 'Villa avec piscine',
      location: 'À Gammarth',
      rating: '4.9',
      reviews: '(86 avis)',
      description: 'Villa avec piscine située à Gammarth.',
    ),
    _PropertyListing(
      category: 'Location',
      image: 'lib/screens/images/photo4.webp',
      price: '3 200 DT / mois',
      title: 'Villa familiale avec jardin',
      location: 'À La Soukra',
      rating: '4.7',
      reviews: '(42 avis)',
      description: 'Villa familiale avec jardin située à La Soukra.',
    ),
    _PropertyListing(
      category: 'Neuf',
      image: 'lib/screens/images/photo3.webp',
      price: '425 000 DT',
      title: 'Résidence neuve S+3',
      location: 'Aux Jardins de Carthage',
      rating: '4.9',
      reviews: '(31 avis)',
      description: 'Résidence neuve S+3 située aux Jardins de Carthage.',
    ),
    _PropertyListing(
      category: 'Terrain',
      image: 'lib/screens/images/photo2.png',
      price: '125 000 DT',
      title: 'Parcelle agricole de 2 hectares',
      location: 'À Béja',
      rating: '4.8',
      reviews: '(18 avis)',
      description: 'Parcelle agricole de 2 hectares située à Béja.',
    ),
    _PropertyListing(
      category: 'Terrain',
      image: 'lib/screens/images/photo1.png',
      price: '280 000 DT',
      title: 'Terrain avec vue panoramique',
      location: 'À Aïn Draham',
      rating: '4.9',
      reviews: '(12 avis)',
      description: 'Terrain avec vue panoramique situé à Aïn Draham.',
    ),
    _PropertyListing(
      category: 'Vente',
      image: 'lib/screens/images/appartement_2.png',
      price: '390 000 DT',
      title: 'Appartement moderne S+3',
      location: 'À El Menzah',
      rating: '4.7',
      reviews: '(54 avis)',
      bedrooms: 3,
      area: 145,
      description: 'Appartement moderne S+3 situé à El Menzah.',
    ),
    _PropertyListing(
      category: 'Location',
      image: 'lib/screens/images/appartement.jpg',
      price: '1 800 DT / mois',
      title: 'Studio meublé en centre-ville',
      location: 'À Tunis Centre',
      rating: '4.6',
      reviews: '(27 avis)',
      bedrooms: 1,
      area: 55,
      description: 'Studio meublé proposé à la location à Tunis Centre.',
    ),
    _PropertyListing(
      category: 'Neuf',
      image: 'lib/screens/images/appartement_1.jpg',
      price: '510 000 DT',
      title: 'Appartement neuf S+2',
      location: 'À La Soukra',
      rating: '4.8',
      reviews: '(19 avis)',
      bedrooms: 2,
      area: 110,
      description: 'Appartement neuf S+2 situé à La Soukra.',
    ),
    _PropertyListing(
      category: 'Terrain',
      image: 'lib/screens/images/photo7.png',
      price: '210 000 DT',
      title: 'Terrain constructible',
      location: 'À Borj Cedria',
      rating: '4.7',
      reviews: '(15 avis)',
      description: 'Terrain constructible situé à Borj Cedria.',
    ),
  ];

  String? _selectedCategory;
  bool _showAllListings = false;
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
    final filteredListings = _listings
        .where(
          (listing) =>
              _selectedCategory == null ||
              listing.category == _selectedCategory,
        )
        .toList();
    final visibleListings = _selectedCategory == null && !_showAllListings
        ? filteredListings.take(_initialListingCount).toList()
        : filteredListings;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color(0x140F1C2E),
              blurRadius: 16,
              offset: Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 66,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.home_filled, 'Home'),
                _buildNavItem(1, Icons.favorite_border, 'Favoris'),
                _buildNavItem(2, Icons.add_circle_outline, 'Ajouter'),
                _buildNavItem(3, Icons.chat_bubble_outline, 'Messages'),
                _buildNavItem(4, Icons.person_outline, 'Profil'),
              ],
            ),
          ),
        ),
      ),
      body: _currentIndex == 0
          ? SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 22,
                          backgroundColor: Color(0xFFE8EEF5),
                          child: Icon(
                            Icons.person_rounded,
                            color: Color(0xFF58718D),
                            size: 26,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AnimatedBuilder(
                                animation: UserProfileStore.instance,
                                builder: (context, _) {
                                  final name =
                                      UserProfileStore.instance.current?.name ??
                                      'Utilisateur';
                                  return Text(
                                    'Hello, $name!',
                                    style: const TextStyle(
                                      color: Color(0xFF1D2430),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 2),
                              Semantics(
                                button: true,
                                label:
                                    'Choisir la localisation, $_selectedLocation',
                                child: InkWell(
                                  onTap: _isLocating ? null : _selectLocation,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (_isLocating)
                                        const SizedBox(
                                          width: 12,
                                          height: 12,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        )
                                      else
                                        Icon(
                                          Icons.location_on,
                                          size: 12,
                                          color: Colors.blueGrey[400],
                                        ),
                                      const SizedBox(width: 2),
                                      Flexible(
                                        child: Text(
                                          _isLocating
                                              ? 'Localisation…'
                                              : _selectedLocation,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: Colors.blueGrey[400],
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      if (!_isLocating)
                                        const Icon(
                                          Icons.keyboard_arrow_down,
                                          size: 16,
                                          color: Color(0xFF8FA0AE),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x140F1C2E),
                                blurRadius: 10,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.notifications_none_rounded,
                              size: 20,
                              color: Color(0xFF2E3A48),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      onTapOutside: (_) =>
                          FocusManager.instance.primaryFocus?.unfocus(),
                      decoration: InputDecoration(
                        hintText: 'Search',
                        hintStyle: const TextStyle(
                          color: Color(0xFF9BA7B3),
                          fontSize: 13,
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Color(0xFF8B99A7),
                          size: 21,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildCategory(
                          Icons.home_outlined,
                          'Vente',
                          const Color(0xFFE8F0FF),
                          const Color(0xFF3976CC),
                        ),
                        _buildCategory(
                          Icons.key_outlined,
                          'Location',
                          const Color(0xFFFFF0E2),
                          const Color(0xFFE58A42),
                        ),
                        _buildCategory(
                          Icons.apartment_outlined,
                          'Neuf',
                          const Color(0xFFE7F3FC),
                          const Color(0xFF5C98C7),
                        ),
                        _buildCategory(
                          Icons.park_outlined,
                          'Terrain',
                          const Color(0xFFE8F4EA),
                          const Color(0xFF61A56D),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      height: 128,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        image: const DecorationImage(
                          image: AssetImage(
                            'lib/screens/images/villa_landscape.png',
                          ),
                          fit: BoxFit.cover,
                          alignment: Alignment.center,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x1A101820),
                            blurRadius: 12,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          gradient: const LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Color(0xC9121C27),
                              Color(0x330F1A24),
                              Colors.transparent,
                            ],
                          ),
                        ),
                        padding: const EdgeInsets.all(16),
                        alignment: Alignment.centerLeft,
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Modern Luxury',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            SizedBox(height: 3),
                            Text(
                              'Brand New & Exquisite',
                              style: TextStyle(
                                color: Color(0xFFE7EDF2),
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Exclusive',
                              style: TextStyle(
                                color: Color(0xFFF3B65F),
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _selectedCategory == null
                              ? 'Featured Properties'
                              : 'Annonces $_selectedCategory',
                          style: const TextStyle(
                            color: Color(0xFF20242A),
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        TextButton(
                          onPressed: _selectedCategory == null
                              ? () => setState(
                                  () => _showAllListings = !_showAllListings,
                                )
                              : () => setState(() => _selectedCategory = null),
                          style: TextButton.styleFrom(
                            minimumSize: Size.zero,
                            padding: EdgeInsets.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            _selectedCategory == null
                                ? _showAllListings
                                      ? 'Voir moins'
                                      : 'Voir tout >'
                                : 'Tout voir',
                            style: const TextStyle(
                              color: Color(0xFF2F74B8),
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (visibleListings.isNotEmpty)
                      _selectedCategory != null || _showAllListings
                          ? LayoutBuilder(
                              builder: (context, constraints) {
                                final cardWidth =
                                    (constraints.maxWidth - 12) / 2;
                                return Wrap(
                                  spacing: 12,
                                  runSpacing: 12,
                                  children: visibleListings
                                      .map(
                                        (listing) => SizedBox(
                                          width: cardWidth,
                                          height: 188,
                                          child: _buildListingCard(listing),
                                        ),
                                      )
                                      .toList(),
                                );
                              },
                            )
                          : SizedBox(
                              height: 188,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: visibleListings.length,
                                separatorBuilder: (_, _) =>
                                    const SizedBox(width: 12),
                                itemBuilder: (_, index) => SizedBox(
                                  width: 190,
                                  child: _buildListingCard(
                                    visibleListings[index],
                                  ),
                                ),
                              ),
                            )
                    else
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 32),
                          child: Text(
                            'Aucune annonce disponible pour cette catégorie.',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            )
          : _pages[_currentIndex - 1],
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _currentIndex == index;
    return InkWell(
      onTap: () => setState(() => _currentIndex = index),
      borderRadius: BorderRadius.circular(18),
      child: SizedBox(
        width: 58,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 22,
              color: isSelected
                  ? const Color(0xFF3976CC)
                  : const Color(0xFF98A3AF),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: isSelected
                    ? const Color(0xFF3976CC)
                    : const Color(0xFF98A3AF),
                fontSize: 8,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListingCard(_PropertyListing listing) {
    final favoriteListing = PropertyListing(
      id: 'home-${listing.title}',
      title: listing.title,
      price: listing.price,
      location: listing.location,
      bedrooms: listing.bedrooms ?? 0,
      area: listing.area ?? 0,
    );

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x140F1C2E),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => ListingDetailsScreen(
                title: listing.title,
                price: listing.price,
                location: listing.location,
                category: listing.category,
                imagePath: listing.image,
                description: listing.description,
                rating: listing.rating,
                reviews: listing.reviews,
                bedrooms: listing.bedrooms,
                area: listing.area,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(14),
                    ),
                    child: SizedBox(
                      height: 102,
                      width: double.infinity,
                      child: Image.asset(listing.image, fit: BoxFit.cover),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: AnimatedBuilder(
                      animation: FavoritesStore.instance,
                      builder: (context, _) {
                        final isFavorite = FavoritesStore.instance.contains(
                          favoriteListing.id,
                        );
                        return Material(
                          color: Colors.white,
                          shape: const CircleBorder(),
                          elevation: 1,
                          child: IconButton(
                            key: ValueKey('favorite-${listing.title}'),
                            onPressed: () =>
                                FavoritesStore.instance.toggle(favoriteListing),
                            tooltip: isFavorite
                                ? 'Retirer des favoris'
                                : 'Ajouter aux favoris',
                            icon: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isFavorite
                                  ? const Color(0xFFE16B6B)
                                  : const Color(0xFF647487),
                              size: 17,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 34,
                              minHeight: 34,
                            ),
                            padding: EdgeInsets.zero,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      listing.price,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF2D65A1),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      listing.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF242B33),
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          color: Color(0xFF8A99A7),
                          size: 12,
                        ),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            listing.location,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color(0xFF8A99A7),
                              fontSize: 9,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
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
      child: SizedBox(
        width: 72,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {
            setState(() {
              _selectedCategory = isSelected ? null : title;
            });
          },
          child: Column(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(14),
                  border: isSelected
                      ? Border.all(color: iconColor, width: 2)
                      : null,
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x100F1C2E),
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Icon(icon, color: iconColor, size: 25),
              ),
              const SizedBox(height: 6),
              Text(
                title,
                style: TextStyle(
                  color: isSelected ? iconColor : const Color(0xFF536170),
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PropertyListing {
  const _PropertyListing({
    required this.category,
    required this.image,
    required this.price,
    required this.title,
    required this.location,
    required this.rating,
    required this.reviews,
    required this.description,
    this.bedrooms,
    this.area,
  });

  final String category;
  final String image;
  final String price;
  final String title;
  final String location;
  final String rating;
  final String reviews;
  final String description;
  final int? bedrooms;
  final int? area;
}
