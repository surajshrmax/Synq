import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synq/config/theme/app_text_colors.dart';
import 'package:synq/core/widgets/synq_animated_container.dart';
import 'package:synq/core/widgets/synq_container.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:synq/features/conversation/presentation/bloc/message/message_box_cubit.dart';
import 'package:synq/features/conversation/presentation/bloc/message/message_box_cubit_state.dart';

class MessageBox extends StatefulWidget {
  final VoidCallback onSendButtonPressed;
  final VoidCallback onPickButtonPressed;
  final TextEditingController messageBoxController;
  final FocusNode messageFocusNode;

  const MessageBox({
    super.key,
    required this.onSendButtonPressed,
    required this.onPickButtonPressed,
    required this.messageBoxController,
    required this.messageFocusNode,
  });

  @override
  State<MessageBox> createState() => _MessageBoxState();
}

class _MessageBoxState extends State<MessageBox> {
  bool isTextBoxEmpty = true;
  bool isEditingMessage = false;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.extension<AppTextColors>();
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    void updateState(bool value) {
      if (value == isTextBoxEmpty) return;
      setState(() {
        isTextBoxEmpty = value;
      });
      widget.messageFocusNode.requestFocus();
    }

    return BlocListener<MessageBoxCubit, MessageBoxCubitState>(
      listener: (context, state) {
        if (state.isEditing) {
          widget.messageBoxController.text = state.content;
          updateState(!state.isEditing);
        } else if (state.isReplying) {
          updateState(!state.isReplying);
        } else {
          widget.messageBoxController.text = "";
        }
      },
      child: SynqContainer(
        margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
        border: true,
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
        borderRadius: BorderRadius.circular(40),
        boxConstraints: BoxConstraints(
          maxHeight: mediaQuery.size.height * 0.40,
        ),
        child: AnimatedSize(
          duration: Duration(milliseconds: 200),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 0,
            children: [
              BlocBuilder<MessageBoxCubit, MessageBoxCubitState>(
                builder: (context, state) {
                  return state.isEditing || state.isReplying
                      ? SynqContainer(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          margin: EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 10,
                          ),
                          child: Row(
                            spacing: 10,
                            children: [
                              Icon(
                                state.isEditing ? Icons.edit : Icons.reply,
                                color: textTheme?.secondaryTextColor,
                                size: 14,
                              ),
                              Expanded(
                                child: Text(
                                  maxLines: 1,
                                  state.isEditing
                                      ? "Edit Message"
                                      : state.content,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: textTheme?.secondaryTextColor,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),

                              GestureDetector(
                                onTap: () =>
                                    context.read<MessageBoxCubit>().clear(),
                                child: Icon(Icons.remove),
                              ),
                            ],
                          ),
                        )
                      : SizedBox();
                },
              ),

              Row(
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
                      focusNode: widget.messageFocusNode,
                      minLines: null,
                      maxLines: null,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Type Message Here...',
                      ),
                      keyboardType: TextInputType.multiline,
                      textCapitalization: TextCapitalization.sentences,
                      controller: widget.messageBoxController,
                      onChanged: (value) =>
                          widget.messageBoxController.text.isNotEmpty
                          ? updateState(false)
                          : updateState(true),
                    ),
                  ),
                  AnimatedSize(
                    duration: Duration(milliseconds: 200),
                    child: SizedBox(
                      height: 40.h,
                      width: 40.h,
                      child: isTextBoxEmpty
                          ? SizedBox.shrink()
                          : SynqAnimatedContainer(
                              onPressed: () {
                                setState(() {
                                  isTextBoxEmpty = true;
                                });
                                widget.onSendButtonPressed();
                              },
                              backgroundColor: Colors.lightGreenAccent,
                              shadowOffSet: Offset.zero,
                              borderRadius: BorderRadius.circular(40),
                              child:
                                  BlocBuilder<
                                    MessageBoxCubit,
                                    MessageBoxCubitState
                                  >(
                                    builder: (context, state) {
                                      return Icon(
                                        state.isEditing
                                            ? Icons.done
                                            : Icons.keyboard_arrow_up,
                                        color: Colors.black,
                                      );
                                    },
                                  ),
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
