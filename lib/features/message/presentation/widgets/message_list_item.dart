import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:synq/config/theme/app_text_colors.dart';
import 'package:synq/core/widgets/synq_container.dart';
import 'package:synq/features/message/data/models/message_model.dart';
import 'package:synq/features/message/presentation/bloc/message-box/message_box_cubit.dart';
import 'package:synq/features/message/presentation/widgets/swipe_to_reply.dart';
import 'package:synq/features/user/presentation/widgets/profile_image.dart';

class MessageListItem extends StatefulWidget {
  final VoidCallback onPressed;
  final MessageModel message;
  final bool showTime;
  final Function(DismissDirection direction) onDrag;
  final Function(String id, String sentAt)? onReplyClicked;
  final int index;
  const MessageListItem({
    super.key,
    required this.onPressed,
    required this.message,
    this.showTime = false,
    required this.onDrag,
    required this.index,
    this.onReplyClicked,
  });

  @override
  State<MessageListItem> createState() => _MessageListItemState();
}

class _MessageListItemState extends State<MessageListItem> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.extension<AppTextColors>();

    return SynqContainer(
      onPressed: () => widget.onPressed(),
      padding: const EdgeInsets.all(8.0),
      child: Column(
        spacing: 10,
        children: [
          Visibility(
            visible: widget.showTime,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                spacing: 20,
                children: [
                  Expanded(child: Divider()),
                  Text(
                    "${widget.message.sendAt!.toLocal().day}/${widget.message.sendAt!.toLocal().month}/${widget.message.sendAt!.toLocal().year}",
                  ),
                  Expanded(child: Divider()),
                ],
              ),
            ),
          ),

          SwipeToReply(
            onPressed: () => widget.onPressed(),
            onReply: () => context.read<MessageBoxCubit>().addReply(
              widget.message.id,
              widget.message.content,
            ),
            child: Column(
              spacing: 10,
              children: [
                widget.message.reply != null
                    ? GestureDetector(
                        onTap: () => widget.onReplyClicked!(
                          widget.message.replyMessageId!,
                          widget.message.reply!.serverTime,
                        ),
                        child: Padding(
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
                                  widget.message.reply!.content,
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
                        ),
                      )
                    : SizedBox(),
                Row(
                  spacing: 10,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProfileImage(
                      height: 40,
                      width: 40,
                      letter: widget
                          .message
                          .sender!
                          .profile!
                          .name!
                          .characters
                          .first
                          .toUpperCase(),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            spacing: 5,
                            children: [
                              Text(
                                widget.message.sender!.profile!.name!,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: widget.index % 2 == 0
                                      ? Colors.blue
                                      : Colors.orange,
                                ),
                              ),
                              // Icon(Icons.verified, size: 15, color: Colors.amber),
                              Text(
                                "at ${widget.message.sendAt!.toLocal().hour}:${widget.message.sendAt!.toLocal().minute} ${widget.message.sendAt!.toLocal().hour < 12 ? 'AM' : 'PM'}",
                                style: TextStyle(
                                  fontSize: 10,
                                  color: textTheme?.secondaryTextColor,
                                ),
                              ),
                              Visibility(
                                visible: widget.message.isEdited!,
                                child: Icon(
                                  Icons.edit,
                                  size: 10,
                                  color: textTheme?.secondaryTextColor,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            widget.message.content,
                            style: TextStyle(fontSize: 16),
                          ),
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
