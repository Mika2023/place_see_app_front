import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:place_see_app/features/main_screens/maps/view_model/maps_view_model.dart';
import 'package:place_see_app/features/main_screens/place/screen/widgets/place_user_photos.dart';
import 'package:place_see_app/features/main_screens/profile/screen/widgets/edit_profile_dialog.dart';
import 'package:place_see_app/features/main_screens/profile/screen/widgets/routes_widget.dart';
import 'package:place_see_app/features/main_screens/profile/view_model/profile_view_model.dart';
import 'package:place_see_app/ui/widget/add_photo_dialog.dart';
import 'package:place_see_app/ui/widget/decoration/top_circular_border.dart';
import 'package:place_see_app/ui/widget/nav_bar/nav_bar_provider.dart';
import 'package:provider/provider.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../ui/theme/app_colors.dart';
import '../../../../ui/widget/placeholder_with_icon_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Assets.icons.pin.svg(
              width: 40,
              height: 40
            ),
            const SizedBox(width: 6,),
            Text(
                'Мои путешествия',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: 30
              ),
            )
          ],
        ),

        const SizedBox(height: 14,),

        if (vm.routes.isEmpty && !vm.isLoading && !vm.isError) ...[
          PlaceholderWithIconWidget(
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
              onPressedRoute: (routeId) async {

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
          ),
        ],

        const SizedBox(height: 40,),

        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Assets.icons.folder.svg(
                width: 35,
                height: 35
            ),
            const SizedBox(width: 6,),
            Text(
              'Моя галерея',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: 30
              ),
            )
          ],
        ),

        const SizedBox(height: 14,),

        PlaceUserPhotos(
            photos: vm.photoFullInfo,
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
