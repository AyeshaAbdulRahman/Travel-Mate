import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smd_project_travelmate/blocs/map/map_bloc.dart';
import 'package:smd_project_travelmate/blocs/map/map_event.dart';
import 'package:smd_project_travelmate/blocs/map/map_state.dart';
import 'package:smd_project_travelmate/widgets/custom_appbar.dart';
import 'package:smd_project_travelmate/utils/helpers.dart';
import 'package:smd_project_travelmate/models/spot.dart';

class MapScreen extends StatefulWidget {
  final String cityId;

  const MapScreen({super.key, required this.cityId});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with SingleTickerProviderStateMixin {
  GoogleMapController? _mapController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    context.read<MapBloc>().add(LoadMapForCity(widget.cityId));
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  Set<Marker> _buildMarkers(MapState state) {
    return state.spots.map((Spot spot) {
      return Marker(
        markerId: MarkerId(spot.id),
        position: LatLng(
          spot.location.latitude,
          spot.location.longitude,
        ),
        infoWindow: InfoWindow(
          title: spot.name,
          snippet: spot.category,
        ),
        onTap: () {
          context.read<MapBloc>().add(SelectSpotOnMap(spot));
          _animationController.forward();
        },
      );
    }).toSet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Map'),
      body: BlocConsumer<MapBloc, MapState>(
        listener: (context, state) {
          if (state.status == MapStatus.failure && state.errorMessage != null) {
            showErrorSnackBar(context, state.errorMessage!);
          }
          if (state.selectedSpot != null) {
            _animationController.forward();
          } else {
            _animationController.reverse();
          }
        },
        builder: (context, state) {
          if (state.status == MapStatus.loading || state.status == MapStatus.initial) {
            return Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFF1F3E0),
                    Color(0xFFD2DCB6),
                  ],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF778873).withOpacity(0.2),
                            blurRadius: 15,
                            spreadRadius: 3,
                          ),
                        ],
                      ),
                      child: const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFF778873),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Loading map...',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: const Color(0xFF778873),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state.spots.isEmpty) {
            return Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFF1F3E0),
                    Color(0xFFD2DCB6),
                  ],
                ),
              ),
              child: Center(
                child: Container(
                  margin: const EdgeInsets.all(32),
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.map_outlined,
                        size: 80,
                        color: Color(0xFFA1BC98),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'No Spots Available',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF778873),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'No spots found for this city on the map.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF778873).withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          final firstSpot = state.spots.first;
          final initialCameraPosition = CameraPosition(
            target: LatLng(
              firstSpot.location.latitude,
              firstSpot.location.longitude,
            ),
            zoom: 12,
          );

          return Stack(
            children: [
              GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: initialCameraPosition,
                markers: _buildMarkers(state),
                myLocationButtonEnabled: false,
                zoomControlsEnabled: true,
                mapToolbarEnabled: false,
              ),
              if (state.selectedSpot != null)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: _SelectedSpotCard(
                        spot: state.selectedSpot!,
                        onClose: () {
                          context.read<MapBloc>().add(const ClearSelectedSpot());
                        },
                      ),
                    ),
                  ),
                ),
              Positioned(
                top: 16,
                left: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFA1BC98),
                        Color(0xFF778873),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.place,
                        size: 18,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${state.spots.length} ${state.spots.length == 1 ? 'Spot' : 'Spots'}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SelectedSpotCard extends StatelessWidget {
  final Spot spot;
  final VoidCallback onClose;

  const _SelectedSpotCard({
    required this.spot,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Color(0xFFF1F3E0),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              spot.imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 80,
                height: 80,
                color: const Color(0xFFA1BC98).withOpacity(0.3),
                child: const Icon(
                  Icons.image_not_supported,
                  color: Color(0xFF778873),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  spot.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF778873),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (spot.category != null) ...[
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFA1BC98).withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      spot.category!,
                      style: const TextStyle(
                        color: Color(0xFF778873),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            onPressed: onClose,
            icon: const Icon(
              Icons.close_rounded,
              color: Color(0xFF778873),
            ),
            style: IconButton.styleFrom(
              backgroundColor: const Color(0xFFA1BC98).withOpacity(0.2),
            ),
          ),
        ],
      ),
    );
  }
}