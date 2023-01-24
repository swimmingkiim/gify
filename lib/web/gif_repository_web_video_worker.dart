// dart compile js -o assets/web/js/gif_repository_web_video_worker.dart.js lib/web/gif_repository_web_video_worker.dart

@JS()
library gif_repository_web_worker;

// dart
import 'dart:async';
import 'dart:typed_data';

// packages
import 'gif_repository_web_function.dart';
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
    final Completer completer = Completer();
    late List<int> data;

    self.importScripts('$basePath/ffmpeg-core/ffmpeg-core.js');
    self.importScripts('$basePath/ffmpeg.min.js');
    self.importScripts('$basePath/get_gif.js');

    getGifFromVideo(path, fps, universal_js.allowInterop((results) {
      final byteBuffer = results as ByteBuffer;
      data = byteBuffer.asUint8List();
      completer.complete();
    }));
    await completer.future;
    self.postMessage(data, null);
  });
}
