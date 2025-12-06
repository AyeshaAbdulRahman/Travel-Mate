class ItineraryItem {
  final String id;
  final String spotId;
  final String cityId;
  final String title;
  final String imageUrl;
  final int order;

  ItineraryItem({
    required this.id,
    required this.spotId,
    required this.cityId,
    required this.title,
    required this.imageUrl,
    required this.order,
  });

  ItineraryItem copyWith({int? order}) {
    return ItineraryItem(
      id: id,
      spotId: spotId,
      cityId: cityId,
      title: title,
      imageUrl: imageUrl,
      order: order ?? this.order,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'spotId': spotId,
        'cityId': cityId,
        'title': title,
        'imageUrl': imageUrl,
        'order': order,
      };

  factory ItineraryItem.fromJson(Map<String, dynamic> json) {
    return ItineraryItem(
      id: json['id'] as String,
      spotId: json['spotId'] as String,
      cityId: json['cityId'] as String,
      title: json['title'] as String,
      imageUrl: json['imageUrl'] as String,
      order: json['order'] as int,
    );
  }
}
