import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:synq/core/widgets/synq_animated_container.dart';

class SynqIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color? color;
  const SynqIconButton({
    super.key,
    this.color,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SynqAnimatedContainer(
      onPressed: () => onPressed(),
      height: 40.h,
      width: 40.h,
      backgroundColor: color ?? theme.dividerColor,
      borderRadius: BorderRadius.circular(10),
      shadowColor: Colors.lightGreenAccent,
      shadowOffSet: Offset(2, 2),
      child: Icon(icon, color: Colors.white),
    );
  }
}
