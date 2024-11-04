import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ExampleItem extends StatefulWidget {
  const ExampleItem(this.title, this.description, this.onTap,
      {super.key, this.onImagePicked});

  /// The title of the example.
  final String title;

  final Function(File)? onImagePicked; // Callback to pass image to parent

  /// The description of the example.
  final String description;

  /// The action when the item is tapped.
  final VoidCallback onTap;

  @override
  State<ExampleItem> createState() => _ExampleItemState();
}

XFile? pickedFile;

class _ExampleItemState extends State<ExampleItem> {
  List<XFile?>? pickedFilesListStore = [];
  File? image;
  bool _isPicking = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _pickImage();
  }

  /** Picking an image manually from the gallery**/

  Future<void> _pickImage() async {
    if (_isPicking) return; // Prevents multiple requests

    setState(() {
      _isPicking = true;
    });
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        widget.onImagePicked
            ?.call(File(pickedFile.path)); // Call parent callback
      } else {
        print("No image selected.");
      }
    } catch (e) {
      print("Error picking image: $e");
    } finally {
      setState(() {
        _isPicking = false;
      });
    }
  }
  // Future<void> pickedImage(ImageSource source) async {
  //   if (_isPicking) return; // Prevents multiple requests

  //   setState(() {
  //     _isPicking = true;
  //   });
  //   try {
  //     final pickedFile = await ImagePicker().pickImage(source: source);

  //     if (pickedFile == null) {
  //       // Handle dismissal of picker without closing any screen
  //       setState(() {
  //         // Optionally show a message or keep the UI unchanged
  //       });
  //     } else {
  //       setState(() {
  //         // image = File(pickedFile.path);
  //         widget.onImagePicked!(File(pickedFile.path));
  //       });
  //       pickedFilesListStore?.add(pickedFile);
  //     }
  //   } catch (e) {
  //     // Handle any potential errors, such as permission issues
  //     print('Error picking image: $e');
  //     setState(() {
  //       // Optionally update the UI to show an error message
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          _pickImage(); // Trigger image picking
          widget.onTap(); // Execute any additional tap action from parent
        },
        child: Container(
          margin: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: Colors.black12),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              widget.title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 5),
            Text(widget.description)
          ]),
        ));
  }
}
