import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smd_project_travelmate/blocs/itinerary/itinerary_event.dart';
import 'package:smd_project_travelmate/blocs/itinerary/itinerary_state.dart';
import 'package:smd_project_travelmate/data/repositories/itinerary_repository.dart';

class ItineraryBloc extends Bloc<ItineraryEvent, ItineraryState> {
  final ItineraryRepository repository;

  ItineraryBloc({required this.repository}) : super(ItineraryState.initial()) {
    on<LoadItinerary>((event, emit) {
      emit(state.copyWith(
        status: ItineraryStatus.success,
        items: repository.getItems(),
      ));
    });

    on<AddToItinerary>((event, emit) {
      repository.addItem(event.item);
      emit(state.copyWith(
        status: ItineraryStatus.success,
        items: repository.getItems(),
      ));
    });

    on<ReorderItinerary>((event, emit) {
      repository.updateOrder(event.updatedList);
      emit(state.copyWith(
        status: ItineraryStatus.success,
        items: repository.getItems(),
      ));
    });
  }
}
