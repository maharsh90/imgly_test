import 'dart:io';

import 'package:catalog_ui/example_item.dart';
import 'package:flutter/material.dart' hide Theme;
import 'package:image_picker/image_picker.dart';
import 'package:imgly_sdk/imgly_sdk.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_editor_sdk/photo_editor_sdk.dart';
import 'package:video_editor_sdk/video_editor_sdk.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'IMG.LY for Flutter',
      home: MyHomePage(title: 'IMG.LY for Flutter'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  /// The [title] of the app bar.
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? image;

  // Callback function to receive the image from the child
  void _updateImage(File? imageChild) {
    setState(() {
      image = imageChild;
    });
  }

  @override
  Widget build(BuildContext context) {
    print("image path is: ${image?.path}");
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: const TextStyle(color: Colors.black)),
        backgroundColor: Colors.white12,
        shadowColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.only(top: 5, bottom: 25),
        children: [
          ExampleItem(
              "Open photo editor",
              "Open the photo editor with user interface customizations.",
              onImagePicked: _updateImage,
              _openPESDK),
          ExampleItem(
              "Open video editor",
              "Open the video editor with user interface customizations.",
              _openVESDK)
        ],
      ),
    );
  }

  // highlight-theme
  final Configuration configuration = Configuration(
      theme: ThemeOptions(Theme("CUSTOM_THEME",
          primaryColor: Colors.white,
          tintColor: const Color.fromARGB(255, 61, 92, 245),
          toolbarBackgroundColor: const Color.fromARGB(255, 47, 51, 55),
          menuBackgroundColor: const Color.fromARGB(255, 33, 39, 44),
          backgroundColor: const Color.fromARGB(255, 18, 26, 33))));
  // highlight-theme

  void _openPESDK() async {
    try {
      final result = await PESDK.openEditor(
          image: image!.path.toString(), configuration: configuration);
      print(result?.image);
    } catch (e) {
      print(e);
    }
  }

  void _openVESDK() async {
    try {
      final result = await VESDK.openEditor(Video("assets/Skater.mp4"),
          configuration: configuration);
      print(result?.video);
    } catch (e) {
      print(e);
    }
  }
}
