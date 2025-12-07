import 'package:flutter/material.dart';
import 'package:app/controllers/balloon_controller.dart';
import 'balloon_widget.dart';

class BalloonArea extends StatelessWidget {
  final BalloonController controller;
  final double height;
  final double topOffset;

  const BalloonArea({
    super.key,
    required this.controller,
    this.height = 200,
    this.topOffset = 0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return Stack(
            children: controller.activeBalloons.map((balloon) {
              return BalloonWidget(
                key: ValueKey(balloon.id),
                balloon: balloon,
                topOffset: topOffset,
                onTap: () {
                  controller.incrementBalloonTaps(balloon.id);
                  if (balloon.isReadyToPop) {
                    controller.removeBalloon(balloon.id, popped: true);
                  }
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}