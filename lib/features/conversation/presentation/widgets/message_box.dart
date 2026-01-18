import 'package:flutter/material.dart';
import 'package:synq/core/widgets/synq_animated_container.dart';
import 'package:synq/core/widgets/synq_container.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MessageBox extends StatefulWidget {
  const MessageBox({super.key});

  @override
  State<MessageBox> createState() => _MessageBoxState();
}

class _MessageBoxState extends State<MessageBox> {
  bool isTextBoxEmpty = true;

  TextEditingController messageBoxController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    void updateState(bool value) {
      if (value == isTextBoxEmpty) return;
      setState(() {
        isTextBoxEmpty = value;
      });
    }

    return SynqContainer(
      margin: EdgeInsets.only(
        bottom: mediaQuery.padding.bottom + 10.h,
        left: 10,
        right: 10,
      ),
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      borderRadius: BorderRadius.circular(40),
      boxConstraints: BoxConstraints(maxHeight: mediaQuery.size.height * 0.40),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 15.r,
        children: [
          AnimatedSize(
            duration: Duration(milliseconds: 200),
            child: isTextBoxEmpty
                ? SynqAnimatedContainer(
                    height: 40.h,
                    width: 40.h,
                    shadowOffSet: Offset(1, 1),
                    onPressed: () {},
                    borderRadius: BorderRadius.circular(30),
                    child: Center(child: Icon(Icons.add)),
                  )
                : SizedBox.shrink(),
          ),
          Expanded(
            child: TextField(
              minLines: null,
              maxLines: null,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Type Message Here...',
              ),
              keyboardType: TextInputType.multiline,
              controller: messageBoxController,
              onChanged: (value) => messageBoxController.text.isNotEmpty
                  ? updateState(false)
                  : updateState(true),
            ),
          ),
          AnimatedSize(
            duration: Duration(milliseconds: 200),
            child: SizedBox(
              height: 50.h,
              width: 50.h,
              child: isTextBoxEmpty
                  ? SizedBox.shrink()
                  : SynqAnimatedContainer(
                      onPressed: () {},
                      backgroundColor: Colors.lightGreenAccent,
                      shadowOffSet: Offset.zero,
                      borderRadius: BorderRadius.circular(40),
                      child: Icon(Icons.keyboard_arrow_up),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
