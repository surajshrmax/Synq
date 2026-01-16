import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SynqButton extends StatefulWidget {
  final String title;
  final VoidCallback onPressed;
  final bool showLoading;
  const SynqButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.showLoading = false,
  });

  @override
  State<SynqButton> createState() => _SynqButtonState();
}

class _SynqButtonState extends State<SynqButton> {
  Offset offset = Offset(6, 6);
  bool pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => pressed = true),
      onTapUp: (_) {
        setState(() => pressed = false);
        if (widget.showLoading) {
          return;
        }
        widget.onPressed();
      },
      onTapCancel: () => setState(() => pressed = false),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 120),
        transform: Matrix4.translationValues(
          pressed ? 6 : 0,
          pressed ? 6 : 0,
          0,
        ),
        height: 60.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.lightGreenAccent,
          border: Border.all(color: Colors.grey.shade800, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade800,
              offset: pressed ? Offset(0, 0) : offset,
            ),
          ],
        ),

        child: widget.showLoading
            ? Center(
                child: SizedBox(
                  height: 60.h,
                  child: LinearProgressIndicator(
                    color: Colors.orange,
                    backgroundColor: Colors.lightGreenAccent,
                  ),
                ),
              )
            : Center(
                child: Text(
                  widget.title,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
      ),
    );
  }
}
