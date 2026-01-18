import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:synq/config/constants.dart';

class SynqContainer extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final double? height;
  final double? width;
  final BoxConstraints? boxConstraints;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final BorderRadius? borderRadius;
  final bool shadow;
  final Color? backgroundColor;
  final Color? shadowColor;
  const SynqContainer({
    super.key,
    required this.child,
    this.borderRadius,
    this.onPressed,
    this.height,
    this.width,
    this.padding,
    this.margin,
    this.boxConstraints,
    this.shadow = false,
    this.backgroundColor,
    this.shadowColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => onPressed!(),
      child: Container(
        height: height,
        width: width,
        padding: padding,
        margin: margin,
        constraints: boxConstraints,
        decoration: BoxDecoration(
          color: backgroundColor ?? theme.scaffoldBackgroundColor,
          borderRadius:
              borderRadius ?? BorderRadius.circular(defaultBorderRadiusValue),
          border: Border.all(width: 2, color: theme.dividerColor),
          boxShadow: shadow
              ? [
                  BoxShadow(
                    color: shadowColor ?? theme.dividerColor,
                    offset: Offset(2, 2),
                  ),
                ]
              : [],
        ),
        child: child,
      ),
    );
  }
}
