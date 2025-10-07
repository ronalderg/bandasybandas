import 'package:bandasybandas/src/core/theme/app_colors.dart';
import 'package:bandasybandas/src/core/theme/assets.gen.dart';
import 'package:flutter/material.dart';

class MolDrawerHeader extends StatelessWidget {
  const MolDrawerHeader({
    required this.isColapsed,
    required this.subtitle,
    required this.title,
    super.key,
    this.onPressed,
  });

  final bool isColapsed;
  final VoidCallback? onPressed;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    if (isColapsed) {
      return Assets.images.logo.image();
    }
    return DrawerHeader(
      padding: EdgeInsets.zero,
      margin: EdgeInsets.zero,
      child: Container(
        color: AppColors.blueBandas,
        padding: const EdgeInsets.only(top: 40, left: 16, bottom: 20),
        child: Row(
          children: [
            // Avatar
            const CircleAvatar(
              radius: 30,
              backgroundColor: AppColors.blueSky,
              child: Icon(
                Icons.person,
                size: 35,
                color: AppColors.white,
              ),
            ),
            const SizedBox(width: 12),
            // Nombre y estado
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      color: AppColors.white.withAlpha(179),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
