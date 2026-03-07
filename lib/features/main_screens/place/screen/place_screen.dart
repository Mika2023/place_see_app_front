import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:place_see_app/features/main_screens/place/screen/widgets/place_header.dart';
import 'package:place_see_app/features/main_screens/place/screen/widgets/place_tags.dart';
import 'package:place_see_app/features/main_screens/place/screen/widgets/place_user_photos.dart';
import 'package:place_see_app/features/main_screens/place/screen/widgets/places_nearby.dart';
import 'package:place_see_app/features/main_screens/place/screen/widgets/working_hours_card.dart';
import 'package:place_see_app/features/main_screens/place/view_model/place_view_model.dart';
import 'package:place_see_app/ui/navigator/navigator_inner_tab_service.dart';
import 'package:place_see_app/ui/theme/app_colors.dart';
import 'package:place_see_app/ui/theme/app_typography.dart';
import 'package:place_see_app/ui/widget/app_button.dart';
import 'package:place_see_app/ui/widget/nav_bar/map_data_provider.dart';
import 'package:place_see_app/ui/widget/nav_bar/nav_bar_provider.dart';
import 'package:provider/provider.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../ui/widget/placeholder_with_icon_widget.dart';

class PlaceScreen extends StatefulWidget {
  final int id;

  const PlaceScreen({super.key, required this.id});

  @override
  State<PlaceScreen> createState() => _PlaceScreenState();
}

class _PlaceScreenState extends State<PlaceScreen> {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PlaceViewModel>().loadPlace(widget.id);
      context.read<PlaceViewModel>().loadPlacesNearby(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PlaceViewModel>();

    if (vm.isLoading) {
      return SafeArea(
        child: PlaceholderWithIconWidget(
          icon: Assets.icons.pin.svg(
            width: 82,
            height: 82,
          ),
          text: 'Сейчас появится выбранное место...',
          padding: const EdgeInsets.symmetric(horizontal: 22),
        ),
      );
    }

    if (vm.isError || vm.placeFullInfo == null) {
      return SafeArea(
          child: PlaceholderWithIconWidget(
            icon: Assets.icons.noData.svg(
                width: 82,
                height: 82
            ),
            text: 'Упс! Кажется, произошла ошибка\nПроверьте подключение к Интернету или обратитесь в поддержку',
            padding: const EdgeInsets.symmetric(horizontal: 22),
          )
      );
    }

    final place = vm.placeFullInfo!;
    final isUserPhotos = vm.userPhotos.isNotEmpty;
    final isPlacesNearby = vm.placesNearby != null && vm.placesNearby!.isNotEmpty;

    return Scaffold(
      extendBody: true,
      body: CustomScrollView(
              slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 330,
                          child: PlaceHeader(photos: vm.mainPhotos),
                        ),

                        Transform.translate(
                          offset: const Offset(0, -20),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              decoration: const BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(16)
                                  )
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    place.name,
                                    style: Theme
                                        .of(context)
                                        .textTheme
                                        .headlineMedium,
                                  ),

                                  const SizedBox(height: 14,),

                                  Row(
                                    children: [
                                      Assets.icons.pin.svg(
                                          height: 28,
                                          width: 28
                                      ),
                                      const SizedBox(width: 6,),

                                      Expanded(
                                          child: Text(
                                            place.address ?? 'Москва',
                                            style: AppTypography.smallTextLight,
                                          )
                                      )
                                    ],
                                  ),

                                  const SizedBox(height: 14,),

                                  PlaceTags(tags: vm.tags),

                                  const SizedBox(height: 14,),

                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: WorkingHoursCard(workingHours: place.workingHours ?? {}),),
                                      const SizedBox(width: 5,),
                                      Expanded(child:
                                      Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: AppColors.additionalTwo,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Row(
                                          children: [
                                            Assets.icons.discs.svg(
                                                width: 20,
                                                height: 23
                                            ),
                                            const Spacer(),

                                            Text(
                                              place.visitCost == 0 ? 'Бесплатно' : '${place
                                                  .visitCost.toInt()}₽',
                                              style: Theme
                                                  .of(context)
                                                  .textTheme
                                                  .labelMedium,
                                            ),
                                            const Spacer(),
                                          ],
                                        ),
                                      ))
                                    ],
                                  ),

                                 if (vm.getMetroStations() != null) ...[
                                   const SizedBox(height: 14,),

                                   Row(
                                     children: [
                                       Text(
                                         'Метро',
                                         style: AppTypography.chapterHeadingDark,
                                       ),
                                       const SizedBox(width: 10,),
                                       Expanded(
                                           child: Text(
                                             vm.getMetroStations()!,
                                             style: Theme
                                                 .of(context)
                                                 .textTheme
                                                 .labelSmall,
                                           )
                                       )
                                     ],
                                   ),
                                 ],

                                  const SizedBox(height: 14,),

                                  if (isUserPhotos) ...[
                                    Text(
                                      'Фотографии пользователей',
                                      style: AppTypography.chapterHeadingDark,
                                    ),

                                    const SizedBox(height: 12,),

                                    SizedBox(
                                      height: 190,
                                      child: PlaceUserPhotos(photos: vm.userPhotos),
                                    ),

                                    const SizedBox(height: 20,),
                                  ],

                                  if (isPlacesNearby) ...[
                                    Text(
                                      'Места рядом',
                                      style: AppTypography.chapterHeadingDark,
                                    ),

                                    const SizedBox(height: 12,),

                                    SizedBox(
                                      height: 220,
                                      child: PlacesNearby(
                                        places: vm.placesNearby,
                                      ),
                                    ),
                                  ],

                                  const SizedBox(height: 60,)
                                ],
                              ),
                            ),
                        )
                        ]
                    )
                  ),
                ],
              ),
          bottomNavigationBar: SafeArea(
            minimum: const EdgeInsets.fromLTRB(50, 0, 50, 20),
              child: Container(
                color: Colors.transparent,
                height: 58,
                child: AppButton(
                      textOnButton: 'Проложить маршрут',
                      icon: Assets.icons.arrowRight.svg(
                        width: 19,
                        height: 16
                      ),
                      onPressed: () {
                        context.read<MapDataProvider>().setPlace(vm.placeFullInfo!.id, vm.placeFullInfo!.name);
                        context.read<NavBarProvider>().setIndex(1);
                      }
                ),
              )
          )
      );
  }
}

