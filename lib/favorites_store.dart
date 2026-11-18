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
  });

  final String id;
  final String title;
  final String price;
  final String location;
  final int bedrooms;
  final int area;

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

  final Set<String> _favoriteIds = {PropertyListing.sample.id};

  List<PropertyListing> get favorites {
    if (_favoriteIds.contains(PropertyListing.sample.id)) {
      return const [PropertyListing.sample];
    }
    return const [];
  }

  bool contains(String listingId) => _favoriteIds.contains(listingId);

  void toggle(PropertyListing listing) {
    if (!_favoriteIds.add(listing.id)) {
      _favoriteIds.remove(listing.id);
    }
    notifyListeners();
  }
}
