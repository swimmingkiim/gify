// import 'package:cross_file/cross_file.dart';
// import 'package:flutter/services.dart';

import 'package:cross_file/cross_file.dart';
import 'package:flutter/services.dart';
import 'package:gify/gify_text_message.dart';

import 'gify_platform_interface.dart';

export 'gify_native.dart';
export 'gify_text_message.dart';

class Gify {
  Future<List<Uint8List>?> getFramesBytes(
    XFile videoFile, {
    int fps = 1,
  }) async {
    return GifyPlatform.instance.getFramesBytes(videoFile, fps: fps);
  }

  Future<Uint8List?> createGifFromVideo(
    XFile videoFile, {
    int fps = 1,
    int? width,
    int? height,
    bool forceOriginalAspectRatio = true,
    List<GifyTextMessage>? textMessages,
  }) async {
    return GifyPlatform.instance.createGifFromVideo(
      videoFile,
      fps: fps,
      width: width,
      height: height,
      forceOriginalAspectRatio: forceOriginalAspectRatio,
      textMessages: textMessages,
    );
  }

  Future<Uint8List?> createGifFromImages(
    List<XFile> imageFiles, {
    int fps = 1,
    int? width,
    int? height,
    bool forceOriginalAspectRatio = true,
    List<GifyTextMessage>? textMessages,
  }) async {
    return GifyPlatform.instance.createGifFromImages(
      imageFiles,
      fps: fps,
      width: width,
      height: height,
      forceOriginalAspectRatio: forceOriginalAspectRatio,
      textMessages: textMessages,
    );
  }
}
