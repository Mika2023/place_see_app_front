import 'package:flutter/material.dart';
import 'package:place_see_app/ui/theme/app_colors.dart';

class FilterRatioItem<T> extends StatelessWidget {
  final T value;
  final T? groupValue;
  final String label;
  final ValueChanged<T> onChanged;

  const FilterRatioItem({super.key, required this.value, this.groupValue, required this.label, required this.onChanged});

  bool get _selected => value == groupValue;

  @override
  Widget build(BuildContext context) {
    final color = AppColors.secondary;

    return GestureDetector(
      onTap: () {
        onChanged(value);
      },
      child: Row(
        children: [
          AnimatedContainer(
              duration: const Duration(milliseconds: 500),
            width: 23,
            height: 23,
            decoration: ShapeDecoration(
              color: AppColors.primary,
                shape: OvalBorder(
                  side: BorderSide(width: 2, color:  color),
                )
            ),
            child: _selected ? const Center(
              child: SizedBox(
                width: 12,
                height: 12,
                child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      shape: BoxShape.circle
                    )
                ),
              ),
            ) : null,
          ),

          const SizedBox(width: 6,),

          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
          )
        ],
      ),
    );
  }
}
