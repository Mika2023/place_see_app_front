import 'package:flutter/material.dart';

class PlaceholderWithIconWidget extends StatelessWidget {
  final Widget icon;
  final String text;
  final EdgeInsets padding;

  const PlaceholderWithIconWidget({
    super.key,
    required this.icon,
    required this.text,
    this.padding = const EdgeInsets.symmetric(horizontal: 32)
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
          padding: padding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon,
            const SizedBox(height: 40,),
            Text(
              text,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            )
          ],
        ),
      ),
    );
  }
}
