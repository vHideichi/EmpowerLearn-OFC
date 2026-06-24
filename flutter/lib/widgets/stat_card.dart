import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const StatCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 96,

        margin: const EdgeInsets.symmetric(horizontal: 4),

        padding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 4,
        ),

        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(18),
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,

          children: [

            CircleAvatar(
              radius: 15,
              backgroundColor: color.withOpacity(0.20),

              child: Icon(
                icon,
                color: color,
                size: 16,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              value,
              overflow: TextOverflow.ellipsis,

              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 2),

            Flexible(
              child: Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,

                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 9.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}