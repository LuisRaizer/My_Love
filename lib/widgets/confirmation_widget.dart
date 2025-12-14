import 'package:flutter/material.dart';

class ConfirmationWidget extends StatelessWidget {
  final String title;
  final String content;
  final String cancelText;
  final String confirmText;
  final Color confirmColor;
  final VoidCallback onConfirm;
  final IconData? icon;
  final bool showLoading;

  const ConfirmationWidget({
    super.key,
    required this.title,
    required this.content,
    this.cancelText = 'Cancelar',
    this.confirmText = 'Confirmar',
    this.confirmColor = const Color(0xFFe83f3f),
    required this.onConfirm,
    this.icon,
    this.showLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: confirmColor,
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(content),
          if (showLoading) ...[
            const SizedBox(height: 16),
            const Center(
              child: CircularProgressIndicator(),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            cancelText,
            style: TextStyle(
              color: Colors.grey[700],
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            onConfirm();
            if (!showLoading) {
              Navigator.pop(context);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: confirmColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(confirmText),
        ),
      ],
    );
  }
}