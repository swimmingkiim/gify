# gify

Make GIF with video and images

## Example

- [Live Demo](https://swimmingkiim.github.io/gif_maker/)
  ![createGifFromVideo example](https://github.com/swimmingkiim/blog-comments/blob/main/assets/images/gify_create_gif_from_video_example.gif?raw=true)

## Features

- `getFramesBytes` Get Frame images from video as List<Uint8List>
- `createGifFromVideo` Create GIF from video as Uint8List
- `createGifFromImages` Create GIF from images as Uint8List

## Getting started

### Prerequisites

- `ios`
  - Minimum target version : 12.1
- `android`
  - Minimum SDK version : 24
- `Run example`
  - Example uses `image_picker`, so you need to modify your Info.plist ([documentation](https://pub.dev/packages/image_picker#ios))

### Installation

```bash
flutter pub add gify
```

## Usage

```dart
  Future<List<Uint8List>?> testFrames() async {
    final XFile? videoFile =
        await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (videoFile != null) {
      final result = await _gifyPlugin.getFramesBytes(videoFile, 1);
      // Uncomment below code to see result
      // print(result);
      return result;
    }
    return null;
  }

  Future<Uint8List?> testVideoToGif() async {
    final XFile? videoFile =
        await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (videoFile != null) {
      final result = await _gifyPlugin.createGifFromVideo(videoFile, 1);
      // Uncomment below code to see result
      // print(result);
      return result;
    }
    return null;
  }

  Future<Uint8List?> testImagesToGif() async {
    final List<XFile> imageFiles = await ImagePicker().pickMultiImage();
    final result = await _gifyPlugin.createGifFromImages(imageFiles, 1);
    // Uncomment below code to see result
    // print(result);
    return result;
  }
```

## Contributing

- Pull Requests are always welcome!
- Please send a Pull Request to https://github.com/swimmingkiim/gify

## License

- [MIT](https://github.com/swimmingkiim/gify/blob/main/LICENSE)
