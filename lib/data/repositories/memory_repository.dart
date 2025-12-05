import 'package:hive/hive.dart';

import '../../models/memory.dart';

class MemoryRepository {
  static const String _boxName = 'memories';

  final Box _box;

  MemoryRepository._(this._box);

  static Future<MemoryRepository> init() async {
    final box = await Hive.openBox(_boxName);

    return MemoryRepository._(box);
  }

  Box get box => _box;

  Future<List<MapEntry<int, Memory>>> getAllMemories() async {
    final map = _box.toMap().cast<int, dynamic>();

    final list = map.entries.map((e) {
      final value = e.value;

      final mem = value is Map
          ? Memory.fromMap(Map<String, dynamic>.from(value))
          : Memory.fromMap(Map<String, dynamic>.from(value));

      return MapEntry<int, Memory>(e.key, mem);
    }).toList();

    // newest first

    list.sort((a, b) => b.key.compareTo(a.key));

    return list;
  }

  Future<int> addMemory(Memory memory) async {
    final key = await _box.add(memory.toMap());

    final map = memory.toMap();

    map['id'] = key;

    await _box.put(key, map);

    return key as int;
  }

  Future<void> updateMemory(int key, Memory memory) async {
    await _box.put(key, memory.toMap());
  }

  Future<void> deleteMemory(int key) async {
    await _box.delete(key);
  }

  Future<List<MapEntry<int, Memory>>> filterByCity(String city) async {
    final all = await getAllMemories();

    return all
        .where((e) => e.value.cityName.toLowerCase() == city.toLowerCase())
        .toList();
  }

  Future<List<MapEntry<int, Memory>>> filterByDate(DateTime date) async {
    final all = await getAllMemories();

    return all.where((e) => _isSameDate(e.value.date, date)).toList();
  }

  bool _isSameDate(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}
