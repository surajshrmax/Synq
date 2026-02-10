import 'package:flutter/material.dart';
import 'package:synq/config/theme/app_text_colors.dart';
import 'package:synq/core/widgets/synq_container.dart';

class MessageListItem extends StatelessWidget {
  final VoidCallback onPressed;
  final String name;
  final String message;
  final String imageUrl;
  final DateTime time;
  final bool showTime;

  const MessageListItem({
    super.key,
    required this.onPressed,
    required this.name,
    required this.message,
    required this.imageUrl,
    required this.time,
    this.showTime = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.extension<AppTextColors>();
    return SynqContainer(
      onPressed: () => onPressed(),
      padding: const EdgeInsets.all(8.0),
      child: Column(
        spacing: 10,
        children: [
          Visibility(
            visible: showTime,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                spacing: 20,
                children: [
                  Expanded(child: Divider()),
                  Text("${time.day}/${time.month}/${time.year}"),
                  Expanded(child: Divider()),
                ],
              ),
            ),
          ),
          Dismissible(
            direction: DismissDirection.endToStart,
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.all(10),
              child: Icon(Icons.reply),
            ),
            confirmDismiss: (direction) async {
              return false;
            },
            onDismissed: (direction) {},
            key: ValueKey(time),
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
                            name,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.blue,
                            ),
                          ),
                          // Icon(Icons.verified, size: 15, color: Colors.amber),
                          Text(
                            "at ${time.toLocal().hour}:${time.toLocal().minute} ${time.toLocal().hour < 12 ? 'AM' : 'PM'}",
                            style: TextStyle(
                              fontSize: 10,
                              color: textTheme?.secondaryTextColor,
                            ),
                          ),
                        ],
                      ),
                      Text(message, style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
