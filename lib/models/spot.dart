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

  const Spot({
    required this.id,
    required this.cityId,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.location,
    this.category,
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
    };
  }

  @override
  List<Object?> get props => [id, cityId, name, description, imageUrl, category, location];
}
