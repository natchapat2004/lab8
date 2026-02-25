import 'package:flutter/material.dart';

/// Custom Background Widget สำหรับ Dismissible
class SwipeBackground extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String label;
  final Alignment alignment;

  const SwipeBackground({
    super.key,
    required this.color,
    required this.icon,
    required this.label,
    this.alignment = Alignment.centerLeft,
  });

  @override
  Widget build(BuildContext context) {
    final isLeft = alignment == Alignment.centerLeft;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.8), color],
          begin: isLeft ? Alignment.centerLeft : Alignment.centerRight,
          end: isLeft ? Alignment.centerRight : Alignment.centerLeft,
        ),
      ),
      alignment: alignment,
      padding: EdgeInsets.only(left: isLeft ? 24 : 0, right: isLeft ? 0 : 24),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isLeft) ...[
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ] else ...[
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 12),
            Icon(icon, color: Colors.white, size: 28),
          ],
        ],
      ),
    );
  }
}

// การใช้งาน:
// background: SwipeBackground(
//   color: Colors.green,
//   icon: Icons.archive,
//   label: 'Archive',
//   alignment: Alignment.centerLeft,
// ),
// secondaryBackground: SwipeBackground(
//   color: Colors.red,
//   icon: Icons.delete,
//   label: 'Delete',
//   alignment: Alignment.centerRight,
// ),
