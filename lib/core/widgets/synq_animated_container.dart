import 'package:flutter/material.dart';
import 'package:synq/config/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SynqAnimatedContainer extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final Duration? duration;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final Color? shadowColor;
  final Color? borderColor;
  final Offset? shadowOffSet;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final double? height;
  final double? width;

  const SynqAnimatedContainer({
    super.key,
    required this.child,
    this.duration,
    this.borderRadius,
    this.backgroundColor,
    this.shadowColor,
    this.shadowOffSet,
    this.margin,
    this.padding,
    this.onPressed,
    this.height,
    this.width,
    this.borderColor,
  });

  @override
  State<SynqAnimatedContainer> createState() => _SynqAnimatedContainerState();
}

class _SynqAnimatedContainerState extends State<SynqAnimatedContainer> {
  bool _isPressed = false;

  void updateUi(bool value) {
    if (widget.onPressed == null) return;
    setState(() {
      _isPressed = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTapDown: (details) => updateUi(true),
      onTapUp: (details) {
        updateUi(false);
        widget.onPressed!();
      },
      onTapCancel: () => updateUi(false),
      child: AnimatedContainer(
        height: widget.height,
        width: widget.width,
        padding: widget.padding ?? EdgeInsets.zero,
        margin: widget.margin ?? EdgeInsets.zero,
        duration: defaultPressAnimationDuration,

        transform: Matrix4.translationValues(
          _isPressed ? widget.shadowOffSet?.dx ?? defaultOffsetValue : 0,
          _isPressed ? widget.shadowOffSet?.dy ?? defaultOffsetValue : 0,
          0,
        ),

        decoration: BoxDecoration(
          color: widget.backgroundColor ?? theme.scaffoldBackgroundColor,
          border: Border.all(
            color: widget.borderColor ?? theme.dividerColor,
            width: 2,
          ),
          borderRadius:
              widget.borderRadius ??
              BorderRadius.circular(defaultBorderRadiusValue),

          boxShadow: [
            BoxShadow(
              color: widget.shadowColor ?? theme.dividerColor,
              offset: _isPressed
                  ? Offset(0, 0)
                  : widget.shadowOffSet ??
                        Offset(defaultOffsetValue, defaultOffsetValue),
            ),
          ],
        ),
        child: Center(child: widget.child),
      ),
    );
  }
}
