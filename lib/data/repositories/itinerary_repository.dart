import 'package:smd_project_travelmate/models/itinerary_item.dart';

class ItineraryRepository {
  List<ItineraryItem> _items = [];

  List<ItineraryItem> getItems() {
    _items.sort((a, b) => a.order.compareTo(b.order));
    return List.unmodifiable(_items);
  }

  void addItem(ItineraryItem item) {
    _items.add(item);
  }

  void updateOrder(List<ItineraryItem> updatedItems) {
    _items = List.from(updatedItems);
  }

  void removeItem(String id) {
    _items.removeWhere((item) => item.id == id);
  }
}
