import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class EmptyState extends StatelessWidget {
  final String message;
  const EmptyState({Key? key, this.message = 'No items yet.'}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.photo_album, size: 84, color: AppTheme.textColor),
          const SizedBox(height: 12),
          Text(message, style: const TextStyle(color: AppTheme.textColor), textAlign: TextAlign.center),
        ]),
      ),
    );
  }
}
