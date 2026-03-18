import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../../core/permission/permission_service.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../../ui/enum/app_button_state.dart';
import '../../../../../ui/theme/app_colors.dart';
import '../../../../../ui/widget/app_button.dart';
import '../../../../../ui/widget/stateful/pressable_widget.dart';

class EditProfileDialog extends StatefulWidget {
  final String initialNickname;
  final void Function(String? nickname, XFile? image) onApply;
  final String initialAvatar;
  const EditProfileDialog({super.key, required this.initialNickname, required this.onApply, required this.initialAvatar});

  @override
  State<EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  XFile? image;
  final ImagePicker _picker = ImagePicker();
  late final TextEditingController nicknameController;
  AppButtonState _appButtonState = AppButtonState.disabled;

  @override
  void initState() {
    super.initState();

    nicknameController = TextEditingController(text: widget.initialNickname);
  }

  Future<void> _pickImage(ImageSource source) async {
    final resultPermission = await PermissionService.checkGalleryPermission();

    switch(resultPermission) {
      case PermissionStatus.granted:
        final file = await _picker.pickImage(source: source);

        if (file != null) {
          setState(() {
            image = file;

            _appButtonState = AppButtonState.enabled;
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
      builder: (_) => AlertDialog(
        title: const Text("Нет доступа"),
        content: const Text("Разрешите доступ к галерее, чтобы выбрать фото"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Ок"),
          )
        ],
      ),
    );
  }

  void _showGoToSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Доступ запрещён"),
        content: const Text(
          "Вы запретили доступ к галерее. Разрешите его в настройках приложения.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Отмена"),
          ),
          TextButton(
            onPressed: () {
              openAppSettings();
              Navigator.pop(context);
            },
            child: const Text("Открыть настройки"),
          ),
        ],
      ),
    );
  }

  void _upload() {
    if (nicknameController.text.isEmpty && image == null || _appButtonState == AppButtonState.loading || _appButtonState == AppButtonState.disabled) return;

    setState(() {
      _appButtonState = AppButtonState.loading;
    });

    try {
      widget.onApply(
          nicknameController.text,
          image
      );

      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Ошибка редактирования профиля.\n Попробуйте добавить фотографию меньшего размера")),
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
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(10, 20, 10, MediaQuery.of(context).viewInsets.bottom),
                controller: controller,
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
                              icon: Assets.icons.close.svg(
                                width: 16,
                                height: 16,
                              ),
                            ),
                          ),

                          Text(
                              'Редактировать профиль',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.bold
                              )
                          ),
                        ],
                      ),

                      const SizedBox(height: 15,),

                      PressableWidget(
                          onPressed: () => _pickImage(ImageSource.gallery),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              CircleAvatar(
                                  radius: 105,
                                  backgroundImage: image != null
                                      ? FileImage(File(image!.path))
                                      : CachedNetworkImageProvider(widget.initialAvatar)
                              ),

                              if (image == null) ...[
                                Container(
                                    width: 210,
                                    height: 210,
                                    decoration: BoxDecoration(
                                      color: Colors.black.withValues(alpha: 0.4),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Assets.icons.camera.svg(
                                          width: 55,
                                          height: 55
                                      ),
                                    )
                                ),
                              ]
                            ],
                          )
                      ),

                      const SizedBox(height: 12,),

                      TextField(
                        controller: nicknameController,
                        textAlign: TextAlign.center,
                        onChanged: (str) {
                          if (str.isNotEmpty) {
                            setState(() {
                              _appButtonState = AppButtonState.enabled;
                            });
                          }
                        },
                        decoration: InputDecoration(
                          hintText: "Введите никнейм",
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),

                      const SizedBox(height: 12,),

                      SizedBox(
                        width: 300,
                        child: AppButton(
                          textOnButton: "Сохранить",
                          onPressed: _upload,
                          state: _appButtonState,
                        ),
                      )
                    ]
                ),
              )
          );
        }
    );
  }
}
