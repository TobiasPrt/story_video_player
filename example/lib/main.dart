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
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({
    Key? key,
  }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late StoryPlayerController storyController;

  @override
  void initState() {
    super.initState();
    storyController = StoryPlayerController(
      preloadingType: PreloadingType.onlyFirstVideo,
      videos: [
        StoryVideo(
            thumbnail: NetworkImage(
                'https://videotest.tobiaspoertner.com/image-001.jpeg'),
            url:
                'https://ddgn79nxo4efd.cloudfront.net/waypoint-videos/aquarium_dubai.m3u8',
            length: const Duration(milliseconds: 29433)),
        StoryVideo(
            thumbnail: NetworkImage(
                'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/1200px-Image_created_with_a_mobile_phone.png'),
            url:
                'https://videotest.tobiaspoertner.com/videos/ts/tempelhofer_feld_ts.m3u8',
            length: const Duration(milliseconds: 29433)),
      ],
    );
  }

  @override
  void didChangeDependencies() {
    storyController.preCacheImages(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: MaterialButton(
            onPressed: () {
              if (storyController.isDisposed) {
                storyController.reinitializeVideos();
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => VideoScreen(
                          storyController: storyController,
                        )),
              );
            },
            child: Text('zum videoscreen'),
          ),
        ),
      ),
    );
  }
}

class VideoScreen extends StatefulWidget {
  final StoryPlayerController storyController;

  const VideoScreen({Key? key, required this.storyController})
      : super(key: key);

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StoryPlayer(
        progressBarColor: Colors.yellow,
        controller: widget.storyController,
      ),
    );
  }
}
