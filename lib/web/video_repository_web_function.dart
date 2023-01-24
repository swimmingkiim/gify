@JS()
library video_repository_web_function; //Not avoid the library annotation

// dart
import 'dart:async';
import 'dart:typed_data';

// package
import 'package:universal_html/html.dart';
import 'package:js/js.dart' show JS;

@JS('getFramesFromVideo')
external getFramesFromVideo(String path, int fps, Function onEnd);

Future<List<Uint8List>> getFramesBytesFromVideo(
  String path,
  int fps,
) async {
  String basePath = 'assets/packages/gify/assets/web/js';
  // web worker
  final worker = Worker('$basePath/video_repository_web_frame_worker.dart.js');

  worker.postMessage({
    'path': path,
    'fps': fps,
  });
  final result = await worker.onMessage.first;
  return List<Uint8List>.from(result.data);
}
