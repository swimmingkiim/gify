// import 'package:cross_file/cross_file.dart';
// import 'package:flutter/services.dart';

import 'package:cross_file/cross_file.dart';
import 'package:flutter/services.dart';

import 'gify_platform_interface.dart';

export 'gify_native.dart';

class Gify {
  Future<List<Uint8List>?> getFramesBytes(XFile videoFile, int fps) async {
    return GifyPlatform.instance.getFramesBytes(videoFile, fps);
  }

  Future<Uint8List?> createGifFromVideo(
    XFile videoFile,
    int fps,
  ) async {
    return GifyPlatform.instance.createGifFromVideo(videoFile, fps);
  }

  Future<Uint8List?> createGifFromImages(
    List<XFile> imageFiles,
    int fps,
  ) async {
    return GifyPlatform.instance.createGifFromImages(imageFiles, fps);
  }
}
