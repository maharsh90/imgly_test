import 'dart:io';

import 'package:catalog_ui/example_item.dart';
import 'package:flutter/material.dart' hide Theme;
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:imgly_sdk/imgly_sdk.dart';
import 'package:path_provider/path_provider.dart';
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
  String? image;

  void _updateImage(String? imageChild) {
    setState(() {
      image = imageChild;
    });
    print("Image path is: ${image}");
  }

  @override
  Widget build(BuildContext context) {
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
              title: "Open photo editor",
              description:
                  "Open the photo editor with user interface customizations.",
              onImagePicked: _updateImage,
              onTap: () {
                _openPESDK;
                invoke();
              } // You can add specific logic here
              ),
          ExampleItem(
              title: "Open video editor",
              description:
                  "Open the video editor with user interface customizations.",
              onTap: () {
                _openVESDK;
              })
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
          image: "assets/LA.jpg", configuration: configuration);
      print(result?.image);
      invoke();
    } catch (e) {
      print(e);
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
  //         image: image,
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

  //working

  // void invoke() async {
  //   try {
  //     final outputDirectory = await getTemporaryDirectory();
  //     final filepath =
  //         "${outputDirectory.path}/export${Platform.isAndroid ? ".png" : ""}";

  //     final result = await PESDK.openEditor(
  //       image: image,
  //       configuration: Configuration(export: ExportOptions(filename: filepath)),
  //     );

  //     if (result != null) {
  //       final File imageFile = File(result.image);
  //       final savedImage = await saveImageToGallery(imageFile);
  //       print("Image saved to gallery: $savedImage");
  //     } else {
  //       print("No image exported.");
  //     }
  //   } catch (error) {
  //     print("Error: $error");
  //   }
  // }

  // Future<String?> saveImageToGallery(File imageFile) async {
  //   try {
  //     final result = await ImageGallerySaver.saveFile(imageFile.path);
  //     return result['filePath'];
  //   } on PlatformException catch (e) {
  //     print("Failed to save image to gallery: $e");
  //     return null;
  //   }
  // }

  Future<void> invoke() async {
    try {
      final result = await PESDK.openEditor(
        image: image,
        configuration: Configuration(export: ExportOptions()),
      );

      if (result != null) {
        final downloadPath = await getDownloadPath();
        if (downloadPath != null) {
          final savedFilePath =
              await saveImageToDownloadPath(result.image, downloadPath);
          print("Image saved at: $savedFilePath");
        } else {
          print("Failed to get the download path.");
        }
      } else {
        print("Image export was canceled.");
      }
    } catch (error) {
      print("Error: $error");
    }
  }

  Future<String?> getDownloadPath() async {
    try {
      Directory? downloadsDirectory;

      if (Platform.isAndroid) {
        downloadsDirectory = Directory('/storage/emulated/0/Download');
      } else if (Platform.isIOS) {
        downloadsDirectory =
            await getApplicationDocumentsDirectory(); // iOS doesn't have a public "Downloads" folder
      }

      if (downloadsDirectory != null && !await downloadsDirectory.exists()) {
        await downloadsDirectory.create(recursive: true);
      }
      return downloadsDirectory?.path;
    } catch (e) {
      print("Error getting download path: $e");
      return null;
    }
  }

  Future<String?> saveImageToDownloadPath(
      String imagePath, String downloadPath) async {
    try {
      final File imageFile = File(imagePath);
      final newPath = '$downloadPath/exported_image.png';
      final File newFile = await imageFile.copy(newPath);
      return newFile.path;
    } catch (e) {
      print("Error saving image to download path: $e");
      return null;
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
