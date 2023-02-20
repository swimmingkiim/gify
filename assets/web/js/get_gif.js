// ==================== ffmpeg.wasm version ====================

async function getGifFromVideo(
    path, 
    frameRate,
    width,
    height,
    forceOriginalAspectRatio,
    textMessages,
    onEnd,
    ) {
    const { createFFmpeg, fetchFile } = FFmpeg;
    const ffmpeg = createFFmpeg({
        log: true,
        corePath: new URL("ffmpeg-core/ffmpeg-core.js", location).href,
        mainName: "main",
    });
    await ffmpeg.load();
    const currentTime = Date.now();
    const textMessagesCommand = textMessages === null  ? '' : ', ' + JSON.parse(textMessages).map((message) => {
        return `drawtext=fontsize=${message.fontSize}:fontfile=pretendard.woff:fontcolor=${message.fontColor}:text=${message.text}:x=${message.x}:y=${message.y}`;
    }).join(', ')
    await ffmpeg.FS(
        "writeFile",
        "pretendard.woff",
        await fetchFile("https://cdn.jsdelivr.net/gh/Project-Noonnu/noonfonts_2107@1.1/Pretendard-Regular.woff")
    );
    ffmpeg.FS("writeFile", `${currentTime}.avi`, await fetchFile(path));
    await ffmpeg.run(
        "-i",
        `${currentTime}.avi`,
        "-vf",
        `scale=w=${width}:h=${height}${forceOriginalAspectRatio ? ':force_original_aspect_ratio=decrease' : ''}${textMessagesCommand}`,
        "-r",
        `${frameRate}`,
        "-loop",
        "0",
        `${currentTime}.gif`
    );
    const result = ffmpeg.FS("readFile", `${currentTime}.gif`);
    onEnd(result.buffer);
}

async function getGifFromImages(
    imagePaths,
    frameRate,
    width,
    height,
    forceOriginalAspectRatio,
    textMessages,
    onEnd,
) {
    const { createFFmpeg, fetchFile } = FFmpeg;
    const currentTime = Date.now();
    const textMessagesCommand = textMessages === null  ? '' : ',' + JSON.parse(textMessages).map((message) => {
        return `drawtext=fontsize=${message.fontSize}:fontfile=pretendard.woff:fontcolor=${message.fontColor}:text=${message.text}:x=${message.x}:y=${message.y}`;
    }).join(', ')
    const ffmpeg = createFFmpeg({
        log: true,
        corePath: new URL("ffmpeg-core/ffmpeg-core.js", location).href,
        mainName: "main",
    });
    const ffmpegGif = createFFmpeg({
        log: true,
        corePath: new URL("ffmpeg-core/ffmpeg-core.js", location).href,
        mainName: "main",
    });
    await ffmpeg.load();
    await ffmpegGif.load();
    for (let i = 0; i < imagePaths.length; i++) {
        const fileType =
      imagePaths[i][1] !== "unknown"
          ? imagePaths[i][1].replace("image/", "")
          : "jpg";
        await ffmpeg.FS(
            "writeFile",
            `${currentTime}-${i}.${fileType}`,
            await fetchFile(imagePaths[i][0])
        );
        await ffmpeg.run(
            "-i",
            `${currentTime}-${i}.${fileType}`,
            "-vf",
            `scale=w=${width}:h=${height}${forceOriginalAspectRatio ? ':force_original_aspect_ratio=decrease' : ''}`,
            `${currentTime}-${i}.png`
        );
        const temp = ffmpeg.FS("readFile", `${currentTime}-${i}.png`);
        await ffmpeg.exit();
        await ffmpegGif.FS("writeFile", `${currentTime}-${i}.png`, temp);
        console.log("done move");
        await ffmpeg.load();
    }
    await ffmpegGif.FS(
        "writeFile",
        "pretendard.woff",
        await fetchFile("https://cdn.jsdelivr.net/gh/Project-Noonnu/noonfonts_2107@1.1/Pretendard-SemiBold.woff") 
    );
    await ffmpegGif.run(
        "-f",
        "image2",
        "-r",
        `${frameRate}`,
        "-i",
        `${currentTime}-%d.png`,
        "-vf",
        `scale=w=${width < 0 ? height < 0 ? -1 : height : width}:h=${height < 0 ? width < 0 ? -1 : width : height}${forceOriginalAspectRatio ? ':force_original_aspect_ratio=decrease' : ''},pad=\'max(${width < 0 ? height < 0 ? -1 : height : width}, iw)\':\'max(${height < 0 ? width < 0 ? -1 : width : height}, ih)\':-1:-1:color=black@0${textMessagesCommand}`,
        "-loop",
        "0",
        `gif_maker_result_${currentTime}.gif`
    );
    const result = ffmpegGif.FS(
        "readFile",
        `gif_maker_result_${currentTime}.gif`
    );
    onEnd(result.buffer);
}

async function getFramesFromVideo(path, frameRate, onEnd) {
    const { createFFmpeg, fetchFile } = FFmpeg;
    const ffmpeg = createFFmpeg({
        log: true,
        corePath: new URL("ffmpeg-core/ffmpeg-core.js", location).href,
        mainName: "main",
    });
    await ffmpeg.load();
    const currentTime = Date.now();
    ffmpeg.FS("writeFile", `${currentTime}.avi`, await fetchFile(path));

    await ffmpeg.run(
        "-i",
        `${currentTime}.avi`,
        "-r",
        `${frameRate}`,
        "-f",
        "image2",
        `frame-${currentTime}-%d.png`
    );

    let result = [];
    const fileList = ffmpeg
        .FS("readdir", ".")
        .filter(
            (filePath) => filePath.startsWith("frame") && filePath.endsWith("png")
        );
    for (let i = 0; i < fileList.length; i++) {
        const filePath = fileList[i];
        result.push(ffmpeg.FS("readFile", filePath).buffer);
    }
    onEnd(result);
}