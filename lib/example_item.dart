import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_editor_sdk/photo_editor_sdk.dart';
import 'package:imgly_sdk/imgly_sdk.dart';
import 'package:flutter/material.dart' hide Theme;

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
  final Function(String)? onImagePicked; // Callback to pass image to parent

  @override
  State<ExampleItem> createState() => _ExampleItemState();
}

class _ExampleItemState extends State<ExampleItem> {
  final ImagePicker _picker = ImagePicker();
  bool _isPicking = false; // Flag to prevent multiple requests
  String? imagePath;

  // Future<void> _pickImage() async {
  //   if (_isPicking) return; // Prevents multiple requests

  //   setState(() {
  //     _isPicking =
  //         true; // Set the flag to true to indicate an image is being picked
  //   });

  //   try {
  //     final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
  //     if (pickedFile != null) {
  //       final image = File(pickedFile.path);
  //       widget.onImagePicked?.call(image); // Pass image to parent
  //     } else {
  //       print("No image selected.");
  //     }
  //   } catch (e) {
  //     print("Error picking image: $e");
  //   } finally {
  //     setState(() {
  //       _isPicking = false; // Reset the flag
  //     });
  //   }
  // }

  Future<void> pickedImage() async {
    try {
      // Select an image from the gallery using the [ImagePicker].
      final imagePicker = ImagePicker();
      final image = await imagePicker.pickImage(source: ImageSource.gallery);
      imagePath = image?.path;
      if (imagePath == null) return;

      // Open the photo editor and handle the export as well as any occurring errors.
      final result = await PESDK.openEditor(image: imagePath);

      if (result != null) {
        // The user exported a new photo successfully and the newly generated photo is located at `result.image`.
        print(result.image);
        widget.onImagePicked?.call(result.image);
      } else {
        // The user exported a new photo successfully and the newly generated photo is located at `result.image`.
        return;
      }
    } catch (error) {
      // The user exported a new photo successfully and the newly generated photo is located at `result.image`.
      print(error);
    }
  }

  // void invoke() async {
  //   try {
  //     final outputDirectory = await getTemporaryDirectory();
  //     final filepath =
  //         "${outputDirectory.uri}export${Platform.isAndroid ? ".png" : ""}";
  //     // final configuration =
  //     //     Configuration(export: ExportOptions(filename: filepath));

  //     // Open the photo editor and handle the export as well as any occurring errors.
  //     final result = await PESDK.openEditor(
  //         image: imagePath,
  //         configuration:
  //             Configuration(export: ExportOptions(filename: filepath)));

  //     if (result != null) {
  //       // The user exported a new photo successfully and the newly generated photo is located at `result.image`.
  //       print(result.image);
  //     } else {
  //       // The user exported a new photo successfully and the newly generated photo is located at `result.image`.
  //       return;
  //     }
  //   } catch (error) {
  //     // The user exported a new photo successfully and the newly generated photo is located at `result.image`.
  //     print(error);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        pickedImage();
        // _pickImage(); // Start picking the image when the item is tapped
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

// Future<void> pickedImage() async {
//   try {
//     // Select an image from the gallery using the [ImagePicker].
//     final imagePicker = ImagePicker();
//     final image = await imagePicker.pickImage(source: ImageSource.gallery);
//     final imagePath = image?.path;
//     if (imagePath == null) return;

//     // Open the photo editor and handle the export as well as any occurring errors.
//     final result = await PESDK.openEditor(image: imagePath);

//     if (result != null) {
//       // The user exported a new photo successfully and the newly generated photo is located at `result.image`.
//       print(result.image);
//     } else {
//       // The user exported a new photo successfully and the newly generated photo is located at `result.image`.
//       return;
//     }
//   } catch (error) {
//     // The user exported a new photo successfully and the newly generated photo is located at `result.image`.
//     print(error);
//   }
// }


