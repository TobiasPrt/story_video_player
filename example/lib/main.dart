import 'package:flutter/material.dart';
import 'package:story_video_player/story_video_player.dart';

void main() => runApp(Example());

class Example extends StatefulWidget {
  @override
  _ExampleState createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  late StoryPlayerController storyController;

  @override
  void initState() {
    super.initState();
    // Declare your controller anywhere you like. Depending on what you choose for the preloadingType
    // preloading will be triggered by the constructor.
    storyController = StoryPlayerController(
      preloadingType: PreloadingType.none,
      videos: [
        StoryVideo(
            thumbnail: NetworkImage(
                'https://videotest.tobiaspoertner.com/image-001.jpeg'),
            url:
                'https://ddgn79nxo4efd.cloudfront.net/waypoint-videos/aquarium_dubai.m3u8',
            length: const Duration(milliseconds: 21000)),
        StoryVideo(
            thumbnail: NetworkImage(
                'https://videotest.tobiaspoertner.com/image-001.jpeg'),
            url:
                'https://ddgn79nxo4efd.cloudfront.net/waypoint-videos/aquarium_dubai.m3u8',
            length: const Duration(milliseconds: 21000)),
      ],
    );
  }

  @override
  void didChangeDependencies() {
    // This needs to be called within buildcontext for precaching. Though calling this is totally
    // optionally and makes most sense, when not preloading videos or if you expect users to skip
    // videos a lot and only preload the first video of the story. With this feature the loading
    // time will feel a lot faster.
    storyController.preCacheImages(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Story Video Player Example',
      home: Builder(builder: (context) {
        return Scaffold(
          body: Container(
            child: Center(
              child: MaterialButton(
                onPressed: () {
                  // This is just an example for a check you can use, when you hard dispose the
                  // controller to avoid errors. Hard disposing might be useful if you expect a lot
                  // of different stories to be accessible from the same screen, to avoid
                  // unnecessary RAM usage and ultimately crashes.
                  if (storyController.isDisposed) {
                    storyController.reinitializeVideos();
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => StoryScreen(
                              storyController: storyController,
                            )),
                  );
                },
                child: Text('Open Stories'),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class StoryScreen extends StatelessWidget {
  final StoryPlayerController storyController;

  const StoryScreen({Key? key, required this.storyController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StoryPlayer(
        progressBarColor: Colors.yellow,
        controller: storyController,
      ),
    );
  }
}
