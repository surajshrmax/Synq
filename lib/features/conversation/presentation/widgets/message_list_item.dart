import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synq/config/theme/app_text_colors.dart';
import 'package:synq/core/widgets/synq_container.dart';
import 'package:synq/features/conversation/data/models/message_model.dart';
import 'package:synq/features/conversation/presentation/bloc/message/message_bloc.dart';
import 'package:synq/features/conversation/presentation/bloc/message/message_state.dart';

class MessageListItem extends StatelessWidget {
  final VoidCallback onPressed;
  final MessageModel message;
  final bool showTime;
  final Function(DismissDirection direction) onDrag;
  final int index;
  const MessageListItem({
    super.key,
    required this.onPressed,
    required this.message,
    this.showTime = false,
    required this.onDrag,
    required this.index,
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
                  Text(
                    "${message.sendAt!.toLocal().day}/${message.sendAt!.toLocal().month}/${message.sendAt!.toLocal().year}",
                  ),
                  Expanded(child: Divider()),
                ],
              ),
            ),
          ),
          Dismissible(
            direction: DismissDirection.endToStart,
            movementDuration: Duration(milliseconds: 100),
            resizeDuration: Duration(milliseconds: 100),
            background: Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.all(10),
              child: Icon(Icons.reply, color: textTheme?.secondaryTextColor),
            ),
            confirmDismiss: (direction) => onDrag(direction),
            key: ValueKey(message.sendAt),
            child: Column(
              spacing: 10,
              children: [
                message.reply != null
                    ? Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          spacing: 10,
                          children: [
                            Icon(
                              Icons.reply,
                              size: 14,
                              color: textTheme?.secondaryTextColor,
                            ),
                            Expanded(
                              child: Text(
                                message.reply!.content,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: textTheme?.secondaryTextColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : SizedBox(),
                Row(
                  spacing: 10,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 40,
                      width: 40,
                      child: ClipOval(
                        child: Image.asset("assets/images/demo.jpg"),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            spacing: 5,
                            children: [
                              Text(
                                message.sender!.profile!.name!,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: index % 2 == 0
                                      ? Colors.blue
                                      : Colors.orange,
                                ),
                              ),
                              // Icon(Icons.verified, size: 15, color: Colors.amber),
                              Text(
                                "at ${message.sendAt!.toLocal().hour}:${message.sendAt!.toLocal().minute} ${message.sendAt!.toLocal().hour < 12 ? 'AM' : 'PM'}",
                                style: TextStyle(
                                  fontSize: 10,
                                  color: textTheme?.secondaryTextColor,
                                ),
                              ),
                              Visibility(
                                visible: message.isEdited!,
                                child: Icon(
                                  Icons.edit,
                                  size: 10,
                                  color: textTheme?.secondaryTextColor,
                                ),
                              ),
                            ],
                          ),
                          Text(message.content, style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
