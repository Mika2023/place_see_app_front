import 'package:flutter/material.dart';
import 'package:place_see_app/ui/theme/app_typography.dart';

class SearchSuggestionsWidget extends StatelessWidget {
  final List<String> suggestions;
  final void Function(String) onTap;

  const SearchSuggestionsWidget({super.key, required this.suggestions, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 6,
      borderRadius: BorderRadius.circular(16),
      child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 260),
          child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: suggestions.length,
              itemBuilder: (context, i) {
                final suggestion = suggestions[i];
                return InkWell(
                  onTap: () => onTap(suggestion),
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      child: Text(
                        suggestion,
                        style: AppTypography.subTextDark,
                      ),
                  ),
                );
              }
          )
      ),
    );
  }
}
