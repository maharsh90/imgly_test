import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ExampleItem extends StatefulWidget {
  const ExampleItem({
    super.key,
    required this.title,
    required this.description,
    required this.onTap,
    this.onImagePicked,
  });

  final String title;
  final String description;
  final VoidCallback onTap; // Action when item is tapped
  final Function(File)? onImagePicked; // Callback to pass image to parent

  @override
  State<ExampleItem> createState() => _ExampleItemState();
}

class _ExampleItemState extends State<ExampleItem> {
  final ImagePicker _picker = ImagePicker();
  bool _isPicking = false; // Flag to prevent multiple requests

  Future<void> _pickImage() async {
    if (_isPicking) return; // Prevents multiple requests

    setState(() {
      _isPicking =
          true; // Set the flag to true to indicate an image is being picked
    });

    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final image = File(pickedFile.path);
        widget.onImagePicked?.call(image); // Pass image to parent
      } else {
        print("No image selected.");
      }
    } catch (e) {
      print("Error picking image: $e");
    } finally {
      setState(() {
        _isPicking = false; // Reset the flag
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _pickImage(); // Start picking the image when the item is tapped
        widget.onTap(); // Call the additional tap logic from parent
      },
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.black12,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 5),
            Text(widget.description),
          ],
        ),
      ),
    );
  }
}
