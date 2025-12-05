import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// MODELS
import 'package:smd_project_travelmate/models/memory.dart';
import 'package:smd_project_travelmate/models/tag.dart';

// ROUTER
import 'package:smd_project_travelmate/app_router.dart';

// THEME
import 'package:smd_project_travelmate/theme/app_theme.dart';

// REPOSITORIES
import 'package:smd_project_travelmate/data/repositories/spot_repository.dart';
import 'package:smd_project_travelmate/data/repositories/location_repository.dart';
import 'package:smd_project_travelmate/data/repositories/memory_repository.dart';

// BLOCS
import 'package:smd_project_travelmate/blocs/spot/spot_bloc.dart';
import 'package:smd_project_travelmate/blocs/map/map_bloc.dart';
import 'package:smd_project_travelmate/blocs/memory/memory_bloc.dart';
import 'package:smd_project_travelmate/blocs/memory/memory_event.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ⭐ Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // ⭐ Initialize Hive
  await Hive.initFlutter();

  // ⭐ Register Hive adapters
  Hive.registerAdapter(MemoryAdapter());

  // ⭐ Initialize repositories
  final spotRepository = SpotRepository();
  final locationRepository = LocationRepository(spotRepository: spotRepository);

  // ⭐ MemoryRepository MUST be initialized before bloc
  final memoryRepository = await MemoryRepository.init();

  runApp(
    TravelMateApp(
      spotRepository: spotRepository,
      locationRepository: locationRepository,
      memoryRepository: memoryRepository,
    ),
  );
}

class TravelMateApp extends StatelessWidget {
  final SpotRepository spotRepository;
  final LocationRepository locationRepository;
  final MemoryRepository memoryRepository;

  const TravelMateApp({
    super.key,
    required this.spotRepository,
    required this.locationRepository,
    required this.memoryRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // ⭐ SPOT BLOC
        BlocProvider(create: (_) => SpotBloc(spotRepository: spotRepository)),

        // ⭐ MAP + SPOTS
        BlocProvider(
          create: (_) => MapBloc(
            locationRepository: locationRepository,
            spotRepository: spotRepository,
          ),
        ),

        // ⭐ MEMORY BLOC
        BlocProvider(
          create: (_) => MemoryBloc(memoryRepository)..add(LoadMemories()),
        ),
      ],
      child: MaterialApp(
        title: 'TravelMate',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,

        // ⭐ Set RIGHT STARTING SCREEN
        initialRoute: AppRouter.splash,

        // ⭐ All routes must be inside this
        onGenerateRoute: AppRouter.onGenerateRoute,
      ),
    );
  }
}
