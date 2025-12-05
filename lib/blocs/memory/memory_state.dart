import '../../models/memory.dart';

abstract class MemoryState {}

class MemoryInitial extends MemoryState {}

class MemoryLoading extends MemoryState {}

class MemoryEmpty extends MemoryState {}

class MemoryLoaded extends MemoryState {
  final List<MapEntry<int, Memory>> memories;
  MemoryLoaded(this.memories);
}

class MemoryError extends MemoryState {
  final String message;
  MemoryError(this.message);
}
