import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:smd_project_travelmate/models/spot.dart';
import 'package:smd_project_travelmate/widgets/custom_appbar.dart';
import 'package:smd_project_travelmate/blocs/itinerary/itinerary_bloc.dart';
import 'package:smd_project_travelmate/blocs/itinerary/itinerary_event.dart';
import 'package:smd_project_travelmate/models/itinerary_item.dart';

class SpotDetailScreen extends StatefulWidget {
  final Spot spot;

  const SpotDetailScreen({super.key, required this.spot});

  @override
  State<SpotDetailScreen> createState() => _SpotDetailScreenState();
}

class _SpotDetailScreenState extends State<SpotDetailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _imageAnimation;
  late Animation<double> _contentAnimation;
  late Animation<Offset> _slideAnimation;

  bool _isAddButtonPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _imageAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _contentAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.8, curve: Curves.easeOut),
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.8, curve: Curves.easeOut),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: widget.spot.name),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF1F3E0), Color(0xFFD2DCB6)],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAnimatedImage(),
              _buildAnimatedContent(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedImage() {
    return FadeTransition(
      opacity: _imageAnimation,
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.8, end: 1.0).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
          ),
        ),
        child: Hero(
          tag: 'spot_${widget.spot.id}',
          child: Container(
            height: 300,
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF778873).withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // If you switched to assets, replace with Image.asset
                  Image.asset(
                    widget.spot.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: const Color(0xFFA1BC98).withOpacity(0.3),
                      child: const Icon(
                        Icons.image_not_supported,
                        size: 64,
                        color: Color(0xFF778873),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.4),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedContent() {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _contentAnimation,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.spot.name,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF778873),
                          ),
                    ),
                  ),
                  if (widget.spot.category != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFA1BC98), Color(0xFF778873)],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF778873).withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        widget.spot.category!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 24),
              _buildInfoSection(
                icon: Icons.description_rounded,
                title: 'About',
                content: widget.spot.description,
              ),
              const SizedBox(height: 24),
              _buildInfoSection(
                icon: Icons.location_on_rounded,
                title: 'Location',
                content: widget.spot.location.address ??
                    'Lat: ${widget.spot.location.latitude.toStringAsFixed(4)}, '
                        'Lng: ${widget.spot.location.longitude.toStringAsFixed(4)}',
              ),
              const SizedBox(height: 32),
              _buildAddToItineraryButton(context),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddToItineraryButton(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isAddButtonPressed = true),
      onTapUp: (_) => setState(() => _isAddButtonPressed = false),
      onTapCancel: () => setState(() => _isAddButtonPressed = false),
      onTap: () {
        final item = ItineraryItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          spotId: widget.spot.id,
          cityId: widget.spot.cityId,
          title: widget.spot.name,
          imageUrl: widget.spot.imageUrl,
          order: context.read<ItineraryBloc>().state.items.length,
        );

        context.read<ItineraryBloc>().add(AddToItinerary(item));

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Added to Itinerary')),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        transform: Matrix4.identity()
          ..scale(_isAddButtonPressed ? 0.97 : 1.0),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFA1BC98), Color(0xFF778873)],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF778873).withOpacity(0.35),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.playlist_add,
              color: Colors.white,
              size: 22,
            ),
            SizedBox(width: 10),
            Text(
              'Add to Itinerary',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFA1BC98).withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFA1BC98).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: const Color(0xFF778873),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF778873),
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF778873).withOpacity(0.8),
                  height: 1.5,
                ),
          ),
        ],
      ),
    );
  }
}
