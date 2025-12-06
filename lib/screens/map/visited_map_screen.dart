import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:smd_project_travelmate/blocs/spot/spot_bloc.dart';
import 'package:smd_project_travelmate/models/spot.dart';

class VisitedMapScreen extends StatefulWidget {
  const VisitedMapScreen({Key? key}) : super(key: key);

  @override
  State<VisitedMapScreen> createState() => _VisitedMapScreenState();
}

class _VisitedMapScreenState extends State<VisitedMapScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  final MapController _mapController = MapController();
  final List<Marker> _markers = [];
  final List<LatLng> _visitedPoints = [];

  bool _showVisitedOnly = false;
  bool _showAnimations = true;
  double _currentZoom = 12.0;
  LatLng _centerPoint = const LatLng(24.8607, 67.0011); // Karachi center
  
  // ✅ NEW: Track spots separately
  List<Spot> _currentSpots = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ✅ FIXED: Remove setState from _buildMarkers
  void _buildMarkers(List<Spot> spots) {
    _markers.clear();
    _visitedPoints.clear();

    for (final spot in spots) {
      if (_showVisitedOnly && !spot.isVisited) continue;

      final latLng = LatLng(spot.location.latitude, spot.location.longitude);

      if (spot.isVisited) {
        _visitedPoints.add(latLng);
      }

      _markers.add(
        Marker(
          point: latLng,
          width: 50,
          height: 50,
          child: GestureDetector(
            onTap: () => _showSpotDialog(spot),
            child: _buildAnimatedMarker(spot),
          ),
        ),
      );
    }
    
    // ✅ FIXED: Don't call setState here, call it from the caller
  }

  // ✅ NEW: Separate method to update markers with setState
  void _updateMarkers() {
    if (mounted) {
      setState(() {
        _buildMarkers(_currentSpots);
      });
    }
  }

  Widget _buildAnimatedMarker(Spot spot) {
    return AnimatedContainer(
      duration: Duration(milliseconds: _showAnimations ? 500 : 0),
      curve: Curves.elasticOut,
      transform: Matrix4.identity()
        ..translate(0.0, _showAnimations ? -20.0 : 0.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (spot.isVisited && _showAnimations)
            Positioned(
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green.withOpacity(0.2),
                ),
              ),
            ),

          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: spot.isVisited ? Colors.green : Colors.blue,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              spot.isVisited ? Icons.flag : Icons.location_pin,
              color: Colors.white,
              size: 24,
            ),
          ),

          if (spot.isVisited)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, size: 12, color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }

  void _showSpotDialog(Spot spot) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: spot.isVisited ? Colors.green : Colors.blue,
                shape: BoxShape.circle,
              ),
              child: Icon(
                spot.isVisited ? Icons.flag : Icons.location_pin,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                spot.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (spot.category != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    spot.category!,
                    style: TextStyle(color: Colors.blue[800], fontSize: 12),
                  ),
                ),
              const SizedBox(height: 12),
              Text(
                spot.description.length > 150
                    ? '${spot.description.substring(0, 150)}...'
                    : spot.description,
                style: TextStyle(color: Colors.grey[700]),
              ),
              const SizedBox(height: 12),
              if (spot.isVisited && spot.visitedDate != null)
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: Colors.green,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Visited: ${spot.visitedDate!.substring(0, 10)}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.green,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              if (spot.isVisited &&
                  spot.userPhotos != null &&
                  spot.userPhotos!.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    const Text(
                      'Your Photos:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${spot.userPhotos!.length} photo(s)',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/spots/detail', arguments: spot);
            },
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.visibility, size: 16),
                SizedBox(width: 6),
                Text('View Details'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _zoomIn() {
    _mapController.move(_mapController.center, _currentZoom + 1);
    setState(() => _currentZoom += 1);
  }

  void _zoomOut() {
    _mapController.move(_mapController.center, _currentZoom - 1);
    setState(() => _currentZoom -= 1);
  }

  void _flyToKarachi() {
    _mapController.move(const LatLng(24.8607, 67.0011), 12);
    setState(() => _currentZoom = 12);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Travel Map'),
        backgroundColor: const Color(0xFF778873),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: () {
              setState(() => _showVisitedOnly = !_showVisitedOnly);
              // ✅ FIXED: Use WidgetsBinding to call after build
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _updateMarkers();
              });
            },
            tooltip: _showVisitedOnly ? 'Show All' : 'Show Visited Only',
          ),
          IconButton(
            icon: const Icon(Icons.animation),
            onPressed: () {
              setState(() => _showAnimations = !_showAnimations);
            },
            tooltip: _showAnimations
                ? 'Disable Animations'
                : 'Enable Animations',
          ),
        ],
      ),
      body: BlocBuilder<SpotBloc, dynamic>(
        builder: (context, state) {
          // ✅ FIXED: Extract spots without side effects
          final List<Spot> spots;
          if (state is dynamic && state.spots != null) {
            spots = state.spots;
          } else {
            spots = [];
          }
          
          // ✅ FIXED: Store spots for later use
          _currentSpots = spots;

          // ✅ FIXED: Initialize markers only once
          if (spots.isNotEmpty && _markers.isEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _updateMarkers();
            });
          }

          return Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  center: _centerPoint,
                  zoom: _currentZoom,
                  maxZoom: 18,
                  minZoom: 5,
                  interactiveFlags: InteractiveFlag.all,
                  onMapReady: () {
                    if (_showAnimations) {
                      _controller.forward();
                    }
                  },
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.travelmate.app',
                  ),
                  MarkerLayer(markers: _markers),
                ],
              ),

              Positioned(
                bottom: 100,
                right: 20,
                child: Column(
                  children: [
                    FloatingActionButton.small(
                      onPressed: _zoomIn,
                      child: const Icon(Icons.add),
                      heroTag: 'zoom_in',
                    ),
                    const SizedBox(height: 10),
                    FloatingActionButton.small(
                      onPressed: _zoomOut,
                      child: const Icon(Icons.remove),
                      heroTag: 'zoom_out',
                    ),
                    const SizedBox(height: 10),
                    FloatingActionButton.small(
                      onPressed: _flyToKarachi,
                      child: const Icon(Icons.home),
                      heroTag: 'home',
                    ),
                  ],
                ),
              ),

              Positioned(
                top: 80,
                left: 20,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Travel Stats',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildStatItem(
                            'Visited Places',
                            '${_visitedPoints.length}/${spots.length}',
                            Icons.flag,
                            Colors.green,
                          ),
                          const SizedBox(height: 8),
                          _buildStatItem(
                            'Map Zoom',
                            '${_currentZoom.toStringAsFixed(1)}x',
                            Icons.zoom_in_map,
                            Colors.blue,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),

      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FilterChip(
                label: Text(
                  _showVisitedOnly ? 'Visited Only' : 'All Places',
                  style: TextStyle(
                    color: _showVisitedOnly ? Colors.white : Colors.blue,
                  ),
                ),
                selected: _showVisitedOnly,
                onSelected: (selected) {
                  setState(() => _showVisitedOnly = selected);
                  // ✅ FIXED: Use post frame callback
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _updateMarkers();
                  });
                },
                backgroundColor: Colors.blue[50],
                selectedColor: Colors.green,
                checkmarkColor: Colors.white,
              ),

              FilterChip(
                label: Text(
                  _showAnimations ? 'Animations ON' : 'Animations OFF',
                  style: TextStyle(
                    color: _showAnimations ? Colors.white : Colors.purple,
                  ),
                ),
                selected: _showAnimations,
                onSelected: (selected) {
                  setState(() => _showAnimations = selected);
                },
                backgroundColor: Colors.purple[50],
                selectedColor: Colors.purple,
                checkmarkColor: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 16, color: color),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ],
    );
  }
}