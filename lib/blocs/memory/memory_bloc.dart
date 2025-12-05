import 'package:bloc/bloc.dart';
import '../../data/repositories/memory_repository.dart';
import 'memory_event.dart';
import 'memory_state.dart';

class MemoryBloc extends Bloc<MemoryEvent, MemoryState> {
  final MemoryRepository repository;

  MemoryBloc(this.repository) : super(MemoryInitial()) {
    on<LoadMemories>(_onLoad);
    on<AddMemoryEvent>(_onAdd);
    on<UpdateMemoryEvent>(_onUpdate);
    on<DeleteMemoryEvent>(_onDelete);
    on<FilterByCityEvent>(_onFilterByCity);
    on<FilterByDateEvent>(_onFilterByDate);
  }

  Future<void> _onLoad(LoadMemories event, Emitter<MemoryState> emit) async {
    emit(MemoryLoading());
    try {
      final list = await repository.getAllMemories();
      if (list.isEmpty) {
        emit(MemoryEmpty());
      } else {
        emit(MemoryLoaded(list));
      }
    } catch (e) {
      emit(MemoryError(e.toString()));
    }
  }

  Future<void> _onAdd(AddMemoryEvent event, Emitter<MemoryState> emit) async {
    try {
      await repository.addMemory(event.memory);
      add(LoadMemories());
    } catch (e) {
      emit(MemoryError(e.toString()));
    }
  }

  Future<void> _onUpdate(
    UpdateMemoryEvent event,
    Emitter<MemoryState> emit,
  ) async {
    try {
      await repository.updateMemory(event.key, event.memory);
      add(LoadMemories());
    } catch (e) {
      emit(MemoryError(e.toString()));
    }
  }

  Future<void> _onDelete(
    DeleteMemoryEvent event,
    Emitter<MemoryState> emit,
  ) async {
    try {
      await repository.deleteMemory(event.key);
      add(LoadMemories());
    } catch (e) {
      emit(MemoryError(e.toString()));
    }
  }

  Future<void> _onFilterByCity(
    FilterByCityEvent event,
    Emitter<MemoryState> emit,
  ) async {
    emit(MemoryLoading());
    try {
      final list = await repository.filterByCity(event.city);
      if (list.isEmpty) {
        emit(MemoryEmpty());
      } else {
        emit(MemoryLoaded(list));
      }
    } catch (e) {
      emit(MemoryError(e.toString()));
    }
  }

  Future<void> _onFilterByDate(
    FilterByDateEvent event,
    Emitter<MemoryState> emit,
  ) async {
    emit(MemoryLoading());
    try {
      final list = await repository.filterByDate(event.date);
      if (list.isEmpty) {
        emit(MemoryEmpty());
      } else {
        emit(MemoryLoaded(list));
      }
    } catch (e) {
      emit(MemoryError(e.toString()));
    }
  }
}
