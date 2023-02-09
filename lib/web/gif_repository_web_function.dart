@JS()
library gif_repository_web_function; //Not avoid the library annotation

// dart
import 'dart:async';
import 'dart:typed_data';

// package
import 'package:universal_html/html.dart';
import 'package:js/js.dart' show JS;

@JS('getGifFromVideo')
external getGifFromVideo(
  String path,
  int fps,
  int width,
  int height,
  bool forceOriginalAspectRatio,
  Function onEnd,
);

@JS('getGifFromImages')
external getGifFromImages(
  List<List<String>> imagePaths,
  int fps,
  int width,
  int height,
  bool forceOriginalAspectRatio,
  Function onEnd,
);

Future<Uint8List> getGifBytesFromVideo(
  String path, {
  int fps = 1,
  int? width,
  int? height,
  bool forceOriginalAspectRatio = true,
}) async {
  String basePath = 'assets/packages/gify/assets/web/js';
  // web worker
  final worker = Worker('$basePath/gif_repository_web_video_worker.dart.js');

  worker.postMessage({
    'path': path,
    'fps': fps,
    'width': width,
    'height': height,
    'forceOriginalAspectRatio': forceOriginalAspectRatio,
  });
  final result = await worker.onMessage.first;
  return Uint8List.fromList(result.data);
}

Future<Uint8List> getGifBytesFromImages(
  List<List<String>> imagePaths, {
  int fps = 1,
  int? width,
  int? height,
  bool forceOriginalAspectRatio = true,
}) async {
  String basePath = 'assets/packages/gify/assets/web/js';
  // web worker
  final worker = Worker('$basePath/gif_repository_web_images_worker.dart.js');

  worker.postMessage({
    'imagePaths': imagePaths,
    'fps': fps,
    'width': width,
    'height': height,
    'forceOriginalAspectRatio': forceOriginalAspectRatio,
  });
  final result = await worker.onMessage.first;
  return Uint8List.fromList(result.data);
}
