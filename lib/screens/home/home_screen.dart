import 'package:flutter/material.dart';
import 'package:smd_project_travelmate/app_router.dart';
import 'package:smd_project_travelmate/widgets/custom_appbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _cardAnimations;
  late List<Animation<Offset>> _slideAnimations;

  // Header (0) + Discover (1) + Memories (2) + Itinerary (3) = 4
  final int _totalCards = 4;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _cardAnimations = List.generate(
      _totalCards,
      (index) => Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            index * 0.12,
            0.6 + (index * 0.12),
            curve: Curves.easeOutCubic,
          ),
        ),
      ),
    );

    _slideAnimations = List.generate(
      _totalCards,
      (index) => Tween<Offset>(
        begin: const Offset(0, 0.3),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            index * 0.12,
            0.6 + (index * 0.12),
            curve: Curves.easeOutCubic,
          ),
        ),
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
    const sampleCityId = 'karachi';

    return Scaffold(
      appBar: const CustomAppBar(title: 'TravelMate', showBack: false),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF1F3E0), Color(0xFFD2DCB6)],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _buildAnimatedHeader(context, 0),
            const SizedBox(height: 24),

            // Card 1 — Discover Places
            _buildAnimatedExploreCard(
              context: context,
              index: 1,
              title: 'Discover Places',
              subtitle: 'Explore tourist spots in the city',
              icon: Icons.place_rounded,
              color: const Color(0xFFA1BC98),
              onTap: () {
                Navigator.of(context).pushNamed(
                  AppRouter.spotList,
                  arguments: sampleCityId,
                );
              },
            ),
            const SizedBox(height: 16),

            // Card 2 — My Memories
            _buildAnimatedExploreCard(
              context: context,
              index: 2,
              title: 'My Memories',
              subtitle: 'View & manage your travel scrapbook',
              icon: Icons.photo_album_rounded,
              color: const Color(0xFF778873),
              onTap: () {
                Navigator.of(context).pushNamed(AppRouter.memoryList);
              },
            ),
            const SizedBox(height: 16),

            // Card 3 — My Itinerary (NEW)
            _buildAnimatedExploreCard(
              context: context,
              index: 3,
              title: 'My Itinerary',
              subtitle: 'Plan and organize your trip',
              icon: Icons.playlist_add_check_rounded,
              color: const Color(0xFF556B2F),
              onTap: () {
                Navigator.of(context).pushNamed(AppRouter.itinerary);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedHeader(BuildContext context, int index) {
    final safeIndex = index.clamp(0, _slideAnimations.length - 1);
    return SlideTransition(
      position: _slideAnimations[safeIndex],
      child: FadeTransition(
        opacity: _cardAnimations[safeIndex],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF778873).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.travel_explore,
                    size: 32,
                    color: Color(0xFF778873),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome Back!',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF778873),
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Where will you explore today?',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: const Color(0xFF778873).withOpacity(0.7),
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedExploreCard({
    required BuildContext context,
    required int index,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    final safeIndex = index.clamp(0, _slideAnimations.length - 1);
    return SlideTransition(
      position: _slideAnimations[safeIndex],
      child: FadeTransition(
        opacity: _cardAnimations[safeIndex],
        child: _ExploreCard(
          title: title,
          subtitle: subtitle,
          icon: icon,
          color: color,
          onTap: onTap,
        ),
      ),
    );
  }
}

class _ExploreCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ExploreCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  State<_ExploreCard> createState() => _ExploreCardState();
}

class _ExploreCardState extends State<_ExploreCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        transform: Matrix4.identity()..scale(_isPressed ? 0.97 : 1.0),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                widget.color,
                widget.color.withOpacity(0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: widget.color.withOpacity(0.4),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  widget.icon,
                  size: 32,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.subtitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withOpacity(0.9),
                          ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
