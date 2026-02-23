import 'package:flutter/material.dart';
import 'package:place_see_app/core/model/filters/day_enum.dart';
import 'package:place_see_app/core/model/filters/working_hours_state.dart';
import 'package:place_see_app/core/utils/working_hours_utils.dart';

class WorkingHoursPicker extends StatelessWidget {
  final WorkingHoursState state;
  final ValueChanged<WorkingHoursState> onChanged;

  const WorkingHoursPicker({super.key, required this.state, required this.onChanged});

  Widget _timeButton(BuildContext context,
  {required String label,
  required TimeOfDay? time,
  required ValueChanged<TimeOfDay> onPick,
  }) {
    return OutlinedButton(
        onPressed: () async {
          final picked = await showTimePicker(context: context, initialTime: time ?? const TimeOfDay(hour: 0, minute: 0));
          if (picked != null) onPick(picked);
        },
        child: Text(
          '$label ${time != null ? time.format(context) : '--:--'}',
          style: Theme.of(context).textTheme.bodySmall,
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Wrap(
          spacing: 8,
          children: DayEnum.values.map((d) {
            final selected = state.openDays.contains(d);

            return FilterChip(
                label: Text(
                  WorkingHoursUtils.dayShort(d),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                selected: selected,
                onSelected: (isSelected) {
                  final newDays = {...state.openDays};
                  isSelected ? newDays.add(d) : newDays.remove(d);

                  onChanged(
                    WorkingHoursState(
                      openDays: newDays,
                      from: state.from,
                      to: state.to
                    )
                  );
                }
            );
          }).toList(),
        ),

        const SizedBox(height: 16,),

        Row(
          children: [
            Expanded(
                child: _timeButton(
                    context,
                    label: 'С',
                    time: state.from,
                    onPick: (t) => onChanged(
                      WorkingHoursState(
                        openDays: state.openDays,
                        from: t,
                        to: state.to
                      ),
                    )
                ),
            ),
            const SizedBox(width: 12,),
            Expanded(
              child: _timeButton(
                  context,
                  label: 'До',
                  time: state.to,
                  onPick: (t) => onChanged(
                    WorkingHoursState(
                        openDays: state.openDays,
                        from: state.from,
                        to: t
                    ),
                  )
              ),
            ),
          ],
        )
      ],
    );
  }
}
