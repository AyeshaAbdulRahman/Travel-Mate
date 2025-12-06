import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smd_project_travelmate/data/repositories/location_repository.dart';
import 'package:smd_project_travelmate/data/repositories/spot_repository.dart';
import 'map_event.dart';
import 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final LocationRepository locationRepository;
  final SpotRepository spotRepository;

  MapBloc({
    required this.locationRepository,
    required this.spotRepository,
  }) : super(const MapState()) {
    on<LoadMapForCity>(_onLoadMapForCity);
    on<SelectSpotOnMap>(_onSelectSpot);
    on<ClearSelectedSpot>(_onClearSelectedSpot); // 🔹 new handler
  }

  Future<void> _onLoadMapForCity(
    LoadMapForCity event,
    Emitter<MapState> emit,
  ) async {
    emit(state.copyWith(status: MapStatus.loading));
    try {
      final spots = await spotRepository.getSpotsByCity(event.cityId);
      emit(state.copyWith(status: MapStatus.success, spots: spots));
    } catch (e) {
      emit(
        state.copyWith(
          status: MapStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void _onSelectSpot(
    SelectSpotOnMap event,
    Emitter<MapState> emit,
  ) {
    emit(state.copyWith(selectedSpot: event.spot));
  }

  void _onClearSelectedSpot(
    ClearSelectedSpot event,
    Emitter<MapState> emit,
  ) {
    emit(state.copyWith(clearSelectedSpot: true));
  }
}