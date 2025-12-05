import 'dart:typed_data';
import 'package:hive/hive.dart';

part 'memory.g.dart';

@HiveType(typeId: 0)
class Memory {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String caption;

  @HiveField(2)
  final String imagePath;

  @HiveField(3)
  final Uint8List? imageBytes;

  @HiveField(4)
  final String cityName;

  @HiveField(5)
  final DateTime date;

  @HiveField(6)
  final List<String> tags;

  Memory({
    required this.title,
    required this.caption,
    required this.imagePath,
    this.imageBytes,
    required this.cityName,
    required this.date,
    required this.tags,
  });

  factory Memory.fromMap(Map<String, dynamic> map) {
    return Memory(
      title: map['title'] as String,
      caption: map['caption'] as String,
      imagePath: map['imagePath'] as String,
      imageBytes: map['imageBytes'] != null
          ? Uint8List.fromList(List<int>.from(map['imageBytes']))
          : null,
      cityName: map['cityName'] as String,
      date: DateTime.parse(map['date'] as String),
      tags: (map['tags'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'caption': caption,
      'imagePath': imagePath,
      'imageBytes': imageBytes?.toList(),
      'cityName': cityName,
      'date': date.toIso8601String(),
      'tags': tags,
    };
  }

  String? get formattedCity => cityName.isNotEmpty ? cityName : null;

  String? get formattedDate {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Yesterday';
    } else if (difference < 7) {
      return '$difference days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  String? get formattedTime =>
      '${date.hour}:${date.minute.toString().padLeft(2, '0')}';
}
