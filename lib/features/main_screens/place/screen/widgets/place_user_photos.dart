import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:place_see_app/core/model/photos/photo_full_info.dart';
import 'package:place_see_app/ui/theme/app_colors.dart';
import 'package:place_see_app/ui/theme/app_typography.dart';
import 'package:place_see_app/ui/widget/add_photo_button.dart';
import 'package:place_see_app/ui/widget/photo_gallery_screen.dart';
import 'package:place_see_app/ui/widget/stateful/pressable_widget.dart';

import '../../../../../gen/assets.gen.dart';

class PlaceUserPhotos extends StatefulWidget {
  final List<PhotoFullInfo> photos;
  final bool isAddButtonNeeded;
  final VoidCallback? onAddPressed;
  final Function(int photoId)? onDelete;

  const PlaceUserPhotos({super.key, required this.photos, required this.isAddButtonNeeded, this.onAddPressed, this.onDelete});

  @override
  State<PlaceUserPhotos> createState() => _PlaceUserPhotosState();
}

class _PlaceUserPhotosState extends State<PlaceUserPhotos> {
  int? _deletePhotoModeIndex;

  Widget _buildPhoto(String path) {
    if (path.startsWith("http")) {
      return CachedNetworkImage(
        width: 190,
        height: 190,
        imageUrl: path,
        fit: BoxFit.cover,
      );
    }

    return Image.file(
      File(path),
      fit: BoxFit.cover,
      width: 190,
      height: 190,
    );
  }

  void _showDeleteConfirmation(int photoId) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          actionsAlignment: MainAxisAlignment.spaceBetween,
          title: Text(
            "Подтверждение",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold
            ),
            textAlign: TextAlign.center,
          ),
          content: Text(
            "Вы действительно хотите удалить фото? Это действие нельзя отменить.",
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(
                    "Отмена",
                  style: AppTypography.buttonTextDark
                )
            ),
            FilledButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  widget.onDelete?.call(photoId);
                  setState(() => _deletePhotoModeIndex = null);
                },
                style: FilledButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    backgroundColor: AppColors.lightRed,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12)
                ),
                child: Text(
                    "Удалить",
                    style: AppTypography.buttonTextLight
                )
            ),
          ],
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 190,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        separatorBuilder: (_, _) => const SizedBox(width: 8,),
        itemCount: widget.isAddButtonNeeded ? widget.photos.length + 1 : widget.photos.length,
        itemBuilder: (_, i) {
          if (widget.isAddButtonNeeded && i == widget.photos.length) {
            return AddPhotoButton(onPressed: widget.onAddPressed,);
          }

          final photo = widget.photos[i];
          final isDeleteModeActive = i == _deletePhotoModeIndex && widget.isAddButtonNeeded;

          return PressableWidget(
            onPressed: () {
              if (isDeleteModeActive) {
                setState(() => _deletePhotoModeIndex = null);
                return;
              }

              Navigator.of(context).push(
                  PageRouteBuilder(
                      opaque: false,
                      pageBuilder: (_, _, _) =>
                          PhotoGalleryScreen(
                              photos: widget.photos,
                              initialIndex: i
                          )
                  )
              );
            },
            onLongTap: () {
              if (widget.isAddButtonNeeded) {
                setState(() => _deletePhotoModeIndex = i);
                HapticFeedback.mediumImpact();
              }
            },
            child: Stack(
              children: [
                Hero(
                    tag: photo.imageUrl,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: _buildPhoto(photo.imageUrl)
                    )
                ),

                if (isDeleteModeActive)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: PressableWidget(
                        onPressed: () => _showDeleteConfirmation(photo.id),
                        child: ClipOval(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                            child: Container(
                              padding: const EdgeInsets.all(9),
                              color: Colors.black.withValues(alpha: 0.08),
                              child: Assets.icons.trash.svg(
                                width: 22,
                                height: 26
                              )
                            ),
                          ),
                        )
                    ),
                  ),
              ],
            )
          );
        },
      ),
    );
  }
}
