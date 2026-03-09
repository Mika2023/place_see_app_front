import 'package:flutter/material.dart';
import 'package:place_see_app/features/main_screens/favorite_places/view_model/favorite_places_view_model.dart';
import 'package:place_see_app/ui/theme/app_colors.dart';
import 'package:provider/provider.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../ui/widget/decoration/top_circular_border.dart';
import '../../../../ui/widget/place_widget.dart';
import '../../../../ui/widget/placeholder_with_icon_widget.dart';
import '../../place/screen/place_screen.dart';

class FavoritePlacesScreen extends StatefulWidget {
  const FavoritePlacesScreen({super.key});

  @override
  State<FavoritePlacesScreen> createState() => _FavoritePlacesScreenState();
}

class _FavoritePlacesScreenState extends State<FavoritePlacesScreen> {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FavoritePlacesViewModel>().loadFavPlaces();
    });
  }

  Widget _whileLoading() {
    return LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: SafeArea(
                    child: PlaceholderWithIconWidget(
                      icon: Assets.icons.timeClock.svg(
                        width: 82,
                        height: 82,
                      ),
                      text: 'Сейчас появятся интересные места...',
                      padding: const EdgeInsets.symmetric(horizontal: 22),
                    ),
                  ),
                ),
              )
          );
        }
    );
  }

  Widget _onError(String text, Widget icon) {
    return LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: SafeArea(
                      child: PlaceholderWithIconWidget(
                        icon: icon,
                        text: text,
                        padding: const EdgeInsets.symmetric(horizontal: 22),
                      )
                  ),
                ),
              )
          );
        }
    );
  }

  Widget _buildBody(BuildContext context) {
    final vm = context.watch<FavoritePlacesViewModel>();

    if (vm.isLoading) {
      return _whileLoading();
    }

    if (!vm.isLoading && vm.places.isEmpty && !vm.isError) {
      return _onError(
        'Избранные места отсутсвуют.\nВремя найти то место, которое точно придется по душе!',
        Assets.icons.heartCracked.svg(
            width: 82,
            height: 82
        ),
      );
    }

    if (vm.isError && vm.places.isEmpty && !vm.isLoading) {
      return _onError(
        'Упс!\nКажется, произошла ошибка. Проверьте подключение к Интернету или обратитесь в поддержку',
        Assets.icons.noData.svg(
            width: 82,
            height: 82
        ),
      );
    }

    final places = vm.places;

    return ListView.separated(
      padding: const EdgeInsets.all(22),
      separatorBuilder: (_, _) => const SizedBox(height: 22,),
      itemCount: places.length,
      itemBuilder: (context, index) {
        final place = places[index];
        return PlaceWidget(
          placeCard: place,
          onTap: () =>
          {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (_) =>
                    PlaceScreen(id: place.id)))
          },
          onFavTap: () => vm.deleteFavorite(index),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.accentTwo,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: AppColors.accentTwo,
              elevation: 4,
              forceElevated: innerBoxIsScrolled,
              shadowColor: Colors.black.withValues(alpha: 0.2),
              pinned: true,
              expandedHeight: 160,
              automaticallyImplyLeading: false,
              title: SafeArea(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(6, 18, 22, 16),
                  child: Text(
                    'Избранное',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppColors.primary
                    ),
                  ),
                )
              ),
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.parallax,
                background: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(22, 55, 22, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Места, которые Вам нравятся',
                          style: Theme
                              .of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                              color: AppColors.primary
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              ),
            ),
          ];
        },
        body: ClipPath(
          clipper: TopCircularBorder(),
          child: Container(
              padding: const EdgeInsets.only(top: 40),
              color: AppColors.primary,
              child: _buildBody(context)
          ),
        ),
      ),
    );
  }
}
