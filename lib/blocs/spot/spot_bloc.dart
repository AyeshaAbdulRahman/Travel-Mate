import 'package:flutter_bloc/flutter_bloc.dart';
import 'spot_event.dart';
import 'spot_state.dart';
import 'package:smd_project_travelmate/data/repositories/spot_repository.dart';

class SpotBloc extends Bloc<SpotEvent, SpotState> {
  final SpotRepository spotRepository;

  SpotBloc({required this.spotRepository}) : super(const SpotState()) {
    on<LoadSpotsForCity>(_onLoadSpotsForCity);
    on<MarkSpotVisited>(_onMarkSpotVisited);
    on<MarkSpotNotVisited>(_onMarkSpotNotVisited);
  }

  Future<void> _onLoadSpotsForCity(
    LoadSpotsForCity event,
    Emitter<SpotState> emit,
  ) async {
    emit(state.copyWith(status: SpotStatus.loading));
    try {
      final spots = await spotRepository.getSpotsByCity(event.cityId);
      emit(state.copyWith(status: SpotStatus.success, spots: spots));
    } catch (e) {
      emit(state.copyWith(status: SpotStatus.failure, errorMessage: e.toString()));
    }
  }

  void _onMarkSpotVisited(
    MarkSpotVisited event,
    Emitter<SpotState> emit,
  ) {
    if (state.spots != null) {
      final updatedSpots = state.spots!.map((spot) {
        if (spot.id == event.spotId) {
          return spot.copyWith(
            isVisited: true,
            visitedDate: DateTime.now().toIso8601String(),
          );
        }
        return spot;
      }).toList();
      emit(state.copyWith(spots: updatedSpots));
    }
  }

  void _onMarkSpotNotVisited(
    MarkSpotNotVisited event,
    Emitter<SpotState> emit,
  ) {
    if (state.spots != null) {
      final updatedSpots = state.spots!.map((spot) {
        if (spot.id == event.spotId) {
          return spot.copyWith(
            isVisited: false,
            visitedDate: null,
            userPhotos: null,
          );
        }
        return spot;
      }).toList();
      emit(state.copyWith(spots: updatedSpots));
    }
  }
}
