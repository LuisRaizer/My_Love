import 'package:flutter/material.dart';

class BalloonStyles {
  static Color getColor(String type) {
    switch (type) {
      case 'love':
        return const Color(0xFFFF6F6F);
      case 'secret':
        return const Color(0xFF9C27B0);
      default:
        return const Color(0xFF74FF6F);
    }
  }

  static IconData getIcon(String type) {
    switch (type) {
      case 'love':
        return Icons.favorite;
      case 'secret':
        return Icons.lock;
      case 'surprise':
        return Icons.card_giftcard;
      case 'funny':
        return Icons.emoji_emotions;
      default:
        return Icons.chat_bubble;
    }
  }
}