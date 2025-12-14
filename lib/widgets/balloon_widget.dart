import 'dart:math';
import 'package:app/utils/balloon_styles.dart';
import 'package:flutter/material.dart';
import 'package:app/services/audio_service.dart';
import 'package:app/models/balloon_model.dart';

class BalloonWidget extends StatefulWidget {
  final Balloon balloon;
  final VoidCallback onTap;
  final double topOffset;

  const BalloonWidget({
    super.key,
    required this.balloon,
    required this.onTap,
    required this.topOffset,
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
  bool _isProcessingTap = false;

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
    if (_isProcessingTap) return;
    _isProcessingTap = true;
    
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
    } finally {
      _isProcessingTap = false;
    }
  }

  double _calculateWidth(String message) {
    final int length = message.length;
    
    if (length < 20) {
      return 150.0;
    } else if (length < 30) {
      return 200.0;
    } else if (length < 40) {
      return 240.0;
    } else {
      return 260.0;
    }
  }
  
  EdgeInsets _calculatePadding(String message) {
    final int length = message.length;
    
    if (length < 20) {
      return const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
    } else if (length < 30) {
      return const EdgeInsets.symmetric(horizontal: 18, vertical: 12);
    } else if (length < 40) {
      return const EdgeInsets.symmetric(horizontal: 20, vertical: 12);
    } else {
      return const EdgeInsets.symmetric(horizontal: 22, vertical: 12);
    }
  }
  
  double _calculateFontSize(String message) {
    final int length = message.length;
    
    if (length < 20) {
      return 14.0;
    } else if (length < 30) {
      return 13.0;
    } else if (length < 40) {
      return 12.0;
    } else {
      return 11.0;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final color = BalloonStyles.getColor(widget.balloon.type);
    final icon = BalloonStyles.getIcon(widget.balloon.type);
    
    final message = widget.balloon.message;
    final width = _calculateWidth(message);
    final padding = _calculatePadding(message);
    final fontSize = _calculateFontSize(message);
    
    return AnimatedBuilder(
      animation: Listenable.merge([_floatAnimation, _scaleAnimation]),
      builder: (context, child) {
        return Positioned(
          left: widget.balloon.left,
          top: widget.balloon.top + _floatAnimation.value + widget.topOffset,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: GestureDetector(
              onTap: _handleTap,
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: width,
                ),
                padding: padding,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  color: Colors.white,
                  border: Border.all(
                    color: color,
                    width: 3,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.balloon.requiredTaps > 1)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          '${widget.balloon.currentTaps}/${widget.balloon.requiredTaps}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                      ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          icon,
                          size: fontSize + 4,
                          color: color,
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            message,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: fontSize,
                              fontWeight: FontWeight.w600,
                              height: 1.5,
                              color: Colors.grey[800],
                            ),
                            maxLines: 3,
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