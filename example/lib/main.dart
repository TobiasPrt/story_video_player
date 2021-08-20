import 'package:flutter/material.dart';
import 'package:story_video_player/story_video_player.dart';

void main() => runApp(Example());

class Example extends StatefulWidget {
  @override
  _ExampleState createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Story Video Player Example',
      home: Scaffold(
        body: StoryPlayer(
          progressBarColor: Colors.yellow,
          controller: StoryPlayerController(
            videos: [
              StoryVideoInfo(
                  url:
                      'https://videotest.tobiaspoertner.com/videos/tempelhofer_feld.m3u8',
                  length: const Duration(milliseconds: 29433)),
              StoryVideoInfo(
                  url:
                      'https://videotest.tobiaspoertner.com/videos/tempelhofer_feld.m3u8',
                  length: const Duration(milliseconds: 29433)),
            ],
          ),
        ),
      ),
    );
  }
}
