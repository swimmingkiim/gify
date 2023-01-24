// ==================== ffmpeg.wasm version ====================

async function getGifFromVideo(path, frameRate, onEnd) {
    const { createFFmpeg, fetchFile } = FFmpeg;
    console.log(location);
    console.log(new URL("ffmpeg-core/ffmpeg-core.js", location).href);
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
    onEnd
) {
    const { createFFmpeg, fetchFile } = FFmpeg;
    console.log(location);
    console.log(new URL("ffmpeg-core/ffmpeg-core.js", location).href);
    const currentTime = Date.now();
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
            `${currentTime}-${i}.png`
        );
        const temp = ffmpeg.FS("readFile", `${currentTime}-${i}.png`);
        await ffmpeg.exit();
        await ffmpegGif.FS("writeFile", `${currentTime}-${i}.png`, temp);
        console.log("done move");
        await ffmpeg.load();
    }
    await ffmpegGif.run(
        "-f",
        "image2",
        "-r",
        `${frameRate}`,
        "-i",
        `${currentTime}-%d.png`,
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
    console.log(location);
    console.log(new URL("ffmpeg-core/ffmpeg-core.js", location).href);
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


async function saveGif(gifBytes, onEnd) {
    const aTag = document.createElement('a');
    aTag.style.display = 'none';
    document.body.appendChild(aTag);
    const blob = new Blob( [ gifBytes ], { type: 'image/gif' } );	
    aTag.href = URL.createObjectURL( blob );
    aTag.download = 'gif_result.gif';
    aTag.click();
    document.body.removeChild(aTag);
    onEnd(null);
}

// ==================== gifshot version ====================
// function getGifFromVideo(path, onEnd) {
//     const video = document.createElement("video");
//     video.onloadedmetadata = (e) => {
//         const frameCount = Math.floor(video.duration) * 10;
//         const gifWidth = Math.min(512, video.videoWidth);
//         const gifHeight = (video.videoHeight * gifWidth) / video.videoWidth;
//         gifshot.createGIF(
//             {
//                 gifWidth: gifWidth,
//                 gifHeight: gifHeight,
//                 numFrames: frameCount,
//                 frameDuration: 1,
//                 numWorkers: 5,
//                 progressCallback: (captureProgress) => console.log(captureProgress),
//                 video: [path],
//             },
//             async function (obj) {
//                 if (!obj.error) {
//                     const base64 = obj.image;
//                     const result = await fetch(base64);
//                     const data = await result.arrayBuffer();
//                     console.log("done!");
//                     onEnd(data);
//                 }
//             }
//         );
//     };
//     video.src = path;
// }

// function getGifFromImages(imagePaths, gifWidth, gifHeight, onEnd) {
//     gifshot.createGIF(
//         {
//             gifWidth: gifWidth,
//             gifHeight: gifHeight,
//             numFrames: imagePaths.length,
//             frameDuration: 5,
//             numWorkers: 5,
//             images: imagePaths,
//         },
//         async function (obj) {
//             if (!obj.error) {
//                 const base64 = obj.image;
//                 const result = await fetch(base64);
//                 const data = await result.arrayBuffer();
//                 onEnd(data);
//             }
//         }
//     );
// }
