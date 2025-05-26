import 'package:flutter/material.dart';

class CircularCard extends StatelessWidget {
  final Widget child;
  final double diameter;
  final Color color;

  CircularCard({
    required this.child,
    required this.diameter,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: diameter,
      height: diameter,
      child: Card(
        shape: CircleBorder(), // Essential for proper clipping
        elevation: 4.0,
        color: color,
        child: ClipOval(
          child: Center(
            child: child,
          ),
        ),
      ),
    );
  }
}
