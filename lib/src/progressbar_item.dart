import 'package:flutter/material.dart';

/// A static item of a [StoryProgressbar]
class ProgressbarItem extends StatelessWidget {
  /// Width of the item
  final double width;

  /// Color of the item
  final Color color;

  const ProgressbarItem({Key? key, required this.width, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 2,
      width: width,
      color: color,
      margin: EdgeInsets.symmetric(horizontal: 2),
    );
  }
}
