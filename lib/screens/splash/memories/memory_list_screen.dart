import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/memory/memory_bloc.dart';
import '../../blocs/memory/memory_event.dart';
import '../../blocs/memory/memory_state.dart';
import '../../widgets/memory_card.dart';
import '../../widgets/empty_state.dart';

class MemoryListScreen extends StatefulWidget {
  const MemoryListScreen({Key? key}) : super(key: key);

  @override
  State<MemoryListScreen> createState() => _MemoryListScreenState();
}

class _MemoryListScreenState extends State<MemoryListScreen> {
  // ignore: unused_field
  String _filterCity = '';

  @override
  void initState() {
    super.initState();
    // Refresh memories when screen loads
    context.read<MemoryBloc>().add(LoadMemories());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Use the background color from your theme
      backgroundColor: const Color(0xFFF1F3E0), 
      appBar: AppBar(
        title: const Text('Memories'),
        backgroundColor: const Color(0xFFF1F3E0),
        elevation: 0,
      ),
      body: Column(
        children: [
          // 🔍 FILTER BAR
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Filter by city',
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: (v) => _filter(v),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.refresh, color: Color(0xFF778873)),
                  onPressed: () =>
                      context.read<MemoryBloc>().add(LoadMemories()),
                ),
              ],
            ),
          ),

          // 📋 LIST VIEW (Changed from GridView)
          Expanded(
            child: BlocBuilder<MemoryBloc, MemoryState>(
              builder: (context, state) {
                if (state is MemoryLoading || state is MemoryInitial) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is MemoryEmpty) {
                  return const EmptyState(
                    message: 'No memories yet. Tap + to add one',
                  );
                }

                if (state is MemoryError) {
                  return Center(child: Text('Error: ${state.message}'));
                }

                if (state is MemoryLoaded) {
                  final list = state.memories;

                  // CHANGED: From GridView to ListView
                  return ListView.builder(
                    padding: const EdgeInsets.only(bottom: 80), // Space for FAB
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final entry = list[index];

                      return MemoryCard(
                        keyId: entry.key,
                        memory: entry.value,
                        // Passing title/desc explicitly as requested by your widget signature
                        title: entry.value.title,
                        description: entry.value.caption,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            "/memories/detail",
                            arguments: {
                              "keyId": entry.key,
                              "memory": entry.value,
                            },
                          );
                        },
                      );
                    },
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF778873),
        onPressed: () => Navigator.of(context).pushNamed('/memories/add'),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _filter(String city) {
    if (city.trim().isEmpty) {
      context.read<MemoryBloc>().add(LoadMemories());
    } else {
      context.read<MemoryBloc>().add(FilterByCityEvent(city.trim()));
    }
  }
}