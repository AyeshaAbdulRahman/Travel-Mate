import 'package:equatable/equatable.dart';
import 'location_model.dart';

class Spot extends Equatable {
  final String id;
  final String cityId;
  final String name;
  final String description;
  final String imageUrl;
  final LocationModel location;
  final String? category;
  final bool isVisited;
  final String? visitedDate;
  final List<String>? userPhotos;

  const Spot({
    required this.id,
    required this.cityId,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.location,
    this.category,
    this.isVisited = false,
    this.visitedDate,
    this.userPhotos,
  });

  factory Spot.fromJson(Map<String, dynamic> json) {
    return Spot(
      id: json['id'] as String,
      cityId: json['cityId'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      category: json['category'] as String?,
      location: LocationModel.fromJson(json['location'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cityId': cityId,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'category': category,
      'location': location.toJson(),
      'isVisited': isVisited,
      'visitedDate': visitedDate,
      'userPhotos': userPhotos,
    };
  }

  Spot copyWith({
    String? id,
    String? cityId,
    String? name,
    String? description,
    String? imageUrl,
    LocationModel? location,
    String? category,
    bool? isVisited,
    String? visitedDate,
    List<String>? userPhotos,
  }) {
    return Spot(
      id: id ?? this.id,
      cityId: cityId ?? this.cityId,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      location: location ?? this.location,
      category: category ?? this.category,
      isVisited: isVisited ?? this.isVisited,
      visitedDate: visitedDate ?? this.visitedDate,
      userPhotos: userPhotos ?? this.userPhotos,
    );
  }

  @override
  List<Object?> get props => [id, cityId, name, description, imageUrl, category, location, isVisited, visitedDate, userPhotos];
}
