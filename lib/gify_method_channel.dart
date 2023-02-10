import 'package:cross_file/cross_file.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:gify/gify.dart';

import 'gify_platform_interface.dart';

/// An implementation of [GifyPlatform] that uses method channels.
class MethodChannelGify extends GifyPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('gify');

  @override
  Future<List<Uint8List>?> getFramesBytes(
    XFile videoFile, {
    int fps = 1,
  }) async {
    final frames = await methodChannel
        .invokeMethod<List<Uint8List>>('getFramesBytes', [videoFile, fps]);
    return frames;
  }

  @override
  Future<Uint8List?> createGifFromVideo(
    XFile videoFile, {
    int fps = 1,
    int? width,
    int? height,
    bool forceOriginalAspectRatio = true,
    List<GifyTextMessage>? textMessages,
  }) async {
    final gifBytes = await methodChannel
        .invokeMethod<Uint8List>('createGifFromVideo', <String, dynamic>{
      'videoFile': videoFile,
      'fps': fps,
      'width': width,
      'height': height,
      'forceOriginalAspectRatio': forceOriginalAspectRatio,
      'textMessages': textMessages,
    });
    return gifBytes;
  }

  @override
  Future<Uint8List?> createGifFromImages(
    List<XFile> imageFiles, {
    int fps = 1,
    int? width,
    int? height,
    bool forceOriginalAspectRatio = true,
    List<GifyTextMessage>? textMessages,
  }) async {
    final gifBytes = await methodChannel
        .invokeMethod<Uint8List>('createGifFromImages', <String, dynamic>{
      'imageFiles': imageFiles,
      'fps': fps,
      'width': width,
      'height': height,
      'forceOriginalAspectRatio': forceOriginalAspectRatio,
      'textMessages': textMessages,
    });
    return gifBytes;
  }
}
