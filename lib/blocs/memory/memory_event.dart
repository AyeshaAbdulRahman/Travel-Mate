import '../../models/memory.dart';

abstract class MemoryEvent {}

class LoadMemories extends MemoryEvent {}

class AddMemoryEvent extends MemoryEvent {
  final Memory memory;
  AddMemoryEvent(this.memory);
}

class UpdateMemoryEvent extends MemoryEvent {
  final int key;
  final Memory memory;
  UpdateMemoryEvent(this.key, this.memory);
}

class DeleteMemoryEvent extends MemoryEvent {
  final int key;
  DeleteMemoryEvent(this.key);
}

class FilterByCityEvent extends MemoryEvent {
  final String city;
  FilterByCityEvent(this.city);
}

class FilterByDateEvent extends MemoryEvent {
  final DateTime date;
  FilterByDateEvent(this.date);
}
