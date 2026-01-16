import 'package:flutter/material.dart';
import 'package:synq/core/widgets/synq_icon_button.dart';
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

    return Container(
      margin: EdgeInsets.only(bottom: mediaQuery.padding.bottom),
      padding: EdgeInsets.all(10),
      constraints: BoxConstraints(maxHeight: mediaQuery.size.height * 0.40),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(width: 2, color: theme.dividerColor)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 15.r,
        children: [
          AnimatedSize(
            duration: Duration(milliseconds: 200),
            child: isTextBoxEmpty
                ? SizedBox(
                    height: 30.h,
                    width: 30.h,
                    child: SynqIconButton(icon: Icons.add, onPressed: () {}),
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
              height: 30.h,
              width: 30.h,
              child: isTextBoxEmpty
                  ? SizedBox.shrink()
                  : SynqIconButton(
                      icon: Icons.keyboard_arrow_up,
                      color: Colors.orange,
                      onPressed: () {},
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
