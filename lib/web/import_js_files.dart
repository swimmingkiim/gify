import 'dart:html' as html;

void importJSFiles() {
  injectJSScript(
      'assets/packages/gify/assets/web/js/ffmpeg-core/ffmpeg-core.js');
  injectJSScript('assets/packages/gify/assets/web/js/ffmpeg.min.js');
  injectJSScript('assets/packages/gify/assets/web/js/get_gif.js');
  // injectJSScript(
  //     'assets/packages/gify/assets/web/js/gif_repository_web_images_worker.dart.js');
  // injectJSScript(
  //     'assets/packages/gify/assets/web/js/gif_repository_web_video_worker.dart.js');
  // injectJSScript(
  //     'assets/packages/gify/assets/web/js/video_repository_web_frame_worker.dart.js');
}

void injectJSScript(String path) {
  html.document.head!.append(html.ScriptElement()
    ..src = path
    ..defer = true);
}
