import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'package:story_video_player/src/story_video_info.dart';

class StoryPlayerController {
  final List<StoryVideoInfo> videos;
  int activeVideoIndex = 0;
  late Stream<StoryVideoInfo> activeVideo;
  late AnimationController? progressBarController;
  StoryPlayerState state = StoryPlayerState.initial;
  late VideoPlayerController videoPlayerController;

  final StreamController<StoryVideoInfo> _activeVideoStreamController =
      StreamController<StoryVideoInfo>();

  StoryPlayerController({required this.videos}) {
    activeVideo = _activeVideoStreamController.stream;
    _activeVideoStreamController.add(videos[activeVideoIndex]);
  }

  void setProgressBarController(AnimationController animationController) {
    progressBarController = animationController;

    progressBarController?.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        nextVideo();
      }
    });
  }

  void disposeProgressBarController() {
    progressBarController = null;
  }

  void togglePlayback() {
    if (state == StoryPlayerState.paused) {
      startPlayback();
    } else {
      pausePlayback();
    }
  }

  void setVideoPlayerController(VideoPlayerController controller) {
    videoPlayerController = controller;
  }

  Future<void> startPlayback() async {
    state = StoryPlayerState.playing;
    await videoPlayerController.play();
    progressBarController?.forward();
  }

  Future<void> pausePlayback() async {
    state = StoryPlayerState.paused;
    await videoPlayerController.pause();
    progressBarController?.stop();
  }

  nextVideo() {
    int newVideoIndex = activeVideoIndex + 1;

    if (newVideoIndex < videos.length) {
      _activeVideoStreamController.add(videos[newVideoIndex]);
      activeVideoIndex = newVideoIndex;
    }
  }

  previousVideo() {
    int newVideoIndex = activeVideoIndex - 1;

    if (newVideoIndex >= 0) {
      _activeVideoStreamController.add(videos[newVideoIndex]);
      activeVideoIndex = newVideoIndex;
    }
  }
}

enum StoryPlayerState { initial, playing, paused }
