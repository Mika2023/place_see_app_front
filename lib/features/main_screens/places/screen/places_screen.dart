import 'package:flutter/material.dart';
import 'package:place_see_app/core/model/category/category_short.dart';
import 'package:place_see_app/core/model/filters/places_filters_state.dart';
import 'package:place_see_app/features/main_screens/filters/view_model/filters_view_model.dart';
import 'package:place_see_app/features/main_screens/place/screen/place_screen.dart';
import 'package:place_see_app/features/main_screens/places/view_model/places_view_model.dart';
import 'package:place_see_app/ui/theme/app_colors.dart';
import 'package:place_see_app/ui/widget/app_input_widget.dart';
import 'package:place_see_app/ui/widget/decoration/top_circular_border.dart';
import 'package:place_see_app/ui/widget/filters/filters_sheet.dart';
import 'package:place_see_app/ui/widget/place_widget.dart';
import 'package:place_see_app/ui/widget/stateful/pressable_widget.dart';
import 'package:provider/provider.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../ui/widget/placeholder_with_icon_widget.dart';

class PlacesScreen extends StatefulWidget {

  final CategoryShort categoryShort;
  const PlacesScreen({super.key, required this.categoryShort});

  @override
  State<PlacesScreen> createState() => _PlacesScreenState();
}

class _PlacesScreenState extends State<PlacesScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PlacesViewModel>().loadPlaces(widget.categoryShort.id);
      context.read<FiltersViewModel>().preloadAll();
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

  Future<void> openFilters(BuildContext context, PlacesFiltersState state, PlacesViewModel vm) async {
    FocusScope.of(context).unfocus();

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
        builder: (_) => FiltersSheet(
            initialState: state,
            onApply: (newState) {
              vm.applyFilters(newState);
            },
            onDismissed: () {
              vm.resetFilters();
            }
        )
    );

    if (response != true) {
      vm.resetFilters();
    }
  }

  Widget _buildBody(BuildContext context) {
    final vm = context.watch<PlacesViewModel>();

    if (vm.isLoading || vm.isSearching) {
     return _whileLoading();
    }

    if (!vm.isLoading && vm.places.isEmpty) {
      return _onError(
          'Упс!\nКажется, произошла ошибка. Проверьте подключение к Интернету или обратитесь в поддержку',
        Assets.icons.noData.svg(
            width: 82,
            height: 82
        ),
      );
    }

    if (vm.isSearchMode && !vm.isSearching && vm.searchResults.isEmpty) {
      return _onError(
          'По вашему запросу ничего не найдено',
        Assets.icons.search.svg(
            width: 82,
            height: 82
        ),
      );
    }

    if (vm.isFilterMode && !vm.isFiltering && vm.filterResults.isEmpty) {
      return _onError(
        'По вашему запросу ничего не найдено',
        Assets.icons.search.svg(
            width: 82,
            height: 82
        ),
      );
    }

    final places = vm.isSearchMode ? vm.searchResults : (vm.isFilterMode ? vm.filterResults : vm.places);

    return ListView.separated(
      padding: const EdgeInsets.all(22),
      separatorBuilder: (_, _) => const SizedBox(height: 22,),
      itemCount: places.length,
      itemBuilder: (context, index) {
        final place = places[index];
        return PlaceWidget(
          placeCard: place,
          onTap: () => {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (_) =>
                    PlaceScreen(id: place.id)))
          },
          onFavTap: () => vm.toggleFavorite(index, fromSearch: vm.isSearchMode),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final catColor = AppColors.accentOne;
    final textCatColor = AppColors.secondary;
    final vm = context.watch<PlacesViewModel>();

    return Scaffold(
      backgroundColor: catColor,
      body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                backgroundColor: catColor,
                elevation: 4,
                forceElevated: innerBoxIsScrolled,
                shadowColor: Colors.black.withValues(alpha: 0.2),
                pinned: true,
                expandedHeight: 220,
                automaticallyImplyLeading: false,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  background: SafeArea(
                      bottom: false,
                      child: Padding(
                          padding: const EdgeInsets.fromLTRB(22, 20, 22, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.categoryShort.name,
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  color: textCatColor
                              ),
                            ),

                            if (widget.categoryShort.description != null) ...[
                              const SizedBox(height: 3,),
                              Text(
                                widget.categoryShort.description!,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: textCatColor
                                ),
                              ),
                            ]

                          ],
                        ),
                      ),
                  ),
                ),
                bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(45),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(22, 0, 22, 16),
                          child: Row(
                            children: [
                              Expanded(
                                  child: AppInputWidget(
                                      hint: 'Найти место',
                                      prefixIcon: Assets.icons.search.svg(
                                          width: 26,
                                          height: 26
                                      ),
                                      onChanged: vm.onSearchChanged,
                                      controller: _searchController,
                                    ),
                                  ),
                              const SizedBox(width: 7,),
                              PressableWidget(
                                onPressed: () => openFilters(context, vm.filtersState, vm),
                                child: Container(
                                    width: 58,
                                    height: 58,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: textCatColor,
                                        width: 2,
                                      ),
                                    ),
                                    child: Center(
                                      child: Assets.icons.filters.svg(
                                          width: 29,
                                          height: 29
                                      ),
                                    )
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    )
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
