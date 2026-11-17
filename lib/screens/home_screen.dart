import 'dart:async';

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

import 'map_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const _currentLocationOption = '__current_location__';
  static const _mapLocationOption = '__map_location__';
  static const _locations = [
    'Tunis',
    'Ariana',
    'Ben Arous',
    'Manouba',
    'Nabeul',
    'Sousse',
    'Monastir',
    'Sfax',
  ];
  static const _listings = [
    _PropertyListing(
      category: 'Vente',
      image: 'lib/screens/images/villa_landscape.jpg',
      price: '250 000 DT',
      title: 'Appartement S+2',
      location: 'À La Marsa',
      rating: '4.8',
      reviews: '(120 avis)',
    ),
    _PropertyListing(
      category: 'Vente',
      image: 'lib/screens/images/villa.jpeg',
      price: '680 000 DT',
      title: 'Villa avec piscine',
      location: 'À Gammarth',
      rating: '4.9',
      reviews: '(86 avis)',
    ),
    _PropertyListing(
      category: 'Location',
      image: 'lib/screens/images/villa.jpeg',
      price: '3 200 DT / mois',
      title: 'Villa familiale avec jardin',
      location: 'À La Soukra',
      rating: '4.7',
      reviews: '(42 avis)',
    ),
    _PropertyListing(
      category: 'Neuf',
      image: 'lib/screens/images/immo.jpeg',
      price: '425 000 DT',
      title: 'Résidence neuve S+3',
      location: 'Aux Jardins de Carthage',
      rating: '4.9',
      reviews: '(31 avis)',
    ),
  ];

  String? _selectedCategory;
  String _selectedLocation = 'Tunis';
  String? _currentCoordinates;
  bool _isLocating = false;

  Future<void> _selectLocation() async {
    final location = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (context) => SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.65,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 8),
                child: Text(
                  'Choisir une ville',
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
                    ..._locations.map(
                      (location) => ListTile(
                        leading: const Icon(
                          Icons.location_on_outlined,
                          color: Color(0xFF4B2A8B),
                        ),
                        title: Text(location),
                        trailing: location == _selectedLocation
                            ? const Icon(Icons.check, color: Color(0xFF4B2A8B))
                            : null,
                        onTap: () => Navigator.pop(context, location),
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
        setState(() {
          _selectedLocation = 'Position sur la carte';
          _currentCoordinates =
              '${position.latitude.toStringAsFixed(5)}, '
              '${position.longitude.toStringAsFixed(5)}';
        });
      }
    } else if (location != null && mounted) {
      setState(() {
        _selectedLocation = location;
        _currentCoordinates = null;
      });
    }
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

    return switch (_selectedLocation) {
      'Ariana' => const LatLng(36.8625, 10.1956),
      'Ben Arous' => const LatLng(36.7531, 10.2189),
      'Manouba' => const LatLng(36.8081, 10.0972),
      'Nabeul' => const LatLng(36.4513, 10.7357),
      'Sousse' => const LatLng(35.8256, 10.63699),
      'Monastir' => const LatLng(35.777, 10.8262),
      'Sfax' => const LatLng(34.7406, 10.7603),
      _ => const LatLng(36.8065, 10.1815),
    };
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
      setState(() {
        _selectedLocation = 'Ma position';
        _currentCoordinates =
            '${position.latitude.toStringAsFixed(5)}, '
            '${position.longitude.toStringAsFixed(5)}';
      });
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

    return Scaffold(
      // Barre de navigation inférieure
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF4B2A8B),
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Favoris',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle, size: 40, color: Color(0xFF4B2A8B)),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message_outlined),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profil',
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // En-tête (Localisation et Notifications)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Semantics(
                    button: true,
                    label: 'Choisir la ville, $_selectedLocation',
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: _selectLocation,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            _isLocating
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Color(0xFF4B2A8B),
                                    ),
                                  )
                                : const Icon(
                                    Icons.location_on,
                                    color: Color(0xFF4B2A8B),
                                    size: 20,
                                  ),
                            const SizedBox(width: 5),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _selectedLocation,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                if (_currentCoordinates != null)
                                  Text(
                                    _currentCoordinates!,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 11,
                                    ),
                                  ),
                              ],
                            ),
                            const Icon(Icons.keyboard_arrow_down),
                          ],
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.notifications_none,
                      color: Color(0xFF4B2A8B),
                    ),
                    onPressed: () {},
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

              // Bannière Promotionnelle (Remplacer par Image.asset)
              Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: const DecorationImage(
                    image: AssetImage('lib/screens/images/villa_landscape.jpg'),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Color(0x66000000),
                      BlendMode.darken,
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Trouvez la maison\nde vos rêves',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF4B2A8B),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text('Découvrir →'),
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
                        : () => setState(() => _selectedCategory = null),
                    child: Text(
                      _selectedCategory == null ? 'Voir tout >' : 'Tout voir',
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
      ),
    );
  }

  Widget _buildListingCard(_PropertyListing listing) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
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
              const Positioned(
                top: 10,
                right: 10,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.favorite, color: Colors.red),
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
                  ],
                ),
              ],
            ),
          ),
        ],
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
    required this.category,
    required this.image,
    required this.price,
    required this.title,
    required this.location,
    required this.rating,
    required this.reviews,
  });

  final String category;
  final String image;
  final String price;
  final String title;
  final String location;
  final String rating;
  final String reviews;
}
