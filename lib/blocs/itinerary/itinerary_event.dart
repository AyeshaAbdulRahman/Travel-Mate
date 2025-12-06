import 'package:smd_project_travelmate/models/itinerary_item.dart';

abstract class ItineraryEvent {}

class LoadItinerary extends ItineraryEvent {}

class AddToItinerary extends ItineraryEvent {
  final ItineraryItem item;
  AddToItinerary(this.item);
}

class ReorderItinerary extends ItineraryEvent {
  final List<ItineraryItem> updatedList;
  ReorderItinerary(this.updatedList);
}
