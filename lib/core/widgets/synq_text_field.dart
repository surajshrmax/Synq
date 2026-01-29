import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:synq/config/constants.dart';

class SynqTextField extends StatefulWidget {
  final String hintText;
  final TextEditingController? controller;
  final Function(String changed)? onChange;
  const SynqTextField({
    super.key,
    required this.hintText,
    this.controller,
    this.onChange,
  });

  @override
  State<SynqTextField> createState() => _SynqTextFieldState();
}

class _SynqTextFieldState extends State<SynqTextField> {
  bool focused = false;
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      setState(() {
        focused = focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedContainer(
      duration: Duration(milliseconds: 120),
      transform: Matrix4.translationValues(
        focused ? defaultOffsetValue : 0,
        focused ? defaultOffsetValue : 0,
        0,
      ),
      height: 60.h,
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border.all(width: 2, color: theme.dividerColor),
        borderRadius: BorderRadius.circular(defaultBorderRadiusValue),

        boxShadow: [
          BoxShadow(
            color: theme.dividerColor,
            offset: Offset(
              focused ? 0 : defaultOffsetValue,
              focused ? 0 : defaultOffsetValue,
            ),
          ),
        ],
      ),

      child: Center(
        child: TextField(
          decoration: InputDecoration(
            border: InputBorder.none,
            hint: Text(widget.hintText),
          ),
          controller: widget.controller,
          focusNode: focusNode,
          onTapOutside: (_) => setState(() => focusNode.unfocus()),
          onTap: () => setState(() => focusNode.requestFocus()),
          onChanged: widget.onChange,
        ),
      ),
    );
  }
}
