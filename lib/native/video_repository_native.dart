// dart
import 'dart:async';
import 'dart:io';

// flutter
import 'package:flutter/services.dart';

// packages
import 'package:cross_file/cross_file.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:path_provider/path_provider.dart';

class VideoRepositoryNative {
  VideoRepositoryNative();

  Future<List<Uint8List>> getFramesFromVideo(XFile videoFile, int fps) async {
    final tempDir = await getTemporaryDirectory();
    final String currentTime = DateTime.now().millisecond.toString();
    final List<Uint8List> result = [];
    final String framesCommand =
        '-i ${videoFile.path} -r $fps -f image2 ${tempDir.path}/${videoFile.name}-$currentTime-%d.png';
    final framesSession = await FFmpegKit.execute(framesCommand);

    final framesReturnCode = await framesSession.getReturnCode();

    if (!ReturnCode.isSuccess(framesReturnCode)) {
      return result;
    }

    final Directory directory = Directory(tempDir.path);
    final allFileList = directory.listSync(recursive: true);
    final List<FileSystemEntity> fileList = allFileList
        .where((file) =>
            file.path.startsWith(
                '${tempDir.path}/${videoFile.name}-$currentTime-') &&
            file.path.endsWith('png'))
        .toList()
      ..sort((a, b) {
        final int aNumber = int.parse(a.path
            .replaceFirst('${tempDir.path}/${videoFile.name}-$currentTime-', '')
            .replaceFirst('.png', ''));
        final int bNumber = int.parse(b.path
            .replaceFirst('${tempDir.path}/${videoFile.name}-$currentTime-', '')
            .replaceFirst('.png', ''));
        return aNumber - bNumber;
      });

    for (var i = 0; i < fileList.length; i++) {
      result.add(await File(fileList[i].path).readAsBytes());
    }

    return result;
  }
}
