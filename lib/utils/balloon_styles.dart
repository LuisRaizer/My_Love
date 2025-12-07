// [file name]: balloon_styles.dart
import 'package:flutter/material.dart';

class BalloonStyles {
  static Color getColor(String type) {
    switch (type) {
      case 'love':
        return const Color(0xFFFF6F6F);
      case 'secret':
        return const Color(0xFF9C27B0);
      case 'memory':
        return const Color(0xFF2196F3);
      case 'surprise':
        return const Color(0xFFFF9800);
      case 'question':
        return const Color(0xFF00BCD4);
      case 'compliment':
        return const Color(0xFFFFEB3B);
      case 'funny':
        return const Color(0xFF4CAF50);
      default: // normal
        return const Color(0xFF74FF6F);
    }
  }

  static IconData getIcon(String type) {
    switch (type) {
      case 'love':
        return Icons.favorite;
      case 'secret':
        return Icons.lock;
      case 'memory':
        return Icons.history;
      case 'surprise':
        return Icons.card_giftcard;
      case 'question':
        return Icons.question_mark;
      case 'compliment':
        return Icons.star;
      case 'funny':
        return Icons.emoji_emotions;
      default:
        return Icons.chat_bubble;
    }
  }
}