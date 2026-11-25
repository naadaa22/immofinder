import 'package:flutter/foundation.dart';

@immutable
class PropertyListing {
  const PropertyListing({
    required this.id,
    required this.title,
    required this.price,
    required this.location,
    required this.bedrooms,
    required this.area,
    this.ownerId = 'ahmed@immofinder.tn',
    this.ownerName = 'Ahmed Ben Ali',
    this.image = 'lib/screens/images/immo.jpeg',
    this.category = 'Vente',
    this.rating,
    this.reviews,
    this.description,
  });

  final String id;
  final String title;
  final String price;
  final String location;
  final int bedrooms;
  final int area;
  final String ownerId;
  final String ownerName;
  final String image;
  final String category;
  final String? rating;
  final String? reviews;
  final String? description;

  static const sample = PropertyListing(
    id: 'marsa-apartment-s2',
    title: 'Appartement S+2',
    price: '250 000 DT',
    location: 'La Marsa, Tunis',
    bedrooms: 2,
    area: 120,
  );
}

class FavoritesStore extends ChangeNotifier {
  FavoritesStore._();

  static final FavoritesStore instance = FavoritesStore._();

  final Map<String, PropertyListing> _favorites = {
    PropertyListing.sample.id: PropertyListing.sample,
  };

  List<PropertyListing> get favorites => List.unmodifiable(_favorites.values);

  bool contains(String listingId) => _favorites.containsKey(listingId);

  void toggle(PropertyListing listing) {
    if (_favorites.containsKey(listing.id)) {
      _favorites.remove(listing.id);
    } else {
      _favorites[listing.id] = listing;
    }
    notifyListeners();
  }
}
