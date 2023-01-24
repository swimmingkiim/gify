// dart compile js -o assets/web/js/video_repository_web_frame_worker.dart.js lib/web/video_repository_web_frame_worker.dart

@JS()
library video_repository_web_worker;

// dart
import 'dart:async';
import 'dart:typed_data';

// packages
import 'video_repository_web_function.dart';
import 'package:js/js.dart';
import 'package:universal_html/html.dart';
import 'package:universal_html/js.dart' as universal_js show allowInterop;

@JS('self')
external DedicatedWorkerGlobalScope get self;

void main() {
  self.onMessage.listen((e) async {
    String basePath = '.';
    final String path = e.data['path'];
    final int fps = e.data['fps'];

    self.importScripts('$basePath/ffmpeg-core/ffmpeg-core.js');
    self.importScripts('$basePath/ffmpeg.min.js');
    self.importScripts('$basePath/get_gif.js');

    final Completer completer = Completer();
    late List<Uint8List> data;

    getFramesFromVideo(path, fps, universal_js.allowInterop((results) {
      data = results.map<Uint8List>((bytes) {
        final byteBuffer = bytes as ByteBuffer;
        return byteBuffer.asUint8List();
      }).toList();
      completer.complete();
    }));
    await completer.future;
    self.postMessage(data, null);
  });
}
