import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
      transform: Matrix4.translationValues(focused ? 4 : 0, focused ? 4 : 0, 0),
      height: 60.h,
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border.all(width: 2, color: theme.dividerColor),

        boxShadow: [
          BoxShadow(
            color: theme.dividerColor,
            offset: Offset(focused ? 0 : 6, focused ? 0 : 6),
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
