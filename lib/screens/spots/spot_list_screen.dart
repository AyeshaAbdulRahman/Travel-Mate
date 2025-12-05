import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smd_project_travelmate/blocs/spot/spot_bloc.dart';
import 'package:smd_project_travelmate/blocs/spot/spot_event.dart';
import 'package:smd_project_travelmate/blocs/spot/spot_state.dart';
import 'package:smd_project_travelmate/models/spot.dart';
import 'package:smd_project_travelmate/widgets/custom_appbar.dart';
import 'package:smd_project_travelmate/widgets/spot_card.dart';
import 'package:smd_project_travelmate/app_router.dart';

class SpotListScreen extends StatefulWidget {
  final String cityId;

  const SpotListScreen({super.key, required this.cityId});

  @override
  State<SpotListScreen> createState() => _SpotListScreenState();
}

class _SpotListScreenState extends State<SpotListScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    context.read<SpotBloc>().add(LoadSpotsForCity(widget.cityId));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _openDetail(Spot spot) {
    Navigator.of(context).pushNamed(
      AppRouter.spotDetail,
      arguments: spot,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Tourist Spots'),
      body: Container(
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
        child: BlocConsumer<SpotBloc, SpotState>(
          listener: (context, state) {
            if (state.status == SpotStatus.success) {
              _controller.forward();
            }
          },
          builder: (context, state) {
            switch (state.status) {
              case SpotStatus.loading:
                return Center(
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
                        'Loading spots...',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: const Color(0xFF778873),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              case SpotStatus.failure:
                return Center(
                  child: Container(
                    margin: const EdgeInsets.all(32),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
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
                          Icons.error_outline,
                          size: 64,
                          color: Color(0xFF778873),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Oops!',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF778873),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          state.errorMessage ?? 'Failed to load spots',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: const Color(0xFF778873).withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              case SpotStatus.success:
                if (state.spots.isEmpty) {
                  return Center(
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
                            Icons.explore_off,
                            size: 80,
                            color: Color(0xFFA1BC98),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'No Spots Found',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF778873),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'No tourist spots available for this city yet.',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: const Color(0xFF778873).withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.spots.length,
                  itemBuilder: (context, index) {
                    final spot = state.spots[index];
                    return _AnimatedSpotCard(
                      key: ValueKey(spot.id),
                      spot: spot,
                      index: index,
                      animation: _controller,
                      onTap: () => _openDetail(spot),
                    );
                  },
                );
              case SpotStatus.initial:
              default:
                return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}

class _AnimatedSpotCard extends StatelessWidget {
  final Spot spot;
  final int index;
  final Animation<double> animation;
  final VoidCallback onTap;

  const _AnimatedSpotCard({
    super.key,
    required this.spot,
    required this.index,
    required this.animation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final delay = index * 0.1;
    final curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: Interval(
        delay.clamp(0.0, 1.0),
        (delay + 0.3).clamp(0.0, 1.0),
        curve: Curves.easeOutCubic,
      ),
    );

    return FadeTransition(
      opacity: curvedAnimation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.2),
          end: Offset.zero,
        ).animate(curvedAnimation),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: SpotCard(
            spot: spot,
            onTap: onTap,
          ),
        ),
      ),
    );
  }
}