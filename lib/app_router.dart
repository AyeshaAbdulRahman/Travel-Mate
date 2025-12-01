import 'package:flutter/material.dart';
import 'package:smd_project_travelmate/screens/splash/splash_screen.dart';
import 'package:smd_project_travelmate/screens/home/home_screen.dart';
import 'package:smd_project_travelmate/screens/spots/spot_list_screen.dart';
import 'package:smd_project_travelmate/screens/spots/spot_detail_screen.dart';
import 'package:smd_project_travelmate/screens/map/map_screen.dart';
import 'package:smd_project_travelmate/models/spot.dart';

class AppRouter {
  static const String splash = '/';
  static const String home = '/home';
  static const String spotList = '/spots';
  static const String spotDetail = '/spots/detail';
  static const String map = '/map';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case spotList:
        final cityId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => SpotListScreen(cityId: cityId),
        );
      case spotDetail:
        final spot = settings.arguments as Spot;
        return MaterialPageRoute(
          builder: (_) => SpotDetailScreen(spot: spot),
        );
      case map:
        final cityId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => MapScreen(cityId: cityId),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Route not found')),
          ),
        );
    }
  }
}
