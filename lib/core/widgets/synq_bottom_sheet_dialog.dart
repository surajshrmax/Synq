import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:synq/config/constants.dart';
import 'package:synq/core/widgets/synq_container.dart';

class SynqBottomSheetDialog {
  static void showErrorDialog(BuildContext context, String message) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Container(
          margin: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).padding.bottom,
          ),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
          ),

          child: Wrap(
            children: [
              Padding(
                padding: EdgeInsets.all(10.r),
                child: Text(
                  'Error',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ),
              Divider(color: Theme.of(context).dividerColor),
              Padding(
                padding: EdgeInsets.all(10.r),
                child: Text(message, style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        );
      },
    );
  }

  static Widget _buildItemWidget(DialogItem item) => Material(
    color: Colors.transparent,
    child: InkWell(
      borderRadius: BorderRadius.circular(defaultBorderRadiusValue),
      onTap: () => item.onPressed!(),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        child: Row(
          spacing: 15,
          children: [
            HugeIcon(icon: item.icon, color: item.iconColor),
            Text(item.title, style: TextStyle(color: item.textColor)),
          ],
        ),
      ),
    ),
  );

  static void showDialog({
    required BuildContext context,
    required String title,
    String? message = "",
    List<DialogItem>? items,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SynqContainer(
          width: double.infinity,
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom,
          ),
          padding: EdgeInsets.all(15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, style: TextStyle(fontStyle: FontStyle.italic)),
              if (items != null)
                for (var item in items) _buildItemWidget(item),
            ],
          ),
        );
      },
    );
  }
}

class DialogItem {
  final List<List<dynamic>> icon;
  final Color? iconColor;
  final double iconSize;
  final String title;
  final Color? textColor;
  final double textSize;
  final FontWeight fontWeight;
  final VoidCallback? onPressed;

  const DialogItem({
    required this.icon,
    required this.title,
    required this.onPressed,
    this.iconColor,
    this.iconSize = 24,
    this.textColor,
    this.textSize = 16,
    this.fontWeight = FontWeight.w400,
  });
}
