import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:place_see_app/ui/theme/app_colors.dart';
import 'package:place_see_app/ui/theme/app_typography.dart';

import '../../../gen/assets.gen.dart';

class FiltersSection extends StatefulWidget {
  final String title;
  final String selectedText;
  final WidgetBuilder builder;

  const FiltersSection({super.key, required this.title, required this.selectedText, required this.builder});

  @override
  State<FiltersSection> createState() => _FiltersSectionState();
}

class _FiltersSectionState extends State<FiltersSection> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        widget.title,
                      style: AppTypography.chapterHeadingDark,
                    ),
                    if (!expanded && widget.selectedText.isNotEmpty)
                      Text(
                        widget.selectedText,
                        style: AppTypography.subTextLight,
                      )
                  ],
                ),
            ),
            IconButton(
                onPressed: () => setState(() => expanded = !expanded),
                icon: expanded ?
                    Assets.icons.close.svg(
                      width: 24,
                      height: 24
                    ) :
                    Assets.icons.plus.svg(
                      width: 24,
                      height: 24
                    )
            )
          ],
        ),

        AnimatedCrossFade(
          duration: const Duration(milliseconds: 250),
          crossFadeState: expanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          firstChild: Padding(
              padding: const EdgeInsets.only(top:12),
            child: widget.builder(context),
          ),
          secondChild: const SizedBox.shrink(),
        ),

        const Divider(
          height: 25,
          color: AppColors.additionalTwo,
        )
      ],
    );
  }
}
