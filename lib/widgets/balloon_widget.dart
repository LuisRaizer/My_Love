import 'dart:math';

import 'package:flutter/material.dart';
import 'package:app/services/audio_service.dart';

class BalloonWidget extends StatefulWidget {
  final String message;
  final double left;
  final double top;
  final double opacity;
  final VoidCallback? onTap;

  const BalloonWidget({
    super.key,
    required this.message,
    required this.left,
    required this.top,
    required this.opacity,
    this.onTap,
  });

  @override
  State<BalloonWidget> createState() => _BalloonWidgetState();
}

class _BalloonWidgetState extends State<BalloonWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(milliseconds: 3000 + Random().nextInt(2000)),
      vsync: this,
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(
      begin: -3.0,
      end: 3.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() async {
    await AudioService.playPopSound();
    
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _floatAnimation,
      builder: (context, child) {
        return Positioned(
          left: widget.left,
          top: widget.top + _floatAnimation.value,
          child: Opacity(
            opacity: widget.opacity,
            child: GestureDetector(
              onTap: _handleTap,
              child: Container(
                constraints: BoxConstraints(maxWidth: 180),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  border: Border.all(
                    color: Color(0xFF74FF6F),
                    width: 2,
                  ),
                ),
                child: Text(
                  widget.message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF74FF6F),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                  ),
                  softWrap: true,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}