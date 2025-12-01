import 'package:equatable/equatable.dart';
import 'package:smd_project_travelmate/models/spot.dart';

enum SpotStatus { initial, loading, success, failure }

class SpotState extends Equatable {
  final SpotStatus status;
  final List<Spot> spots;
  final String? errorMessage;

  const SpotState({
    this.status = SpotStatus.initial,
    this.spots = const [],
    this.errorMessage,
  });

  SpotState copyWith({
    SpotStatus? status,
    List<Spot>? spots,
    String? errorMessage,
  }) {
    return SpotState(
      status: status ?? this.status,
      spots: spots ?? this.spots,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, spots, errorMessage ?? ''];
}
