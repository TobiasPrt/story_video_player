import 'dart:async';

import 'package:flutter/material.dart';

import '../story_video_player.dart';

/// Controller class for [StoryPlayer] widget
class StoryPlayerController {
  /// List of video objects to be played in this story
  final List<StoryVideo> videos;

  /// Defines how preloading should be handled.
  ///
  /// Using [none] does not preload at all. Using [onlyFirstVideo] will only preload the first video
  /// of the given list as well as the next video in the background as soon as the first video
  /// starts playing. Using [allVideos] will preload all videos. In any of the cases the full video
  /// will be buffered.
  PreloadingType preloadingType;

  /// The index of the currently active video
  int activeVideoIndex = 0;

  /// The stream for the current videos index
  late Stream<int> activeVideoIndexStream;

  /// The stream controller for the current videos index
  final StreamController<int> _activeIndexStreamController =
      StreamController<int>();

  /// Whether or not this controller was disposed
  bool isDisposed = false;

  StoryPlayerController(
      {required this.videos, this.preloadingType = PreloadingType.none}) {
    // Initialize stream and add first item
    activeVideoIndexStream =
        _activeIndexStreamController.stream.asBroadcastStream();
    _activeIndexStreamController.add(activeVideoIndex);

    _preloadVideos();
  }

  /// This function will preload videos according to the preloadType
  void _preloadVideos() {
    // Initialize only the first video controller
    if (preloadingType == PreloadingType.onlyFirstVideo) {
      videos.first.loadVideo();
    }

    // Initialize all video controllers
    if (preloadingType == PreloadingType.allVideos) {
      for (StoryVideo video in videos) {
        video.loadVideo();
      }
    }
  }

  /// Manually preload single videos
  Future<void> preloadVideo(int index) async {
    if (!videos[index].isLoaded) {
      await videos[index].loadVideo();
    }
  }

  /// Preload next video
  ///
  /// This function does not work, when [preloadingType == PreloadingType.none], use
  /// [preloadVideo()] instead.
  Future<void> preloadNextVideo() async {
    if (preloadingType != PreloadingType.none) {
      await preloadVideo(activeVideoIndex + 1);
    }
  }

  /// Call this function to precache images so they show up immediately
  void preCacheImages(BuildContext context) {
    for (StoryVideo video in videos) {
      if (video.thumbnail != null) {
        precacheImage(video.thumbnail!, context);
      }
    }
  }

  /// Starts playing the current video
  Future<void> play() async {
    await videos[activeVideoIndex].controller.play();
  }

  /// Pauses the current video
  Future<void> pause() async {
    await videos[activeVideoIndex].controller.pause();
  }

  /// Skips to the next video
  Future<void> next() async {
    // Pause current video
    await pause();
    // Reset current video position
    videos[activeVideoIndex].controller.seekTo(Duration.zero);
    // Increase index
    activeVideoIndex = activeVideoIndex == videos.length - 1
        ? videos.length - 1
        : activeVideoIndex + 1;
    // Add event to stream
    _activeIndexStreamController.add(activeVideoIndex);
  }

  /// Skips to the previous video
  Future<void> prev() async {
    // Pause current video
    await pause();
    // Reset current video position
    videos[activeVideoIndex].controller.seekTo(Duration.zero);
    // Reduce index
    activeVideoIndex = activeVideoIndex == 0 ? 0 : activeVideoIndex - 1;
    // Add event to stream
    _activeIndexStreamController.add(activeVideoIndex);
  }

  /// Reinitializes videos after a hard dispose was made.
  ///
  /// Use this only after dispose with the hard dispose flag was called. This function will use the
  /// same preloaded setting as declared when creating this controller.
  void reinitializeVideos() {
    for (StoryVideo video in videos) {
      video.reinitialize();
    }
    _preloadVideos();
  }

  /// This will pause all videos and reset their position.
  ///
  /// If you use [hardDispose = true], all video controllers will be disposed and all preloaded
  /// videos will be removed from RAM. You MUST reinitialize them again with [reinitializeVideos()]
  /// before using the StoryPlayer after this was called.
  Future<void> dispose({bool hardDispose = false}) async {
    for (StoryVideo video in videos) {
      if (hardDispose) {
        video.isLoaded = false;
        video.controller.dispose();
        isDisposed = true;
      } else {
        video.controller.pause();
        video.controller.seekTo(Duration.zero);
      }
    }
  }
}

enum PreloadingType { none, onlyFirstVideo, allVideos }

// class StoryPlayerController {
//   /// Animation controller for the currently active video
//   ///
//   /// There is only one animation controller active at any given time:
//   /// The animation controller for the current videos part in the progressbar, all other parts
//   /// of the progressbar are static. When skipping around storyitems, the respective parts in the
//   /// the progressbar will rebuild as needed.
//   late AnimationController? progressBarController;

//   void setProgressBarController(AnimationController animationController) {
//     progressBarController = animationController;

//     progressBarController?.addStatusListener((status) {
//       if (status == AnimationStatus.completed) {
//         nextVideo();
//       }
//     });
//   }

//   void disposeProgressBarController() {
//     progressBarController = null;
//   }
