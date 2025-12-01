import 'package:flutter_bloc/flutter_bloc.dart';
import 'spot_event.dart';
import 'spot_state.dart';
import 'package:smd_project_travelmate/data/repositories/spot_repository.dart';

class SpotBloc extends Bloc<SpotEvent, SpotState> {
  final SpotRepository spotRepository;

  SpotBloc({required this.spotRepository}) : super(const SpotState()) {
    on<LoadSpotsForCity>(_onLoadSpotsForCity);
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
}
