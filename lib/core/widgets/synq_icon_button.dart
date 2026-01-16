import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:synq/config/theme/app_text_colors.dart';

class SynqIconButton extends StatefulWidget {
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
  State<SynqIconButton> createState() => _SynqIconButtonState();
}

class _SynqIconButtonState extends State<SynqIconButton> {
  bool isPressed = false;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.extension<AppTextColors>();
    return GestureDetector(
      onTapDown: (_) => setState(() => isPressed = true),
      onTapUp: (_) {
        setState(() => isPressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => isPressed = false),
      child: AnimatedContainer(
        height: 40.h,
        width: 40.h,
        transform: Matrix4.translationValues(
          isPressed ? 4 : 0,
          isPressed ? 4 : 0,
          0,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: widget.color ?? theme.dividerColor,
          ),
          color: widget.color ?? theme.dividerColor,
          boxShadow: [
            BoxShadow(
              color: Colors.lightGreenAccent,
              offset: isPressed ? Offset.zero : Offset(4, 4),
            ),
          ],
        ),
        duration: Duration(milliseconds: 120),
        child: Center(child: Icon(widget.icon, color: Colors.white)),
      ),
    );
  }
}
