import 'package:cross_file/cross_file.dart';
import 'package:flutter/services.dart';
import 'package:gify/gify_platform_interface.dart';
import 'package:gify/native/gif_repository_native.dart';
import 'package:gify/native/video_repository_native.dart';

class GifyNative extends GifyPlatform {
  final GifRepositoryNative gifRepositoryNative = GifRepositoryNative();
  final VideoRepositoryNative videoRepositoryNative = VideoRepositoryNative();

  /// Registers this class as the default instance of [HelloPluginPlatform].
  static void registerWith() {
    GifyPlatform.instance = GifyNative();
  }

  @override
  Future<List<Uint8List>?> getFramesBytes(XFile videoFile, int fps) async {
    final frames =
        await videoRepositoryNative.getFramesFromVideo(videoFile, fps);
    return frames;
  }

  @override
  Future<Uint8List?> createGifFromVideo(
    XFile videoFile,
    int fps,
  ) async {
    final gifBytes =
        await gifRepositoryNative.createGifFromVideo(videoFile, fps);
    return gifBytes;
  }

  @override
  Future<Uint8List?> createGifFromImages(
    List<XFile> imageFiles,
    int fps,
  ) async {
    final gifBytes =
        await gifRepositoryNative.createGifFromImages(imageFiles, fps);
    return gifBytes;
  }
}
