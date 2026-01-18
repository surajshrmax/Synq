import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:synq/config/theme/app_text_colors.dart';
import 'package:synq/core/widgets/synq_container.dart';

class MessageListItem extends StatelessWidget {
  final String name;
  final String message;
  final String imageUrl;
  final String time;

  const MessageListItem({
    super.key,
    required this.name,
    required this.message,
    required this.imageUrl,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.extension<AppTextColors>();
    final mediaQuery = MediaQuery.of(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        spacing: 10,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 40,
            width: 40,
            child: ClipOval(child: Image.asset("assets/images/demo.jpg")),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  spacing: 5,
                  children: [
                    Text(
                      "Exception",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.blue,
                      ),
                    ),
                    Icon(Icons.verified, size: 15, color: Colors.amber),
                    Text(
                      "at 7:11 PM",
                      style: TextStyle(
                        fontSize: 10,
                        color: textTheme?.secondaryTextColor,
                      ),
                    ),
                  ],
                ),
                Text(
                  "Jyada se jyada home me warning dikha do dyamic, kabhi error aaye to kah do under maintainance, update ho jaye tab hata do",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
