import 'package:flutter/material.dart';
import 'package:story_video_player/src/story_progressbar.dart';

import '../story_video_player.dart';

/// Widget representing a player for the videos given from a [StoryPlayerController]
///
/// A tap on the right half of the screen will skip to the next video if available.
/// A tap on the left half of the screen will skip to the previous video if available.
class StoryPlayer extends StatefulWidget {
  /// Controls a [StoryPlayer] instance and manages its current state.
  final StoryPlayerController controller;

  /// Function called on when pointer leaves the screen in a vertical drag motion
  ///
  /// See also [GestureDetector.onVerticalDragEnd]
  final Function(DragEndDetails)? onVerticalDragEnd;

  /// Function called on when pointer leaves the screen in a horizontal drag motion
  ///
  /// See also [GestureDetector.onHorizontalDragEnd]
  final Function(DragEndDetails)? onHorizontalDragEnd;

  /// Defines the filling color of the progress bar
  final Color? progressBarColor;

  /// Defines the margin the progressbar keeps from the top of this widget
  final double progressbarTopMargin;

  const StoryPlayer({
    Key? key,
    required this.controller,
    this.onVerticalDragEnd,
    this.onHorizontalDragEnd,
    this.progressBarColor,
    this.progressbarTopMargin = 96,
  }) : super(key: key);

  @override
  _StoryPlayerState createState() => _StoryPlayerState();
}

class _StoryPlayerState extends State<StoryPlayer> {
  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;

    return Container(
      child: Stack(
        children: [
          if (widget.controller.videos[widget.controller.activeVideoIndex]
                  .thumbnail !=
              null)
            SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: Container(
                    child: Image(
                  image: widget.controller
                      .videos[widget.controller.activeVideoIndex].thumbnail!,
                  fit: BoxFit.cover,
                )),
              ),
            ),
          StreamBuilder<int>(
              stream: widget.controller.activeVideoIndexStream,
              initialData: 0,
              builder: (context, snapshot) {
                // Preload next video
                widget.controller.preloadNextVideo();

                // build Widgets
                return Stack(
                  children: [
                    FutureBuilder<void>(
                      future:
                          widget.controller.videos[snapshot.data!].loadVideo(),
                      builder: (BuildContext context,
                          AsyncSnapshot<dynamic> asyncSnapshot) {
                        // Show video player if loading is done
                        if (asyncSnapshot.connectionState ==
                            ConnectionState.done) {
                          return StoryVideoWidget(
                            storyController: widget.controller,
                            storyVideo:
                                widget.controller.videos[snapshot.data!],
                          );
                        }

                        // show loadingindicator and thumbnail instead
                        return Stack(
                          children: [
                            Container(
                              child: Center(
                                child: CircularProgressIndicator.adaptive(),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    StoryProgressbar(
                      storyPlayerController: widget.controller,
                      color: widget.progressBarColor ?? Colors.green,
                      progressbarTopMargin: widget.progressbarTopMargin,
                    ),
                  ],
                );
              }),
          GestureDetector(
            onTapUp: (TapUpDetails details) {
              if (details.globalPosition.dx > deviceWidth / 2) {
                widget.controller.next();
              }
              if (details.globalPosition.dx < deviceWidth / 2) {
                widget.controller.prev();
              }
            },
            onVerticalDragEnd: widget.onVerticalDragEnd,
            onHorizontalDragEnd: widget.onHorizontalDragEnd,
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller.dispose();
  }
}
