import 'dart:math';
import 'package:app/utils/balloon_styles.dart';
import 'package:flutter/material.dart';
import 'package:app/services/audio_service.dart';
import 'package:app/models/balloon_model.dart';

class BalloonWidget extends StatefulWidget {
  final Balloon balloon;
  final VoidCallback onTap;

  const BalloonWidget({
    super.key,
    required this.balloon,
    required this.onTap, required double topOffset,
  });

  @override
  State<BalloonWidget> createState() => _BalloonWidgetState();
}

class _BalloonWidgetState extends State<BalloonWidget>
    with TickerProviderStateMixin  {
  late AnimationController _floatController;
  late Animation<double> _floatAnimation;
  late AnimationController _tapController;
  late Animation<double> _scaleAnimation;
  
  @override
  void initState() {
    super.initState();
    
    _floatController = AnimationController(
      duration: Duration(milliseconds: 3000 + Random().nextInt(2000)),
      vsync: this,
    )..repeat(reverse: true);
    
    _floatAnimation = Tween<double>(
      begin: -3.0,
      end: 3.0,
    ).animate(CurvedAnimation(
      parent: _floatController,
      curve: Curves.easeInOut,
    ));
    
    _tapController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.2), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.2, end: 1.0), weight: 50),
    ]).animate(_tapController);
  }
  
  @override
  void dispose() {
    _floatController.dispose();
    _tapController.dispose();
    super.dispose();
  }
  
  Future<void> _handleTap() async {
    try {
      await _tapController.forward();
      await _tapController.reverse();
      
      widget.onTap();
      
      if (widget.balloon.isReadyToPop) {
        await AudioService.playPopSound();
      }
    } catch (e) {
      print('Erro inesperado no tap: $e');
      widget.onTap();
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final color = BalloonStyles.getColor(widget.balloon.type);
    final icon = BalloonStyles.getIcon(widget.balloon.type);
    
    return AnimatedBuilder(
      animation: Listenable.merge([_floatAnimation, _scaleAnimation]),
      builder: (context, child) {
        return Positioned(
          left: widget.balloon.left,
          top: widget.balloon.top + _floatAnimation.value,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: GestureDetector(
              onTap: _handleTap,
              child: Container(
                constraints: const BoxConstraints(maxWidth: 180),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                    color: Colors.white,
                    border: Border.all(
                    color: color,
                    width: 2,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.balloon.requiredTaps > 1)
                      Padding(
                        padding: const EdgeInsets.only(top: 0),
                        child: Text(
                          '${widget.balloon.currentTaps}/${widget.balloon.requiredTaps}',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          icon,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            widget.balloon.message,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              height: 1.4,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}