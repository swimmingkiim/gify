// dart
import 'dart:async';
import 'dart:io';

// flutter
import 'package:flutter/services.dart';

// packages
import 'package:cross_file/cross_file.dart';
import 'package:ffmpeg_kit_flutter_full/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_full/return_code.dart';
import 'package:gify/gify.dart';
import 'package:path_provider/path_provider.dart';

class GifRepositoryNative {
  GifRepositoryNative();

  Future<Uint8List> createGifFromVideo(
    XFile videoFile, {
    int fps = 1,
    int? width,
    int? height,
    bool forceOriginalAspectRatio = true,
    List<GifyTextMessage>? textMessages,
  }) async {
    final tempDir = await getTemporaryDirectory();
    final String currentTime = DateTime.now().millisecond.toString();
    final textMessagesCommand = textMessages == null
        ? ''
        : ',${textMessages.map((message) => 'drawtext=fontsize=${message.fontSize}:fontcolor=0x${message.fontColor.toHex()}:text="${message.text}":x=${message.x}:y=${message.y}').join(',')}';
    final String framesCommand =
        '-i ${videoFile.path} -vf scale=w=${width ?? -1}:h=${height ?? -1}${forceOriginalAspectRatio ? ':force_original_aspect_ratio=decrease' : ''}$textMessagesCommand -r $fps -f image2 ${tempDir.path}/${videoFile.name}-$currentTime-%3d.png';
    final framesSession = await FFmpegKit.execute(framesCommand);

    final framesReturnCode = await framesSession.getReturnCode();

    if (!ReturnCode.isSuccess(framesReturnCode)) {
      return Uint8List.fromList([]);
    }

    final String gifCommand =
        '-f image2 -r $fps -i ${tempDir.path}/${videoFile.name}-$currentTime-%3d.png -loop 0 ${tempDir.path}/${videoFile.name}_$currentTime.gif';
    final gifSession = await FFmpegKit.execute(gifCommand);

    final gifReturnCode = await gifSession.getReturnCode();

    if (!ReturnCode.isSuccess(gifReturnCode)) {
      return Uint8List.fromList([]);
    }

    final result =
        await File('${tempDir.path}/${videoFile.name}_$currentTime.gif')
            .readAsBytes();

    return result;
  }

  Future<Uint8List> createGifFromImages(
    List<XFile> rawImages, {
    int fps = 1,
    int? width,
    int? height,
    bool forceOriginalAspectRatio = true,
    List<GifyTextMessage>? textMessages,
  }) async {
    final tempDir = await getTemporaryDirectory();
    final String currentTime = DateTime.now().millisecond.toString();
    final textMessagesCommand = textMessages == null
        ? ''
        : textMessages
            .map((message) =>
                'drawtext=fontsize=${message.fontSize}:fontcolor=0x${message.fontColor.toHex()}:text="${message.text}":x=${message.x}:y=${message.y}')
            .join(',');
    for (int i = 0; i < rawImages.length; i++) {
      final image = rawImages[i];
      late String path;
      if (image.path.isEmpty) {
        await File('${tempDir.path}/$currentTime-$i.${image.mimeType ?? 'png'}')
            .writeAsBytes(await image.readAsBytes());
        continue;
      } else {
        path = image.path;
      }
      final String convertCommand =
          '-i $path -vf scale=w=${width ?? -1}:h=${height ?? -1}${forceOriginalAspectRatio ? ':force_original_aspect_ratio=decrease' : ''} ${tempDir.path}/$currentTime-$i.png';
      final convertSession = await FFmpegKit.execute(convertCommand);
      final convertReturnCode = await convertSession.getReturnCode();
      if (!ReturnCode.isSuccess(convertReturnCode)) {
        return Uint8List.fromList([]);
      }
    }

    final String gifCommand =
        '-f image2 -r $fps -i ${tempDir.path}/$currentTime-%d.png -loop 0 ${tempDir.path}/gif_maker_result_$currentTime.gif';
    final gifSession = await FFmpegKit.execute(gifCommand);

    final gifReturnCode = await gifSession.getReturnCode();

    if (!ReturnCode.isSuccess(gifReturnCode)) {
      return Uint8List.fromList([]);
    }

    final String gifWithTextCommand =
        '-i ${tempDir.path}/gif_maker_result_$currentTime.gif -vf $textMessagesCommand ${tempDir.path}/gif_maker_result_${currentTime}_text.gif';
    final gifTextSession = await FFmpegKit.execute(gifWithTextCommand);

    final gifTextReturnCode = await gifTextSession.getReturnCode();

    if (!ReturnCode.isSuccess(gifTextReturnCode)) {
      return Uint8List.fromList([]);
    }

    final result =
        await File('${tempDir.path}/gif_maker_result_${currentTime}_text.gif')
            .readAsBytes();

    return result;
  }
}
