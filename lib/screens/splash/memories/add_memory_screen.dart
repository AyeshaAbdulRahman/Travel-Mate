import 'package:flutter/foundation.dart'; // Required for kIsWeb
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../blocs/memory/memory_bloc.dart';
import '../../blocs/memory/memory_event.dart';
import '../../models/memory.dart';

class AddMemoryScreen extends StatefulWidget {
  const AddMemoryScreen({super.key});

  @override
  State<AddMemoryScreen> createState() => _AddMemoryScreenState();
}

class _AddMemoryScreenState extends State<AddMemoryScreen> {
  final _title = TextEditingController();
  final _caption = TextEditingController();
  final _city = TextEditingController();

  DateTime? _selectedDate;

  // Image data variables
  Uint8List? _imageBytes; // For Web and Hive persistence
  String _imagePath = ''; // For Mobile/Desktop path saving

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      final bytes = await picked.readAsBytes();
      setState(() {
        _imageBytes = bytes;
        // On Mobile/Desktop, save the path for direct file access (optional, but good practice)
        if (!kIsWeb) {
          _imagePath = picked.path;
        } else {
          // On Web, the path is generally a temporary Blob URL that shouldn't be saved
          // but if you needed to save a URL, it would go here. We rely on bytes.
          _imagePath = '';
        }
      });
    }
  }

  Future<void> pickDate() async {
    final today = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: today,
      firstDate: DateTime(2000),
      lastDate: today,
    );

    if (pickedDate != null) {
      setState(() => _selectedDate = pickedDate);
    }
  }

  void saveMemory() {
    if (_title.text.isEmpty ||
        _caption.text.isEmpty ||
        _city.text.isEmpty ||
        _selectedDate == null ||
        _imageBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all fields and select an image"),
        ),
      );
      return;
    }

    final memory = Memory(
      title: _title.text,
      caption: _caption.text,
      // Save the path for mobile, bytes for universal persistence (web/mobile)
      imagePath: _imagePath,
      imageBytes: _imageBytes,
      cityName: _city.text,
      date: _selectedDate!,
      tags: [],
    );

    context.read<MemoryBloc>().add(AddMemoryEvent(memory));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Memory")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// TITLE
            TextField(
              controller: _title,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            const SizedBox(height: 12),

            /// CAPTION
            TextField(
              controller: _caption,
              decoration: const InputDecoration(labelText: "Caption"),
              maxLines: 2,
            ),
            const SizedBox(height: 12),

            /// CITY NAME
            TextField(
              controller: _city,
              decoration: const InputDecoration(labelText: "City Name"),
            ),
            const SizedBox(height: 12),

            /// DATE PICKER
            Row(
              children: [
                Expanded(
                  child: Text(
                    _selectedDate == null
                        ? "No date selected"
                        : "Date: ${_selectedDate!.toLocal()}".split(' ')[0],
                  ),
                ),
                ElevatedButton(
                  onPressed: pickDate,
                  child: const Text("Pick Date"),
                ),
              ],
            ),
            const SizedBox(height: 20),

            /// IMAGE PICKER
            GestureDetector(
              onTap: pickImage,
              child: Center(
                child: Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: _imageBytes == null
                      ? const Center(child: Text("Select image"))
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          // Display using Image.memory from the bytes we saved
                          child: Image.memory(_imageBytes!, fit: BoxFit.cover),
                        ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// SAVE BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: saveMemory,
                child: const Text("Save Memory"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
