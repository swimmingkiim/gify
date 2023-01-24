import 'package:cross_file/cross_file.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:gify/web/gif_repository_web_function.dart';
import 'package:gify/web/import_js_files.dart';
import 'package:gify/web/video_repository_web_function.dart';

import 'gify_platform_interface.dart';

/// A web implementation of the GifyPlatform of the Gify plugin.
class GifyWeb extends GifyPlatform {
  /// Constructs a GifyWeb
  GifyWeb();

  static void registerWith(Registrar registrar) {
    initializeJSFiles();
    GifyPlatform.instance = GifyWeb();
  }

  static void initializeJSFiles() {
    importJSFiles();
  }

  @override
  Future<List<Uint8List>?> getFramesBytes(XFile videoFile, int fps) async {
    final frames = await getFramesBytesFromVideo(videoFile.path, fps);
    return frames;
  }

  @override
  Future<Uint8List?> createGifFromVideo(
    XFile videoFile,
    int fps,
  ) async {
    final gifBytes = await getGifBytesFromVideo(videoFile.path, fps);
    return gifBytes;
  }

  @override
  Future<Uint8List?> createGifFromImages(
    List<XFile> imageFiles,
    int fps,
  ) async {
    final imagePathsWithType = imageFiles.map<List<String>>((file) {
      final fileType =
          file.mimeType == null ? 'unknown' : file.mimeType!.split('/').last;
      return List<String>.from([file.path, fileType]);
    }).toList();
    final gifBytes = await getGifBytesFromImages(imagePathsWithType, fps);
    return gifBytes;
  }
}
