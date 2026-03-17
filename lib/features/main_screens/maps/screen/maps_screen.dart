import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:place_see_app/core/mapper/routes/route_model_mapper.dart';
import 'package:place_see_app/core/model/place/place_short_for_search.dart';
import 'package:place_see_app/features/main_screens/profile/view_model/profile_view_model.dart';
import 'package:place_see_app/ui/widget/app_text_button.dart';
import 'package:place_see_app/ui/widget/nav_bar/map_data_provider.dart';
import 'package:place_see_app/ui/widget/search_places_sheet.dart';
import 'package:provider/provider.dart';
import 'package:place_see_app/core/config/app_config.dart';
import 'package:place_see_app/features/main_screens/maps/view_model/maps_view_model.dart';
import 'package:place_see_app/ui/theme/app_colors.dart';
import 'package:place_see_app/ui/widget/app_button.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../ui/widget/placeholder_with_icon_widget.dart';

class MapsScreen extends StatefulWidget {

  const MapsScreen({super.key});

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  MapsViewModel? vm;
  int? _lastPlaceId;
  String? _lastPlaceName;
  String? _fromPlace;
  String? _toPlace;
  late final MapController _mapController;
  late final DraggableScrollableController _sheetController;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _sheetController = DraggableScrollableController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      vm = context.read<MapsViewModel>();
      vm!.preloadPlaces();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final mapData = context.watch<MapDataProvider>();
    final placeId = mapData.placeId;
    final placeName = mapData.placeName;
    vm = context.read<MapsViewModel>();

    if (placeId != null && placeId != _lastPlaceId) {
      _fromPlace = 'Ваше местоположение';
      _lastPlaceId = placeId;
      vm!.loadRoute(placeId);
    }
    if (placeName != null && placeName != _lastPlaceName) {
      _lastPlaceName = placeName;
    }
  }

  String _buildFromPlaceName() {
    final vm = context.read<MapsViewModel>();

    if (vm.isFromProfile) return vm.getFirstPlaceNameFromProfile() ?? 'Ваше местоположение';
    return _fromPlace ?? 'Ваше местоположение';
  }

  String _buildToPlaceName() {
    final vm = context.read<MapsViewModel>();

    if (vm.isFromProfile) return vm.getLastPlaceNameFromProfile() ?? 'Не определено';
    if (vm.wasEdited) {
      return _toPlace?? 'Не определено';
    }
    return _lastPlaceName ?? 'Не определено';
  }

  void _openSearchSheet(bool isStartPlace) async {
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
            initialPlace: isStartPlace ? null :
            PlaceShortForSearch(id: _lastPlaceId ?? 0, name: _lastPlaceName ?? ''),
            placesForSearch: vm!.placesForSearch,
            onApply: (newPlace) {
              vm?.editRoute(isStartPlace, newPlace.id);
              if (!isStartPlace) {
                _toPlace = newPlace.name;
              } else {
                _fromPlace = newPlace.name;
              }
            },
            onDismissed: () {}
        )
    );
  }

  Widget? _buildBottomSheet() {
    if (vm!.isEmptyRouteNormal) return null;

    return DraggableScrollableSheet(
            controller: _sheetController,
            initialChildSize: 0.32,
            minChildSize: 0.12,
            maxChildSize: 0.32,
            builder: (context, controller) {
              return Container(
                  height: 200,
                  margin: const EdgeInsets.symmetric(
                      horizontal: 9, vertical: 16),
                  padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(blurRadius: 10, color: AppColors.blackForShadow)
                    ],
                  ),
                  child: LayoutBuilder(
                      builder: (context, constraints) {
                        return SingleChildScrollView(
                          controller: controller,
                          physics: const ClampingScrollPhysics(),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: constraints.maxHeight,
                            ),
                            child: IntrinsicHeight(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  _buildIfNotNormalEmpty(),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                   )
              );
            }
    );
  }

  Widget _buildIfNotNormalEmpty() {
    if (vm!.isLoading) {
      return Center(
        child: PlaceholderWithIconWidget(
          icon: Assets.icons.pin.svg(width: 60, height: 60),
          text: 'Сейчас появится маршрут...',
          padding: const EdgeInsets.symmetric(horizontal: 22),
          style: Theme.of(context).textTheme.bodySmall,
          height: 20,
        ),
      );
    }

    if (vm!.isError || vm!.route == null && !vm!.isEmptyRouteNormal) {
      return Center(
        child: PlaceholderWithIconWidget(
          icon: Assets.icons.noData.svg(width: 45, height: 45),
          text:
          'Упс! Кажется, произошла ошибка\nПроверьте подключение к Интернету или обратитесь в поддержку',
          padding: const EdgeInsets.symmetric(horizontal: 22),
          style: Theme.of(context).textTheme.bodySmall,
          height: 30,
        ),
      );
    }

    if (vm!.isRouteCompleted) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
              'Маршрут завершен!',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold
              )
          ),

          const SizedBox(height: 12,),

          Row(
            children: [
              Assets.icons.timeClock.svg(
                height: 20,
                width: 20
              ),
              const SizedBox(width: 10,),
              Text(
                  'Пройдено ${vm!.totalDistance} за ${vm!.route!.totalDuration}',
                  style: Theme.of(context).textTheme.bodySmall
              ),
            ],
          ),

          const SizedBox(height: 18,),

          Text(
              'Ваш маршрут сохранен в профиле',
              style: Theme.of(context).textTheme.labelSmall
          ),

          const SizedBox(height: 50,),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  _buildFromPlaceName(),
                  style: Theme.of(context).textTheme.bodySmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Row(
                children: List.generate(
                  3,
                      (_) => Container(
                    width: 10,
                    height: 10,
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    decoration: const ShapeDecoration(
                      color: AppColors.accentOne,
                      shape: OvalBorder(),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  _buildToPlaceName(),
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.end,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          ),
        ],
      );
    }

    if (vm!.isNavigationMode) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
              'Навигация запущена!',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold
              )
          ),

          const SizedBox(height: 14,),

          Text(
              'Осталось ${vm!.remainingDistance}',
              style: Theme.of(context).textTheme.bodySmall
          ),

          const SizedBox(height: 14,),

          AppButton(
            textOnButton: 'Завершить маршрут',
            onPressed: () {
              vm!.stopNavigation();
            },
          ),

          const SizedBox(height: 14),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                    _buildFromPlaceName(),
                    style: Theme.of(context).textTheme.bodySmall,
                    overflow: TextOverflow.ellipsis,
                  )
              ),
              Row(
                children: List.generate(
                  3,
                      (_) => Container(
                    width: 10,
                    height: 10,
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    decoration: const ShapeDecoration(
                      color: AppColors.accentOne,
                      shape: OvalBorder(),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  _buildToPlaceName(),
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.end,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          ),
        ],
      );
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mapController.move(vm!.beginOfPath, 17);
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
            'Ваш маршрут построен!',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold
            )
        ),

        const SizedBox(height: 12,),

        Row(
          children: [
            Text(vm!.route!.totalDuration, style: Theme.of(context).textTheme.bodySmall),
            const Spacer(),
            Text(vm!.totalDistance, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),

        const SizedBox(height: 12,),

        AppButton(
          textOnButton: 'Начать движение',
          onPressed: () {
            vm!.startNavigation();
          },
          icon: Assets.icons.arrowRight.svg(
              width: 19,
              height: 16
          ),
        ),

        const SizedBox(height: 10,),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: AppTextButton(
                    textOnButton: _buildFromPlaceName(),
                    onPressed: () => _openSearchSheet(true),
                  style: Theme.of(context).textTheme.bodySmall,
                  overflow: TextOverflow.ellipsis,
                )
            ),
            Row(
              children: List.generate(
                3,
                    (_) => Container(
                  width: 10,
                  height: 10,
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  decoration: const ShapeDecoration(
                    color: AppColors.accentOne,
                    shape: OvalBorder(),
                  ),
                ),
              ),
            ),
            Expanded(
                child: AppTextButton(
                    textOnButton: _buildToPlaceName(),
                    onPressed: () => _openSearchSheet(false),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall,
                )
            )
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    vm = context.watch<MapsViewModel>();

    if (vm!.isNavigationMode && vm!.userPosition != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _mapController.move(vm!.userPosition!, 17);
      });
    }

    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: vm!.userPosition ?? vm!.beginOfPath,
            initialZoom: 14,
            maxZoom: 30,
            minZoom: 3,
          ),
          children: [
            TileLayer(
              urlTemplate:
              'https://tile0.maps.2gis.com/v2/tiles/online_sd/{z}/{x}/{y}.png?key=${AppConfig.twoGisApiKey}',
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: vm!.userPosition ?? vm!.beginOfPath,
                  width: 20,
                  height: 20,
                  child: Assets.icons.dotFilled.svg(width: 20, height: 20),
                ),

                if (vm!.route != null && !vm!.isEmptyRouteNormal) ...[
                  if (vm!.endOfPath != null)
                    Marker(
                      point: vm!.endOfPath!,
                      width: 43,
                      height: 43,
                      child: Transform.translate(
                          offset: const Offset(0, -16),
                          child: Assets.icons.pinFilled.svg(width: 43, height: 43)
                      ),
                    ),

                  Marker(
                    point: vm!.beginOfPath,
                    width: 20,
                    height: 20,
                    child: Assets.icons.circle.svg(width: 20, height: 20),
                  ),
                ]

              ],
            ),
            if (vm!.route != null && !vm!.isEmptyRouteNormal) ...[
              if (vm!.route!.path.isNotEmpty)
                PolylineLayer(
                  polylines: [
                    Polyline(
                        points: vm!.isNavigationMode ? vm!.remainingRoute : vm!.polylines,
                        color: AppColors.secondary,
                        strokeWidth: 5
                    )
                  ],
                ),

            ]
          ],
        ),

        _buildBottomSheet() ?? const SizedBox(),
      ],
    );
  }
}