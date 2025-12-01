import 'package:equatable/equatable.dart';
import 'package:smd_project_travelmate/models/spot.dart';

abstract class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object?> get props => [];
}

class LoadMapForCity extends MapEvent {
  final String cityId;

  const LoadMapForCity(this.cityId);

  @override
  List<Object?> get props => [cityId];
}

class SelectSpotOnMap extends MapEvent {
  final Spot spot;

  const SelectSpotOnMap(this.spot);

  @override
  List<Object?> get props => [spot];
}

class ClearSelectedSpot extends MapEvent {
  const ClearSelectedSpot();
}
