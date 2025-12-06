import 'package:smd_project_travelmate/models/itinerary_item.dart';

enum ItineraryStatus { initial, loading, success }

class ItineraryState {
  final ItineraryStatus status;
  final List<ItineraryItem> items;

  ItineraryState({
    required this.status,
    required this.items,
  });

  factory ItineraryState.initial() {
    return ItineraryState(
      status: ItineraryStatus.initial,
      items: const [],
    );
  }

  ItineraryState copyWith({
    ItineraryStatus? status,
    List<ItineraryItem>? items,
  }) {
    return ItineraryState(
      status: status ?? this.status,
      items: items ?? this.items,
    );
  }
}
