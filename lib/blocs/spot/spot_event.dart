import 'package:equatable/equatable.dart';

abstract class SpotEvent extends Equatable {
  const SpotEvent();

  @override
  List<Object?> get props => [];
}

class LoadSpotsForCity extends SpotEvent {
  final String cityId;

  const LoadSpotsForCity(this.cityId);

  @override
  List<Object?> get props => [cityId];
}

class MarkSpotVisited extends SpotEvent {
  final String spotId;

  const MarkSpotVisited(this.spotId);

  @override
  List<Object?> get props => [spotId];
}

class MarkSpotNotVisited extends SpotEvent {
  final String spotId;

  const MarkSpotNotVisited(this.spotId);

  @override
  List<Object?> get props => [spotId];
}
