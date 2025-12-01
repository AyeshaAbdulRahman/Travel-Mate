import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:smd_project_travelmate/models/spot.dart';

class SpotRepository {
  static const String _spotsAssetPath = 'lib/data/local/spots.json';

  List<Spot>? _cache;

  Future<List<Spot>> _loadAllSpots() async {
    if (_cache != null) return _cache!;
    final jsonString = await rootBundle.loadString(_spotsAssetPath);
    final List<dynamic> decoded = json.decode(jsonString) as List<dynamic>;
    _cache = decoded.map((e) => Spot.fromJson(e as Map<String, dynamic>)).toList();
    return _cache!;
  }

  Future<List<Spot>> getSpotsByCity(String cityId) async {
    final spots = await _loadAllSpots();
    return spots.where((s) => s.cityId == cityId).toList();
  }

  Future<Spot?> getSpotById(String spotId) async {
    final spots = await _loadAllSpots();
    try {
      return spots.firstWhere((s) => s.id == spotId);
    } catch (_) {
      return null;
    }
  }

  Future<List<Spot>> searchSpots(String query) async {
    final spots = await _loadAllSpots();
    final lower = query.toLowerCase();
    return spots
        .where((s) =>
            s.name.toLowerCase().contains(lower) ||
            s.description.toLowerCase().contains(lower))
        .toList();
  }

  Future<List<Spot>> getAllSpots() => _loadAllSpots();
}
