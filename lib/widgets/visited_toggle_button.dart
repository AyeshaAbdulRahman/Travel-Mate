import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/spot/spot_bloc.dart';
import '../blocs/spot/spot_event.dart'; // ✅ ADD THIS IMPORT

class VisitedToggleButton extends StatelessWidget {
  final String spotId;
  final bool isInitiallyVisited;
  final String? visitedDate;
  final List<String>? userPhotos;

  const VisitedToggleButton({
    Key? key,
    required this.spotId,
    required this.isInitiallyVisited,
    this.visitedDate,
    this.userPhotos,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Visited Toggle Button
        ElevatedButton.icon(
          onPressed: () {
            final bloc = context.read<SpotBloc>();
            if (isInitiallyVisited) {
              // ✅ FIXED: Use actual event class
              bloc.add(MarkSpotNotVisited(spotId));
            } else {
              // ✅ FIXED: Use actual event class
              bloc.add(MarkSpotVisited(spotId));
            }
          },
          icon: Icon(
            isInitiallyVisited ? Icons.check_circle : Icons.location_on_outlined,
            color: isInitiallyVisited ? Colors.green : Colors.blue,
          ),
          label: Text(
            isInitiallyVisited ? '✓ VISITED' : 'MARK AS VISITED',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isInitiallyVisited ? Colors.green : Colors.blue,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: isInitiallyVisited ? Colors.green[50] : Colors.blue[50],
            elevation: 2,
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
        ),
        
        SizedBox(height: 8),
        
        // Show visited date if visited
        if (isInitiallyVisited && visitedDate != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              'Visited on: ${_formatDate(visitedDate!)}',
              style: TextStyle(
                color: Colors.green[700],
                fontSize: 12,
              ),
            ),
          ),
        
        SizedBox(height: 16),
        
        // Photos Section
        if (isInitiallyVisited)
          _buildPhotosSection(context),
      ],
    );
  }
  
  Widget _buildPhotosSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Photos:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        SizedBox(height: 8),
        
        // Add photo button
        GestureDetector(
          onTap: () => _addPhoto(context),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue, style: BorderStyle.solid),
              color: Colors.blue[50],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_a_photo, color: Colors.blue, size: 40),
                SizedBox(height: 8),
                Text(
                  'Add your photo',
                  style: TextStyle(color: Colors.blue),
                ),
              ],
            ),
          ),
        ),
        
        // Show existing photos if any
        if (userPhotos != null && userPhotos!.isNotEmpty)
          Column(
            children: [
              SizedBox(height: 16),
              Text(
                '${userPhotos!.length} photo(s) added',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
      ],
    );
  }
  
  void _addPhoto(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Photo upload will be implemented soon!')),
    );
  }
  
  String _formatDate(String isoDate) {
    try {
      final date = DateTime.parse(isoDate);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return isoDate;
    }
  }
}
// ✅ REMOVED: _SpotEvent class and helper methods