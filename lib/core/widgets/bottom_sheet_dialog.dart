import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void showErrorDialog(BuildContext context, String message) {
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
