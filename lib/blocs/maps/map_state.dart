import 'package:equatable/equatable.dart';
import 'package:smd_project_travelmate/models/spot.dart';

enum MapStatus { initial, loading, success, failure }

class MapState extends Equatable {
  const MapState({
    this.status = MapStatus.initial,
    this.spots,
    this.selectedSpot,
    this.clearSelectedSpot = false,
    this.errorMessage,
  });

  final MapStatus status;
  final List<Spot>? spots;
  final Spot? selectedSpot;
  final bool clearSelectedSpot;
  final String? errorMessage;

  MapState copyWith({
    MapStatus? status,
    List<Spot>? spots,
    Spot? selectedSpot,
    bool? clearSelectedSpot,
    String? errorMessage,
  }) {
    return MapState(
      status: status ?? this.status,
      spots: spots ?? this.spots,
      selectedSpot: selectedSpot ?? this.selectedSpot,
      clearSelectedSpot: clearSelectedSpot ?? false,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        spots,
        selectedSpot,
        clearSelectedSpot,
        errorMessage,
      ];
}
