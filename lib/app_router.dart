import 'package:flutter/material.dart';

// Screens
import 'package:smd_project_travelmate/screens/splash/splash_screen.dart';
import 'package:smd_project_travelmate/screens/home/home_screen.dart';
import 'package:smd_project_travelmate/screens/spots/spot_list_screen.dart';
import 'package:smd_project_travelmate/screens/spots/spot_detail_screen.dart';

// Memory Screens
import 'package:smd_project_travelmate/screens/memories/add_memory_screen.dart';
import 'package:smd_project_travelmate/screens/memories/memory_list_screen.dart';
import 'package:smd_project_travelmate/screens/memories/memory_detail_screen.dart';

// Models
import 'package:smd_project_travelmate/models/spot.dart';
import 'package:smd_project_travelmate/models/memory.dart';

class AppRouter {
  static const String splash = '/';
  static const String home = '/home';

  // Spots
  static const String spotList = '/spots';
  static const String spotDetail = '/spots/detail';

  // Memories
  static const String memoryList = '/memories';
  static const String addMemory = '/memories/add';
  static const String memoryDetail = '/memories/detail';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      // Splash
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      // Home Screen
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      // Spot List
      case spotList:
        final cityId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => SpotListScreen(cityId: cityId),
        );

      // Spot Detail
      case spotDetail:
        final spot = settings.arguments as Spot;
        return MaterialPageRoute(builder: (_) => SpotDetailScreen(spot: spot));

      // ⭐ Memory List
      case memoryList:
        return MaterialPageRoute(builder: (_) => const MemoryListScreen());

      // ⭐ Add Memory
      case addMemory:
        return MaterialPageRoute(builder: (_) => const AddMemoryScreen());

      // ⭐ Memory Detail
      case memoryDetail:
        final args = settings.arguments as Map<String, dynamic>;

        final Memory memory = args['memory'];
        final int keyId = args['keyId'];

        return MaterialPageRoute(
          builder: (_) => MemoryDetailScreen(memory: memory, keyId: keyId),
        );

      // Unknown Route
      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Route not found'))),
        );
    }
  }
}
