import 'package:flutter/material.dart';
import '../models/housing.dart';

class HousingProvider extends ChangeNotifier {
  final List<Housing> _listings = [
    Housing(
      id: 'h1',
      title: 'Modern Studio near ASU',
      price: 250,
      lat: 32.0100,
      lng: 35.8443,
      rating: 4.6,
      providerName: 'ASU Housing',
      providerEmail: 'asu@example.com',
    ),
    Housing(
      id: 'h2',
      title: '2BR Apartment',
      price: 380,
      lat: 32.0110,
      lng: 35.8451,
      rating: 4.3,
      providerName: 'Student Housing Co.',
      providerEmail: 'student@example.com',
    ),
    Housing(
      id: 'h3',
      title: 'Cozy Room',
      price: 180,
      lat: 32.0250,
      lng: 35.8600,
      rating: 3.9,
      providerName: 'Campus Living',
      providerEmail: 'campus@example.com',
    ),
  ];

  List<Housing> get listings => List.unmodifiable(_listings);

  void addHousing(Housing housing) {
    _listings.add(housing);
    notifyListeners();
  }

  void removeHousing(String id) {
    _listings.removeWhere((h) => h.id == id);
    notifyListeners();
  }

  void updateHousing(Housing updatedHousing) {
    final index = _listings.indexWhere((h) => h.id == updatedHousing.id);
    if (index != -1) {
      _listings[index] = updatedHousing;
      notifyListeners();
    }
  }

  Housing? getHousingById(String id) {
    try {
      return _listings.firstWhere((h) => h.id == id);
    } catch (e) {
      return null;
    }
  }
}

