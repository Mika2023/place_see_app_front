import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:place_see_app/ui/theme/app_colors.dart';
import 'package:place_see_app/ui/theme/app_typography.dart';

class PhotoInfo extends StatelessWidget {
  final DateTime? createdAt;
  final String? userName;
  final String? placeName;

  const PhotoInfo({super.key, this.createdAt, required this.userName, this.placeName});

  @override
  Widget build(BuildContext context) {
    final date = createdAt != null ? DateFormat('dd.MM.yyyy').format(createdAt!) : '';

    return AnimatedOpacity(
        opacity: 1,
        duration: const Duration(milliseconds: 250),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              userName ?? 'Путешественник',
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
            ),

          if (placeName != null)
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
