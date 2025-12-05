// ignore: unused_import
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:smd_project_travelmate/models/memory.dart';

class MemoryCard extends StatelessWidget {
  final Memory memory;
  final VoidCallback onTap;

  const MemoryCard({
    super.key,
    required this.memory,
    required this.onTap, required int keyId, required String title, required String description,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // --- IMAGE ---
            _buildImage(),

            const SizedBox(width: 12),

            // --- TEXT AREA ---
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // TITLE
                    Text(
                      memory.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 6),

                    // DESCRIPTION
                    Text(
                      memory.caption,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),

                    const SizedBox(height: 8),

                    // EXTRA INFO
                    if (memory.formattedCity != null &&
                        memory.formattedCity!.isNotEmpty)
                      Text("📍 ${memory.formattedCity}",
                          style: TextStyle(color: Colors.grey[600])),

                    if (memory.formattedDate != null &&
                        memory.formattedDate!.isNotEmpty)
                      Text("📅 ${memory.formattedDate}",
                          style: TextStyle(color: Colors.grey[600])),

                    if (memory.formattedTime != null &&
                        memory.formattedTime!.isNotEmpty)
                      Text("⏰ ${memory.formattedTime}",
                          style: TextStyle(color: Colors.grey[600])),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// IMAGE BUILDER → Supports web + mobile
  Widget _buildImage() {
    if (memory.imageBytes != null) {
      return ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(14),
          bottomLeft: Radius.circular(14),
        ),
        child: Image.memory(
          memory.imageBytes!,
          width: 100,
          height: 100,
          fit: BoxFit.cover,
        ),
      );
    }

    if (memory.imagePath.isNotEmpty) {
      return ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(14),
          bottomLeft: Radius.circular(14),
        ),
        child: Image.network(
          memory.imagePath,
          width: 100,
          height: 100,
          fit: BoxFit.cover,
        ),
      );
    }

    return Container(
      width: 100,
      height: 100,
      decoration: const BoxDecoration(
        color: Color(0xffeeeeee),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(14),
          bottomLeft: Radius.circular(14),
        ),
      ),
      child: const Icon(Icons.image_not_supported, size: 40),
    );
  }
}
