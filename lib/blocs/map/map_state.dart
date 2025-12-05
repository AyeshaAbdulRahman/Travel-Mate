import 'package:equatable/equatable.dart';
import 'package:smd_project_travelmate/models/spot.dart';

enum MapStatus { initial, loading, success, failure }

class MapState extends Equatable {
  final MapStatus status;
  final List<Spot> spots;
  final Spot? selectedSpot;
  final String? errorMessage;

  const MapState({
    this.status = MapStatus.initial,
    this.spots = const [],
    this.selectedSpot,
    this.errorMessage,
  });

  MapState copyWith({
    MapStatus? status,
    List<Spot>? spots,
    Spot? selectedSpot,
    bool clearSelectedSpot = false,
    String? errorMessage,
  }) {
    return MapState(
      status: status ?? this.status,
      spots: spots ?? this.spots,
      selectedSpot: clearSelectedSpot
          ? null
          : (selectedSpot ?? this.selectedSpot),
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, spots, selectedSpot ?? '', errorMessage ?? ''];
}
