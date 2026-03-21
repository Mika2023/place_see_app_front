import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:place_see_app/features/main_screens/maps/view_model/maps_view_model.dart';
import 'package:place_see_app/features/main_screens/place/screen/widgets/place_user_photos.dart';
import 'package:place_see_app/features/main_screens/profile/screen/widgets/edit_profile_dialog.dart';
import 'package:place_see_app/features/main_screens/profile/screen/widgets/routes_widget.dart';
import 'package:place_see_app/features/main_screens/profile/view_model/profile_view_model.dart';
import 'package:place_see_app/ui/enum/view_mode.dart';
import 'package:place_see_app/ui/widget/add_photo_button.dart';
import 'package:place_see_app/ui/widget/add_photo_dialog.dart';
import 'package:place_see_app/ui/widget/app_text_button.dart';
import 'package:place_see_app/ui/widget/decoration/top_circular_border.dart';
import 'package:place_see_app/ui/widget/nav_bar/nav_bar_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../ui/theme/app_colors.dart';
import '../../../../ui/widget/photo_gallery_screen.dart';
import '../../../../ui/widget/placeholder_with_icon_widget.dart';
import '../../../../ui/widget/stateful/pressable_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ViewMode _routesViewMode = ViewMode.horizontal;
  ViewMode _photosViewMode = ViewMode.horizontal;
  int? _deletePhotoModeIndex;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = context.read<ProfileViewModel>();
      vm.loadUser();
      vm.loadRoutes();
      vm.loadPhotos();
      vm.preloadPlaces();
    });
  }

  ImageProvider _buildAvatarPhoto(String path) {
    if (path.startsWith("http")) {
      return CachedNetworkImageProvider(path,);
    }

    return FileImage(File(path));
  }

  Future<void> _onPressedRoute(
      int routeId,
      BuildContext context,
      ProfileViewModel vm,
      MapsViewModel routesVm,
      NavBarProvider navigatorVm
  ) async {
    final route = await vm.getRouteById(routeId);

    if (route == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Не удалось загрузить маршрут")),
      );
      return;
    }

    routesVm.setRoute(route);
    navigatorVm.setIndex(1);
  }

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

  void _showDeleteConfirmation(int photoId, ProfileViewModel vm) {
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
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 18
                  ),
                )
            ),
            FilledButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  vm.deletePhoto(photoId);
                  setState(() => _deletePhotoModeIndex = null);
                },
                style: FilledButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    backgroundColor: AppColors.lightRed,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12)
                ),
                child: Text(
                    "Удалить",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 18,
                        color: AppColors.primary
                    )
                )
            ),
          ],
        )
    );
  }

  Widget _buildPhotoGrid(ProfileViewModel vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextButton(
          textOnButton: 'Моя галерея',
          onPressed: () {
            setState(() {
              _photosViewMode = ViewMode.horizontal;
              _deletePhotoModeIndex = null;
            });
          },
          prefixIcon: Assets.icons.folder.svg(
              width: 35,
              height: 35
          ),
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontSize: 30
          ),
        ),

        const SizedBox(height: 14,),

        GridView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.only(top: 0),
            physics: const NeverScrollableScrollPhysics(),
            itemCount: vm.photos.length + 1,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 18,
                childAspectRatio: 0.85
            ),
            itemBuilder: (_, i) {
              if (i == 0) {
                return Column(
                  children: [
                    AspectRatio(
                      aspectRatio: 0.9842,
                      child: AddPhotoButton(
                        onPressed: () => _openAddPhotoDialog(context),
                      ),
                    ),
                  ],
                );
              }

              final photo = vm.photos[i - 1];
              final isDeleteModeActive = (i - 1) == _deletePhotoModeIndex;

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
                                  photos: vm.photoFullInfo,
                                  initialIndex: i-1
                              )
                      )
                  );
                },
                  onLongTap: () {
                      setState(() => _deletePhotoModeIndex = i - 1);
                      HapticFeedback.mediumImpact();
                  },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
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
                                  onPressed: () => _showDeleteConfirmation(photo.id, vm),
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
                    ),

                    const SizedBox(height: 6,),

                    Text(
                      photo.place.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelMedium,
                    )
                  ],
                )
              );
            }
        )
      ],
    );
  }

  Widget _buildRouteGrid(
      BuildContext context,
      ProfileViewModel vm,
      MapsViewModel routesVm,
      NavBarProvider navigatorVm
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextButton(
          textOnButton: 'Мои путешествия',
          onPressed: () {
            setState(() {
              _routesViewMode = ViewMode.horizontal;
            });
          },
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontSize: 30
          ),
          prefixIcon: Assets.icons.pin.svg(
              width: 40,
              height: 40
          ),
        ),

        const SizedBox(height: 14,),

        GridView.builder(
          padding: const EdgeInsets.only(top: 0),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: vm.routes.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 18,
                childAspectRatio: 0.85
            ),
            itemBuilder: (_, i) {
              final route = vm.routes[i];
              final url = vm.buildUrlForRouteImg(i);
              final date = route.createdAt != null ? DateFormat('dd.MM.yyyy').format(route.createdAt!) : '';

              return PressableWidget(
                  onPressed: () => _onPressedRoute(route.id, context, vm, routesVm, navigatorVm),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Hero(
                            tag: url ?? 'https://lqtiftmgexxmtoohvldc.supabase.co/storage/v1/object/public/place_photos/b1cc9987043f82eda1963ab8ba5d03c5%20(1).jpg',
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: CachedNetworkImage(
                                  imageUrl: url ?? 'https://lqtiftmgexxmtoohvldc.supabase.co/storage/v1/object/public/place_photos/b1cc9987043f82eda1963ab8ba5d03c5%20(1).jpg',
                                  fit: BoxFit.cover,
                                )
                            )
                        ),
                      ),

                      const SizedBox(height: 6,),

                      Text(
                        date,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelMedium,
                      )
                    ],
                  )
              );
            }
        )
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    final vm = context.watch<ProfileViewModel>();
    final routesVm = context.read<MapsViewModel>();
    final navigatorVm = context.read<NavBarProvider>();

    if (vm.isLoading) return _whileLoading();

    if (vm.isError) {
      return _onError(
        'Упс!\nКажется, произошла ошибка. Проверьте подключение к Интернету или обратитесь в поддержку',
        Assets.icons.noData.svg(
            width: 82,
            height: 82
        ),
      );
    }

    if (_photosViewMode == ViewMode.grid) {
      if (vm.photos.length < 3) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.55,
          child: _buildPhotoGrid(vm),
        );
      }
      return _buildPhotoGrid(vm);
    }
    if (_routesViewMode == ViewMode.grid && vm.routes.isNotEmpty) {
      if (vm.routes.length < 3) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.55,
          child: _buildRouteGrid(context, vm, routesVm, navigatorVm),
        );
      }
      return _buildRouteGrid(context, vm, routesVm, navigatorVm);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextButton(
            textOnButton: 'Мои путешествия',
            onPressed: () {
              setState(() {
                _routesViewMode = ViewMode.grid;
              });
            },
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontSize: 30
          ),
          prefixIcon: Assets.icons.pin.svg(
              width: 40,
              height: 40
          ),
        ),

        const SizedBox(height: 14,),

        if (vm.routes.isEmpty && !vm.isLoading && !vm.isError) ...[
          PlaceholderWithIconWidget(
            height: 14,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 18
              ),
              icon: Assets.icons.compass.svg(
                width: 40,
                height: 40
              ),
              text: "Сохраненных маршрутов пока нет.\nВремя отправиться в путешествие!",
          ),
        ] else ...[
          RoutesWidget(
              routes: vm.routes,
              buildUrl: vm.buildUrlForRouteImg,
              onPressedRoute: (routeId) => _onPressedRoute(routeId, context, vm, routesVm, navigatorVm)
          ),
        ],

        const SizedBox(height: 40,),

        AppTextButton(
            textOnButton: 'Моя галерея',
            onPressed: () {
              setState(() {
                _photosViewMode = ViewMode.grid;
              });
            },
          prefixIcon: Assets.icons.folder.svg(
              width: 35,
              height: 35
          ),
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontSize: 30
          ),
        ),

        const SizedBox(height: 14,),

        PlaceUserPhotos(
            photos: vm.photoFullInfo,
            onDelete: (photoId) => vm.deletePhoto(photoId),
            isAddButtonNeeded: true,
            onAddPressed: () => _openAddPhotoDialog(context)
        ),
      ],
    );
  }

  Widget _whileLoading() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.55,
      child: Center(
        child: PlaceholderWithIconWidget(
          icon: Assets.icons.timeClock.svg(
            width: 82,
            height: 82,
          ),
          text: 'Сейчас появятся информация о профиле',
          padding: const EdgeInsets.symmetric(horizontal: 22),
        ),
      ),
    );
  }

  Widget _onError(String text, Widget icon) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.55,
      child: Center(
        child: PlaceholderWithIconWidget(
              icon: icon,
              text: text,
              padding: const EdgeInsets.symmetric(horizontal: 22),
            )
      ),
    );
  }

  void _openAddPhotoDialog(BuildContext context) {
    final vm = context.read<ProfileViewModel>();

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => AddPhotoDialog(
          placesForSearch: vm.placesForSearch,
          onApply: vm.uploadPhoto,
        )
    );
  }

  void _openEditProfileDialog(BuildContext context) {
    final vm = context.read<ProfileViewModel>();

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => EditProfileDialog(
          onApply: vm.editUser,
          initialNickname: vm.userProfileInfo?.nickname ?? '',
          initialAvatar: vm.userProfileInfo?.avatarImageUrl ??
              'https://lqtiftmgexxmtoohvldc.supabase.co/storage/v1/object/public/place_photos/b1cc9987043f82eda1963ab8ba5d03c5%20(1).jpg',
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProfileViewModel>();

    return Scaffold(
        backgroundColor: AppColors.accentOne,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SafeArea(
                  child: SizedBox(
                    height: 230,
                    child:  Stack(
                      alignment: Alignment.center,
                      children: [
                        Center(
                          child: CircleAvatar(
                            radius: 105,
                            backgroundImage: _buildAvatarPhoto(
                                vm.userProfileInfo?.avatarImageUrl ??
                                'https://lqtiftmgexxmtoohvldc.supabase.co/storage/v1/object/public/place_photos/b1cc9987043f82eda1963ab8ba5d03c5%20(1).jpg')
                          ),
                        ),

                        if (_routesViewMode == ViewMode.grid || _photosViewMode == ViewMode.grid)
                          Positioned(
                            left: 16,
                            top: 5,
                            child: PressableWidget(
                              onPressed: () {
                                setState(() {
                                  _routesViewMode = ViewMode.horizontal;
                                  _photosViewMode = ViewMode.horizontal;
                                });
                              },
                              child: ClipOval(
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                                  child: Container(
                                    width: 44,
                                    height: 44,
                                    padding: const EdgeInsets.all(6),
                                    color: Colors.black.withValues(alpha: 0.09),
                                    child: Assets.icons.arrowLeftDark.svg(
                                      width: 24,
                                      height: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                        Positioned(
                          right: 16,
                          bottom: 5,
                          child: PopupMenuButton<String>(
                              icon: Assets.icons.setting.svg(
                                  height: 37,
                                  width: 37
                              ),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)
                              ),
                              onSelected: (value) {
                                if (value == 'logout') {
                                  vm.logout();
                                }
                                if (value == 'edit') {
                                  _openEditProfileDialog(context);
                                }
                              },
                              color: AppColors.primary,
                              elevation: 8,
                              shadowColor: AppColors.blackForShadow.withValues(alpha: 0.6),
                              itemBuilder: (context) =>
                              [
                                PopupMenuItem(
                                    value: 'logout',
                                    child: Row(
                                      children: [
                                        Assets.icons.logout.svg(
                                            width: 28,
                                            height: 28
                                        ),
                                        const SizedBox(width: 5,),
                                        Text(
                                          'Выход',
                                          style: Theme
                                              .of(context)
                                              .textTheme
                                              .labelMedium,
                                        )
                                      ],
                                    )
                                ),
                                PopupMenuItem(
                                    value: 'edit',
                                    child: Row(
                                      children: [
                                        Assets.icons.pencil.svg(
                                            width: 28,
                                            height: 28
                                        ),
                                        const SizedBox(width: 5,),
                                        Text(
                                          'Редактировать',
                                          style: Theme
                                              .of(context)
                                              .textTheme
                                              .labelMedium,
                                        )
                                      ],
                                    )
                                )
                              ]
                          ),
                        )
                      ],
                    ),
                  )
              ),

              const SizedBox(height: 15,),

              ClipPath(
                clipper: TopCircularBorder(),
                child: Container(
                    padding: const EdgeInsets.fromLTRB(22, 40, 22, 22),
                    color: AppColors.primary,
                    child: _buildBody(context)
                ),
              ),
            ],
          ),
        )
    );
  }
}
