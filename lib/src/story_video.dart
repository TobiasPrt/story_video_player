import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// Class representing all the needed information for a video object in a [StoryPlayerController]
class StoryVideo {
  /// String to the url of the video file
  final String url;

  /// Length as [Duration] of the video, for best results use ms
  final Duration length;

  /// Thumbnail image (optional, but highly recommended)
  final NetworkImage? thumbnail;

  /// Whether or not the [VideoPlayerController] of this video is already initialized
  bool isLoaded = false;

  /// The controller of this video
  late VideoPlayerController controller;

  StoryVideo(
      {required this.url, required this.length, required this.thumbnail}) {
    controller = VideoPlayerController.network(url);
  }

  /// Initializes the [VideoPlayerController] and therefore loads the video
  Future<void> loadVideo() async {
    await controller.initialize();
    isLoaded = true;
  }

  /// Reinitializes the controller of the video
  void reinitialize() {
    controller = VideoPlayerController.network(url);
    isLoaded = false;
  }

  /// Define custom comparison operator to differentiate by url
  @override
  bool operator ==(Object other) {
    return other is StoryVideo &&
        other.runtimeType == runtimeType &&
        url == other.url;
  }

  /// Needed for the custom comparison operator to compare strings
  @override
  int get hashCode => url.hashCode;
}
