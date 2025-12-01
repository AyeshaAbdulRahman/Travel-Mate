import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smd_project_travelmate/app_router.dart';
import 'package:smd_project_travelmate/theme/app_theme.dart';
import 'package:smd_project_travelmate/data/repositories/spot_repository.dart';
import 'package:smd_project_travelmate/data/repositories/location_repository.dart';
import 'package:smd_project_travelmate/blocs/spot/spot_bloc.dart';
import 'package:smd_project_travelmate/blocs/spot/spot_event.dart';
import 'package:smd_project_travelmate/blocs/map/map_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final spotRepository = SpotRepository();
  final locationRepository = LocationRepository(spotRepository: spotRepository);

  runApp(TravelMateApp(
    spotRepository: spotRepository,
    locationRepository: locationRepository,
  ));
}

class TravelMateApp extends StatelessWidget {
  final SpotRepository spotRepository;
  final LocationRepository locationRepository;

  const TravelMateApp({
    super.key,
    required this.spotRepository,
    required this.locationRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => SpotBloc(spotRepository: spotRepository),
        ),
        BlocProvider(
          create: (_) => MapBloc(
            locationRepository: locationRepository,
            spotRepository: spotRepository,
          ),
        ),
        // Member 1 & 2 will add their blocs here later
      ],
      child: MaterialApp(
        title: 'TravelMate',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        initialRoute: AppRouter.splash,
        onGenerateRoute: AppRouter.onGenerateRoute,
      ),
    );
  }
}
