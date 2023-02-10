import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import 'package:gify/gify.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _gifyPlugin = Gify();
  Uint8List? bytes;

  @override
  void initState() {
    super.initState();
  }

  Future<List<Uint8List>?> testFrames() async {
    final XFile? videoFile =
        await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (videoFile != null) {
      final result = await _gifyPlugin.getFramesBytes(videoFile, fps: 1);
      // Uncomment below code to see result
      setState(() {
        if (result != null) {
          bytes = result[0];
        }
      });
      return result;
    }
    return null;
  }

  Future<Uint8List?> testVideoToGif() async {
    final XFile? videoFile =
        await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (videoFile != null) {
      final result = await _gifyPlugin
          .createGifFromVideo(videoFile, fps: 1, height: 320, textMessages: [
        const GifyTextMessage(
          text: 'test111',
          fontColor: Color.fromRGBO(247, 24, 7, 1),
          fontSize: 30,
          x: 10.0,
          y: 310.0,
        ),
        const GifyTextMessage(
          text: 'test222',
          fontColor: Color.fromRGBO(7, 67, 247, 1),
          fontSize: 20,
          x: 30.0,
          y: 30.0,
        ),
      ]);
      // Uncomment below code to see result
      setState(() {
        if (result != null) {
          bytes = result;
        }
      });
      return result;
    }
    return null;
  }

  Future<Uint8List?> testImagesToGif() async {
    final List<XFile> imageFiles = await ImagePicker().pickMultiImage();
    final result = await _gifyPlugin.createGifFromImages(imageFiles,
        fps: 1,
        width: 300,
        height: 480,
        textMessages: [
          const GifyTextMessage(
            text: 'test111',
            fontColor: Color.fromRGBO(247, 24, 7, 1),
            fontSize: 30,
            x: 10.0,
            y: 10.0,
          ),
          const GifyTextMessage(
            text: 'test222',
            fontColor: Color.fromRGBO(7, 67, 247, 1),
            fontSize: 20,
            x: 30.0,
            y: 30.0,
          ),
        ]);
    // Uncomment below code to see result
    setState(() {
      if (result != null) {
        bytes = result;
      }
    });
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: [
            Center(
              child: InkWell(
                onTap: () => testFrames(),
                child: const Text('test getFramesBytes from video'),
              ),
            ),
            Center(
              child: InkWell(
                onTap: () => testVideoToGif(),
                child: const Text('test createGifFromVideo'),
              ),
            ),
            Center(
              child: InkWell(
                onTap: () => testImagesToGif(),
                child: const Text('test createGifFromImages'),
              ),
            ),
            if (bytes != null) Image.memory(bytes!)
          ],
        ),
      ),
    );
  }
}
