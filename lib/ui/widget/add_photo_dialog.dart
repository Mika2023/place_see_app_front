import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:place_see_app/core/model/place/place_short_for_search.dart';
import 'package:place_see_app/core/permission/permission_service.dart';
import 'package:place_see_app/ui/enum/app_button_state.dart';
import 'package:place_see_app/ui/theme/app_typography.dart';
import 'package:place_see_app/ui/widget/app_button.dart';
import 'package:place_see_app/ui/widget/app_text_button.dart';
import 'package:place_see_app/ui/widget/search_places_sheet.dart';
import 'package:place_see_app/ui/widget/stateful/pressable_widget.dart';

import '../../gen/assets.gen.dart';
import '../theme/app_colors.dart';

class AddPhotoDialog extends StatefulWidget {
  final List<PlaceShortForSearch> placesForSearch;
  final void Function(PlaceShortForSearch place, XFile image) onApply;
  const AddPhotoDialog({super.key, required this.placesForSearch, required this.onApply});

  @override
  State<AddPhotoDialog> createState() => _AddPhotoDialogState();
}

class _AddPhotoDialogState extends State<AddPhotoDialog> {
  PlaceShortForSearch? selectedPlace;
  XFile? image;
  final ImagePicker _picker = ImagePicker();
  AppButtonState _appButtonState = AppButtonState.disabled;

  Future<void> _pickImage(ImageSource source) async {
    final resultPermission = await PermissionService.checkGalleryPermission();

    switch(resultPermission) {
      case PermissionStatus.granted:
        final file = await _picker.pickImage(source: source);

        if (file != null) {
          setState(() {
            image = file;

            if (selectedPlace != null) _appButtonState = AppButtonState.enabled;
          });
        }
        break;
      case PermissionStatus.permanentlyDenied:
        _showGoToSettingsDialog(context);
        break;
      default:
        _showPermissionDeniedDialog(context);
        break;
    }
  }

  void _showPermissionDeniedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
            "Нет доступа",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold
          ),
          textAlign: TextAlign.center
        ),
        content: Text(
            "Разрешите доступ к галерее, чтобы выбрать фото",
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        actions: [
          FilledButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              style: FilledButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  backgroundColor: AppColors.secondary,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12)
              ),
              child: Text(
                  "Ок",
                  style: AppTypography.buttonTextDark
              )
          ),
        ],
      ),
    );
  }

  void _showGoToSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actionsOverflowDirection: VerticalDirection.down,
        actionsOverflowButtonSpacing: 8,
        title: Text(
            "Доступ запрещён",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold
          ),
          textAlign: TextAlign.center,
        ),
        content: Text(
          "Вы запретили доступ к галерее. Разрешите его в настройках приложения.",
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                "Отмена",
                style: AppTypography.smallButtonTextDark
              )
          ),
          FilledButton(
              onPressed: () {
                openAppSettings();
                Navigator.pop(ctx);
              },
              style: FilledButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  backgroundColor: AppColors.secondary,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12)
              ),
              child: Text(
                  "Настройки",
                  style: AppTypography.smallButtonTextDark
              )
          ),
        ],
      ),
    );
  }

  void _openSearchSheet() async {
    final animationController = AnimationController(
        vsync: Navigator.of(context),
        duration: const Duration(milliseconds: 800),
        reverseDuration: const Duration(milliseconds: 350)
    );

    final response = await showModalBottomSheet<bool>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        transitionAnimationController: animationController,
        builder: (_) => SearchPlacesSheet(
          initialPlace: selectedPlace,
            placesForSearch: widget.placesForSearch,
            onApply: (newPlace) {
              setState(() {
                selectedPlace = newPlace;

                if (image != null) _appButtonState = AppButtonState.enabled;
              });
            },
            onDismissed: () {}
        )
    );
  }

  void _upload() {
    if (selectedPlace == null || image == null || _appButtonState == AppButtonState.loading || _appButtonState == AppButtonState.disabled) return;

    setState(() {
      _appButtonState = AppButtonState.loading;
    });

    try {
      widget.onApply(
        selectedPlace!,
        image!
      );

      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Ошибка загрузки фото.\n Попробуйте добавить фотографию меньшего размера")),
      );
    } finally {
      setState(() {
        _appButtonState = AppButtonState.enabled;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.75,
        builder: (context, controller) {
          return Container(
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: Assets.icons.cirlceClose.svg(
                              width: 29,
                              height: 29,
                            ),
                          ),
                        ),

                        Text(
                          'Добавить фото',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold
                          )
                        ),
                      ],
                    ),

                    const SizedBox(height: 16,),

                    PressableWidget(
                      onPressed: () => _pickImage(ImageSource.gallery),
                      child: Container(
                        width: double.infinity,
                        height: 190,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                            color: AppColors.additionalOne
                        ),
                        child: image == null ?
                            Center(
                              child: Assets.icons.plus.svg(
                                  height: 40,
                                  width: 40
                              ),
                            )
                            : ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.file(
                            File(image!.path),
                            fit: BoxFit.cover,
                          ),
                        )
                      ),
                    ),

                    const SizedBox(height: 10,),

                    AppTextButton(
                        textOnButton: selectedPlace?.name ?? "Выбрать место",
                        style: AppTypography.chapterHeadingDark,
                        postfixIcon: Icon(Icons.keyboard_arrow_down),
                        onPressed: _openSearchSheet,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 10,),

                    AppButton(
                        textOnButton: "Добавить",
                        onPressed: _upload,
                      state: _appButtonState,
                    )
                  ]
              )
          );
        }
    );
  }
}
