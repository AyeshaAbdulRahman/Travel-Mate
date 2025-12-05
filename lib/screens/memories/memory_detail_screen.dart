import 'dart:io';
import 'package:flutter/foundation.dart'; // Required for kIsWeb
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/memory/memory_bloc.dart';
import '../../blocs/memory/memory_event.dart';
import '../../models/memory.dart';
import '../../utils/date_formatter.dart';

class MemoryDetailScreen extends StatelessWidget {
  final int keyId;
  final Memory memory;

  const MemoryDetailScreen({
    Key? key,
    required this.keyId,
    required this.memory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(memory.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _delete(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ✅ CORRECTED IMAGE LOGIC
            // Priority 1: Use Image.memory if imageBytes are available (best for Web/Persistence)
            if (memory.imageBytes != null && memory.imageBytes!.isNotEmpty)
              SizedBox(
                height: 320,
                width: double.infinity,
                child: Image.memory(
                  memory.imageBytes!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: const Center(
                        child: Text(
                          'Error loading image bytes',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    );
                  },
                ),
              )
            // Priority 2: Fallback to Image.network/Image.file if only imagePath is available
            else if (memory.imagePath.isNotEmpty)
              SizedBox(
                height: 320,
                width: double.infinity,
                child: kIsWeb
                    ? Image.network(
                        memory.imagePath,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          // Placeholder for Web when Image.network fails
                          return Container(
                            color: Colors.grey[300],
                            child: const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.broken_image,
                                    size: 50,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Image Failed to Load (Path/Web)',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    : Image.file(
                        // Image.file is used for Mobile/Desktop platforms
                        File(memory.imagePath),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          // Placeholder for Mobile/Desktop when Image.file fails
                          return Container(
                            color: Colors.grey[300],
                            child: const Center(
                              child: Icon(
                                Icons.broken_image,
                                size: 50,
                                color: Colors.grey,
                              ),
                            ),
                          );
                        },
                      ),
              ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    memory.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),

                  /// CITY + DATE
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 18,
                        color: Colors.green,
                      ),
                      const SizedBox(width: 4),
                      Text(memory.cityName),
                      const SizedBox(width: 12),
                      const Icon(
                        Icons.calendar_today,
                        size: 18,
                        color: Colors.blueGrey,
                      ),
                      const SizedBox(width: 4),
                      Text(DateFormatter.format(memory.date)),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Text(
                    memory.caption,
                    style: const TextStyle(fontSize: 16, height: 1.4),
                  ),

                  const SizedBox(height: 12),
                  if (memory.tags.isNotEmpty)
                    Wrap(
                      spacing: 8,
                      children: memory.tags
                          .map((t) => Chip(label: Text(t)))
                          .toList(),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _delete(BuildContext context) {
    context.read<MemoryBloc>().add(DeleteMemoryEvent(keyId));
    Navigator.of(context).pop();
  }
}
