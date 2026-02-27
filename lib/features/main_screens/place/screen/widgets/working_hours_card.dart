import 'package:flutter/material.dart';
import 'package:place_see_app/core/model/filters/day_enum.dart';
import 'package:place_see_app/core/utils/working_hours_utils.dart';
import 'package:place_see_app/ui/theme/app_colors.dart';

import '../../../../../gen/assets.gen.dart';

class WorkingHoursCard extends StatefulWidget {
  final Map<DayEnum, List<Map<String, String>>> workingHours;

  const WorkingHoursCard({super.key, required this.workingHours});

  @override
  State<WorkingHoursCard> createState() => _WorkingHoursCardState();
}

class _WorkingHoursCardState extends State<WorkingHoursCard> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    final workingHoursNormalized = WorkingHoursUtils.formatWorkingHoursToMap(widget.workingHours) ?? {};
    final todayWeekDay = WorkingHoursUtils.fromInt(DateTime.now().weekday);
    final todayHours = workingHoursNormalized[todayWeekDay];

    String label = '';

    if (todayHours == null || todayHours.isEmpty) {
      label = 'Выходной';
    } else if (WorkingHoursUtils.checkIfWorking24On7(workingHoursNormalized)) {
      label = 'Круглосуточно';
    } else {
      label = WorkingHoursUtils.formatToPeriod(todayHours);
    }

    return GestureDetector(
      onTap: () => setState(() => expanded = !expanded),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.additionalTwo,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Assets.icons.timeClock.svg(
                    width: 24,
                    height: 24
                ),
                const SizedBox(width: 7,),

                Expanded(
                    child: Text(
                      label,
                      style: Theme.of(context).textTheme.labelMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                ),

                const SizedBox(width: 7,),

                AnimatedRotation(
                  turns: expanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 250),
                  child: Assets.icons.arrowDown.svg(
                      width: 11,
                      height: 11
                  ),
                )
              ],
            ),

            if (expanded) ...[
              const SizedBox(height: 12,),
              Column(
                children: DayEnum.values.map((day) {
                  final periods = workingHoursNormalized?[day];

                  final text = (periods == null || periods.isEmpty)
                      ? 'Выходной'
                      : WorkingHoursUtils.formatToPeriod(periods);

                  final shortDay = WorkingHoursUtils.dayShort(day);

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text(
                      '$shortDay · $text',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  );
                }).toList(),
              )
            ]
          ],
        ),
      ),
    );
  }
}
