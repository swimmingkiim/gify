import 'package:cross_file/cross_file.dart';
import 'package:flutter/services.dart';
import 'package:gify/gify.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'gify_method_channel.dart';

abstract class GifyPlatform extends PlatformInterface {
  /// Constructs a GifyPlatform.
  GifyPlatform() : super(token: _token);

  static final Object _token = Object();

  static GifyPlatform _instance = MethodChannelGify();

  /// The default instance of [GifyPlatform] to use.
  ///
  /// Defaults to [MethodChannelGify].
  static GifyPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [GifyPlatform] when
  /// they register themselves.
  static set instance(GifyPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<List<Uint8List>?> getFramesBytes(
    XFile videoFile, {
    int fps = 1,
  }) async {
    throw UnimplementedError('createGifFromVideo() has not been implemented.');
  }

  Future<Uint8List?> createGifFromVideo(
    XFile videoFile, {
    int fps = 1,
    int? width,
    int? height,
    bool forceOriginalAspectRatio = true,
    List<GifyTextMessage>? textMessages,
  }) async {
    throw UnimplementedError('createGifFromVideo() has not been implemented.');
  }

  Future<Uint8List?> createGifFromImages(
    List<XFile> imageFiles, {
    int fps = 1,
    int? width,
    int? height,
    bool forceOriginalAspectRatio = true,
    List<GifyTextMessage>? textMessages,
  }) async {
    throw UnimplementedError('createGifFromImages() has not been implemented.');
  }
}
