import 'package:flutter/material.dart';
import 'package:place_see_app/core/model/category/category_for_filters.dart';
import 'package:place_see_app/core/model/filters/places_filters_state.dart';
import 'package:place_see_app/core/model/filters/transport_type_enum.dart';
import 'package:place_see_app/core/utils/working_hours_utils.dart';
import 'package:place_see_app/ui/theme/app_colors.dart';
import 'package:place_see_app/ui/widget/app_button.dart';
import 'package:place_see_app/ui/widget/app_text_button.dart';
import 'package:place_see_app/ui/widget/filters/filters_section.dart';
import 'package:place_see_app/ui/widget/filters/is_favorite_by_user_section.dart';
import 'package:place_see_app/ui/widget/filters/price_filter_section.dart';
import 'package:place_see_app/ui/widget/filters/sorted_by_section.dart';
import 'package:place_see_app/ui/widget/filters/working_hours_picker.dart';

import '../../../gen/assets.gen.dart';

class FiltersSheet extends StatefulWidget {
  final PlacesFiltersState initialState;
  final ValueChanged<PlacesFiltersState> onApply;
  final VoidCallback onDismissed;

  const FiltersSheet({super.key, required this.initialState, required this.onApply, required this.onDismissed});

  @override
  State<FiltersSheet> createState() => _FiltersSheetState();
}

class _FiltersSheetState extends State<FiltersSheet> {
  late PlacesFiltersState state;

  @override
  void initState() {
    super.initState();
    state = widget.initialState;
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
            child: Column(
              children: [
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Assets.icons.cirlceClose.svg(
                            width: 26,
                            height: 26,
                          ),
                        ),
                      ),

                      Text(
                        'Фильтры',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),

                      Align(
                        alignment: Alignment.centerRight,
                        child: AppTextButton(
                          textOnButton: 'Сбросить',
                          onPressed: () {
                            setState(state.reset);
                          },
                        ),
                      )
                    ],
                  ),
                ),

                const Divider(
                  color: AppColors.additionalTwo,
                  height: 1,
                ),

                Expanded(
                    child: ListView(
                      controller: controller,
                      padding: const EdgeInsets.all(22),
                      children: [

                        FiltersSection(
                          title: 'Отсортировать по',
                          selectedText: state.sort.subName,
                          builder: (context) => SortedBySection(
                            selected: state.sort,
                            onChanged: (val) => setState(() => state.sort = val),
                          ),
                        ),

                        FiltersSection(
                            title: 'Категории',
                            selectedText: state.categoryIds.join(', '),
                            builder: (_) => Wrap(
                              spacing: 8,
                              children: categories.map((c) => FilterChip(
                                backgroundColor: AppColors.additionalOne,
                                  selectedColor: AppColors.accentOne,
                                  label: Text(
                                    c.name,
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                  selected: state.categoryIds.contains(c.id),
                                  onSelected: (isSelected) {
                                    setState(() {
                                      isSelected ? state.categoryIds.add(c.id) : state.categoryIds.remove(c.id);
                                    });
                                  }
                              )).toList(),
                            )
                        ),

                        FiltersSection(
                            title: 'Доступность',
                            selectedText: state.priceFilter.label,
                            builder: (context) => PriceFilterSection(
                                initialState: state.priceFilter,
                                onChanged: (val) => setState(() => state.priceFilter = val),
                            )
                        ),

                        FiltersSection(
                          title: 'Время работы',
                          selectedText: WorkingHoursUtils.workingHoursString(state.workingHoursState),
                          builder: (context) => WorkingHoursPicker(
                            state: state.workingHoursState,
                            onChanged: (val) => setState(() => state.workingHoursState = val),
                          ),
                        ),

                        FiltersSection(
                          title: 'Избранные',
                          selectedText: state.isFavoriteByUserState.name,
                          builder: (context) => IsFavoriteByUserSection(
                            selected: state.isFavoriteByUserState,
                            onChanged: (val) => setState(() => state.isFavoriteByUserState = val),
                          ),
                        ),

                        FiltersSection(
                            title: 'Метро',
                            selectedText: state.selectedStops[TransportTypeEnum.metro] != null ?
                              state.selectedStops[TransportTypeEnum.metro]!.join(', ') :
                              '',
                            builder: (_) => Wrap(
                              spacing: 8,
                              children: metroStations.map((station) => FilterChip(
                                  backgroundColor: AppColors.additionalOne,
                                  selectedColor: AppColors.accentOne,
                                  label: Text(
                                    station,
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                  selected: state.selectedStops[TransportTypeEnum.metro] != null ?
                                    state.selectedStops[TransportTypeEnum.metro]!.contains(station) :
                                    false,
                                  onSelected: (isSelected) {
                                    setState(() {
                                      final selectedStops = state.selectedStops[TransportTypeEnum.metro] ?? Set.identity();
                                      final updatedStops = Set.of(selectedStops);

                                      if (isSelected && !updatedStops.contains(station)) {
                                        updatedStops.add(station);
                                      } else {
                                        updatedStops.remove(station);
                                      }
                                      state.selectedStops = {
                                        ...state.selectedStops,
                                        TransportTypeEnum.metro: updatedStops,
                                      };
                                    });
                                  }
                              )).toList(),
                            )
                        ),
                      ],
                    )
                ),

                Padding(
                    padding: const EdgeInsets.fromLTRB(22, 0, 22, 22),
                  child: SizedBox(
                    width:  double.infinity,
                    height: 58,
                    child: AppButton(
                        textOnButton: 'Показать результаты',
                        onPressed: () {
                          widget.onApply(state);
                          Navigator.of(context).pop(true);
                        }
                    ),
                  ),
                )

              ],
            ),
          );
        }
    );
  }
}

final List<CategoryForFilters> categories = [
  CategoryForFilters(1, 'Азия'),
  CategoryForFilters(2, 'Европа'),
  CategoryForFilters(3, 'Москва'),
];

final List<String> metroStations = [
  "ВДНХ",
  "Ботанический сад",
  "Рижская",
];
