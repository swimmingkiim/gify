// dart compile js -o assets/web/js/gif_repository_web_images_worker.dart.js lib/web/gif_repository_web_images_worker.dart

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
    final List<List<String>> imagePaths =
        List<dynamic>.from(e.data['imagePaths'])
            .map<List<String>>((path) => List<String>.from(path))
            .toList();
    final int fps = e.data['fps'];
    final int width = e.data['width'] ?? -1;
    final int height = e.data['height'] ?? -1;
    final bool forceOriginalAspectRatio = e.data['forceOriginalAspectRatio'];
    final String? textMessages = e.data['textMessages'];

    self.importScripts('$basePath/ffmpeg-core/ffmpeg-core.js');
    self.importScripts('$basePath/ffmpeg.min.js');
    self.importScripts('$basePath/get_gif.js');

    final Completer completer = Completer();
    late Uint8List data;
    getGifFromImages(
      imagePaths,
      fps,
      width,
      height,
      forceOriginalAspectRatio,
      textMessages,
      universal_js.allowInterop((results) {
        final byteBuffer = results as ByteBuffer;
        data = byteBuffer.asUint8List();
        completer.complete();
      }),
    );
    await completer.future;
    self.postMessage(data, null);
  });
}
