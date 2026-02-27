import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:place_see_app/core/model/photos/photo_full_info.dart';
import 'package:intl/intl.dart';
import 'package:place_see_app/ui/theme/app_colors.dart';
import 'package:place_see_app/ui/theme/app_typography.dart';

class PhotoInfo extends StatelessWidget {
  final PhotoFullInfo photo;

  const PhotoInfo({super.key, required this.photo});

  @override
  Widget build(BuildContext context) {
    final date = photo.createdAt != null ? DateFormat('dd.MM.yyyy').format(photo.createdAt!) : '';

    return AnimatedOpacity(
        opacity: 1,
        duration: const Duration(milliseconds: 250),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              photo.userName,
            style: AppTypography.subTextLight.copyWith(
              color: AppColors.additionalOne
            ),
          ),

          if (date.isNotEmpty)
            Text(
              date,
              style: AppTypography.subTextLight.copyWith(
                  color: AppColors.additionalOne
              ),
            )
        ],
      ),
    );
  }
}
