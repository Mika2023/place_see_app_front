import 'package:flutter/material.dart';
import 'package:place_see_app/core/model/filters/price_filter.dart';
import 'package:place_see_app/ui/widget/filters/price_preset_section.dart';

class PriceFilterSection extends StatefulWidget {
  final PriceFilter initialState;
  final ValueChanged<PriceFilter> onChanged;

  const PriceFilterSection({super.key, required this.initialState, required this.onChanged});

  @override
  State<PriceFilterSection> createState() => _PriceFilterSectionState();
}

class _PriceFilterSectionState extends State<PriceFilterSection> {
  late final TextEditingController _minController;
  late final TextEditingController _maxController;
  late PriceFilter state;
  late PricePreset preset = PricePreset.any;

  @override
  void initState() {
    super.initState();
    state = widget.initialState;
    preset = PricePreset.any;

    _minController = TextEditingController(text: widget.initialState.minPrice?.toString() ?? '');
    _maxController = TextEditingController(text: widget.initialState.maxPrice?.toString() ?? '');
  }

  @override
  void didUpdateWidget(covariant PriceFilterSection oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.initialState != widget.initialState) {
      state = widget.initialState;
      preset = PricePreset.any;

      _minController.text = widget.initialState.minPrice?.toString() ?? '';
      _maxController.text = widget.initialState.maxPrice?.toString() ?? '';
    }
  }

  @override
  void dispose() {
    _minController.dispose();
    _maxController.dispose();
    super.dispose();
  }

  void _update() {
    final min = double.tryParse(_minController.text);
    final max = double.tryParse(_maxController.text);
    final newState = PriceFilter(minPrice: min, maxPrice: max);
    state = newState;
    widget.onChanged(newState);
  }

  void _applyPreset(double? min, double? max) {
    _minController.text = min?.toString() ?? '';
    _maxController.text = max?.toString() ?? '';
    final newState = PriceFilter(minPrice: min, maxPrice: max);
    state = newState;
    widget.onChanged(newState);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
                child: TextField(
                  style: Theme.of(context).textTheme.bodySmall,
                  controller: _minController,
                  cursorHeight: 30,
                  decoration: InputDecoration(
                    constraints: const BoxConstraints(
                      maxHeight: 50,
                      minHeight: 50
                    ),
                      label: Text(
                        'От',
                        style: Theme.of(context).textTheme.bodySmall,
                      )
                  ),
                  onChanged: (_) => _update(),
                )
            ),
            const SizedBox(width: 12,),
            Expanded(
                child: TextField(
                  controller: _maxController,
                  style: Theme.of(context).textTheme.bodySmall,
                  cursorHeight: 30,
                  decoration: InputDecoration(
                      constraints: const BoxConstraints(
                          maxHeight: 50,
                          minHeight: 50
                      ),
                      label: Text(
                        'До',
                        style: Theme.of(context).textTheme.bodySmall,
                      )
                  ),
                  onChanged: (_) => _update(),
                )
            ),
          ],
        ),

        const SizedBox(height: 12,),

        PricePresetSection(
            selected: preset,
            onChanged: (preset) {
              if (!mounted) return;
             setState(() {
               this.preset = preset;
               _applyPreset(preset.priceFilter.minPrice, preset.priceFilter.maxPrice);
             });
            }
        )
      ],
    );
  }
}
