# Story Video Player

TODO: version badge, license badge, flutter versions, tests/passing, coverage?

A Flutter plugin to display stories like Instagram, Whatsapp, Facebook etc. This plugin supports 3 different options for preloading the videos to play them instantly.

TODO: include GIF

## Features

Add this to your Flutter app to:
- supports videos only
- optimized for HLS streams
- video stories with precached thumbnails.
- video stories without any visible loading and instant playback.
  - 3 different modes for preloading
  - optional manual control over preloading and disposing video controllers
- animated progress bar in custom color

## Installation

To use this package run:
```bash
$ flutter pub add story_video_player
```
This will add the following line to your package's `pubspec.yaml` file:
```yml
dependencies:
  story_video_player: ^0.0.1
```
Now in your Dart code, you can use:
```dart
import 'package: story_video_player/story_video_player.dart';
```

## Usage
Declare your `StoryPlayerController`. This code does not preload any videos by itself.
```dart
storyController = StoryPlayerController(
  videos: [
    StoryVideo(
      thumbnail: NetworkImage('https://url_to_image.jpeg'), // optional
       url: 'https://url_to_video_or_stream.m3u8',
       length: const Duration(milliseconds: 21000)),
  ],
);
```
If you want to precache the thumbnails of all videos within a controller, simply call `preCacheImages()` and give it a valid `BuildContext`:
```dart
@override
void didChangeDependencies() {
  storyController.preCacheImages(context);
  super.didChangeDependencies();
 }
```

## Contributing to this plugin

Contributions to this project are very much welcome.  
Simply go over to [GitHub](https://github.com/TobiasPrt/story_video_player), fork the repository and create a new pull request.

Also don't forget to try out the example project under the ./example folder.

Test your changes by running this command:
```bash
$ flutter test
```
