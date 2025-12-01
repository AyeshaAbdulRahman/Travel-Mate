import 'package:smd_project_travelmate/models/location_model.dart';
import 'package:smd_project_travelmate/models/spot.dart';
import 'spot_repository.dart';

class LocationRepository {
  final SpotRepository spotRepository;

  LocationRepository({required this.spotRepository});

  Future<List<LocationModel>> getLocationsForCity(String cityId) async {
    final spots = await spotRepository.getSpotsByCity(cityId);
    return spots.map((s) => s.location).toList();
  }

  Future<LocationModel?> getLocationForSpot(String spotId) async {
    final spot = await spotRepository.getSpotById(spotId);
    return spot?.location;
  }

  Future<List<Spot>> getSpotsForMap(String cityId) async {
    return spotRepository.getSpotsByCity(cityId);
  }
}
