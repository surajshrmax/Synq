import 'package:flutter/material.dart';

class SynqContainer extends StatelessWidget {
  final Widget child;
  const SynqContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: theme.dividerColor),
      ),
      child: child,
    );
  }
}
