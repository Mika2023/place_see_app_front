import 'package:flutter/material.dart';
import 'package:place_see_app/core/model/place/place_short_for_search.dart';
import 'package:place_see_app/ui/widget/app_button.dart';
import 'package:place_see_app/ui/widget/app_input_widget.dart';
import 'package:place_see_app/ui/widget/placeholder_with_icon_widget.dart';

import '../../gen/assets.gen.dart';
import '../theme/app_colors.dart';

class SearchPlacesSheet extends StatefulWidget {
  final List<PlaceShortForSearch> placesForSearch;
  final ValueChanged<PlaceShortForSearch> onApply;
  final VoidCallback onDismissed;
  final PlaceShortForSearch? initialPlace;

  const SearchPlacesSheet({
    super.key,
    required this.placesForSearch,
    required this.onApply,
    required this.onDismissed,
    this.initialPlace
  });

  @override
  State<SearchPlacesSheet> createState() => _SearchPlacesSheetState();
}

class _SearchPlacesSheetState extends State<SearchPlacesSheet> {
  late List<PlaceShortForSearch> filteredPlaces;
  PlaceShortForSearch? selectedPlace;
  bool isSearching = false;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    filteredPlaces = widget.placesForSearch;
    selectedPlace = widget.initialPlace;
    _controller = TextEditingController();
  }

  void _onSearchChanged(String val) {
    final query = _controller.text.toLowerCase();

    setState(() {
      isSearching = true;
      filteredPlaces = widget.placesForSearch.where((p) => p.name.toLowerCase().contains(query)).toList();
    });
  }

  void _selectPlace(PlaceShortForSearch selected) {
    setState(() {
      if (selected == selectedPlace) {
        selectedPlace = null;
        _controller.clear();
        return;
      }

      selectedPlace = selected;
      _controller.text = selected.name;
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length),
      );
    });
  }

  Widget _buildFilteredPlacesList(ScrollController controller) {
    if (filteredPlaces.isNotEmpty) {
      return ListView.builder(
          controller: controller,
          itemCount: filteredPlaces.length,
          itemBuilder: (_, index) {
            final place = filteredPlaces[index];
            final isSelected = selectedPlace?.id == place.id;

            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              color: isSelected ? AppColors.disabledLight : AppColors.primary,
              child: ListTile(
                title: Text(
                  place.name,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                trailing: isSelected ? Assets.icons.check.svg(
                    width: 15,
                    height: 15
                ) : null,
                onTap: () => _selectPlace(place),
              ),
            );
          },
      );
    }

    return LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: SafeArea(
                      child: PlaceholderWithIconWidget(
                        icon: Assets.icons.search.svg(
                            width: 82,
                            height: 82
                        ),
                        text: 'По вашему запросу ничего не найдено',
                        padding: const EdgeInsets.symmetric(horizontal: 22),
                      )
                  ),
                ),
              )
          );
        }
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
                  children: [
                    AppInputWidget(
                      hint: 'Найти место',
                      prefixIcon: Assets.icons.search.svg(
                          width: 26,
                          height: 26
                      ),
                      postfixIcon: isSearching ? GestureDetector(
                        onTap: () {
                          _controller.clear();
                          setState(() {
                            filteredPlaces = widget.placesForSearch;
                          });
                        },
                        child: Assets.icons.close.svg(
                            width: 17,
                            height: 17
                        ),
                      ) : null,
                      onChanged: _onSearchChanged,
                      controller: _controller,
                    ),

                    const SizedBox(height: 16,),

                      Expanded(
                          child: _buildFilteredPlacesList(controller)
                      ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(22, 0, 22, 8),
                      child: SizedBox(
                        width:  double.infinity,
                        height: 58,
                        child: AppButton(
                            textOnButton: 'Показать результаты',
                            onPressed: () {
                              if (selectedPlace == null) return;

                              widget.onApply(selectedPlace!);
                              Navigator.of(context).pop(true);
                            }
                        ),
                      ),
                    )
                  ]
              )
          );
        }
    );
  }
}
