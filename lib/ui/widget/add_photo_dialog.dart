import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:place_see_app/core/model/place/place_short_for_search.dart';
import 'package:place_see_app/ui/enum/app_button_state.dart';
import 'package:place_see_app/ui/widget/add_photo_button.dart';
import 'package:place_see_app/ui/widget/app_button.dart';
import 'package:place_see_app/ui/widget/app_text_button.dart';
import 'package:place_see_app/ui/widget/search_places_sheet.dart';

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
  AppButtonState _appButtonState = AppButtonState.enabled;

  Future<void> _pickImage(ImageSource source) async {
    final file = await _picker.pickImage(source: source);

    if (file != null) {
      setState(() {
        image = file;
      });
    }
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
              selectedPlace = newPlace;
            },
            onDismissed: () {}
        )
    );
  }

  void _upload() {
    if (selectedPlace == null || image == null || _appButtonState == AppButtonState.loading) return;

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
        const SnackBar(content: Text("Ошибка загрузки фото")),
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
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, controller) {
          return Container(
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Добавить фото',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),

                    const SizedBox(height: 16,),

                    AddPhotoButton(onPressed: () => _pickImage(ImageSource.gallery),),

                    const SizedBox(height: 16,),

                    AppTextButton(
                        textOnButton: selectedPlace?.name ?? "Выбрать место",
                        style: Theme.of(context).textTheme.labelMedium,
                        postfixIcon: Icon(Icons.keyboard_arrow_down),
                        onPressed: _openSearchSheet
                    ),

                    const SizedBox(height: 16,),

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
