import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smd_project_travelmate/blocs/itinerary/itinerary_bloc.dart';
import 'package:smd_project_travelmate/blocs/itinerary/itinerary_state.dart';
import 'package:smd_project_travelmate/blocs/itinerary/itinerary_event.dart';
import 'package:smd_project_travelmate/models/itinerary_item.dart';
import 'package:smd_project_travelmate/widgets/custom_appbar.dart';

class ItineraryScreen extends StatelessWidget {
  const ItineraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure itinerary is loaded when screen opens
    context.read<ItineraryBloc>().add(LoadItinerary());

    return Scaffold(
      appBar: const CustomAppBar(title: 'My Itinerary'),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF1F3E0), Color(0xFFD2DCB6)],
          ),
        ),
        child: BlocBuilder<ItineraryBloc, ItineraryState>(
          builder: (context, state) {
            if (state.items.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'No spots in your itinerary yet.\nAdd some from the spot details screen.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: const Color(0xFF778873),
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
              );
            }

            final total = state.items.length;

            return ReorderableListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: total,
              buildDefaultDragHandles: false, // 👈 we use our own handle
              onReorder: (oldIndex, newIndex) {
                if (newIndex > oldIndex) newIndex--;
                final items = List<ItineraryItem>.from(state.items);
                final moved = items.removeAt(oldIndex);
                items.insert(newIndex, moved);

                final updated = items
                    .asMap()
                    .entries
                    .map((e) => e.value.copyWith(order: e.key))
                    .toList();

                context
                    .read<ItineraryBloc>()
                    .add(ReorderItinerary(updated));
              },
              itemBuilder: (context, index) {
                final item = state.items[index];

                // 👇 Compute a color that fades as we go down
                // t = 0 for first item, 1 for last item
                final t = total == 1 ? 0.0 : index / (total - 1);
                final Color startColor =
                    const Color(0xFFA1BC98).withOpacity(0.35);
                final Color endColor = Colors.white;
                final Color cardColor = Color.lerp(startColor, endColor, t)!;

                return Container(
                  key: ValueKey(item.id),
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF778873).withOpacity(0.12),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    border: Border.all(
                      color: const Color(0xFFA1BC98).withOpacity(0.25),
                      width: 1,
                    ),
                  ),
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        item.imageUrl,
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 56,
                          height: 56,
                          color: Colors.grey.shade300,
                          child: const Icon(Icons.image),
                        ),
                      ),
                    ),
                    title: Text(
                      item.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF43503E),
                          ),
                    ),
                    subtitle: Text(
                      'Stop ${index + 1} • ${item.cityId}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: const Color(0xFF778873).withOpacity(0.8),
                          ),
                    ),

                    // 👇 Custom drag handle (hamburger) – user drags from this only
                    trailing: ReorderableDragStartListener(
                      index: index,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  const Color(0xFF778873).withOpacity(0.15),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.drag_handle_rounded,
                          color: Color(0xFF778873),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
