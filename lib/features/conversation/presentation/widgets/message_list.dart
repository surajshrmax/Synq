import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synq/features/conversation/data/models/message_model.dart';
import 'package:synq/features/conversation/presentation/bloc/message/message_bloc.dart';
import 'package:synq/features/conversation/presentation/bloc/message/message_box_cubit.dart';
import 'package:synq/features/conversation/presentation/bloc/message/message_event.dart';
import 'package:synq/features/conversation/presentation/bloc/message/message_state.dart';
import 'package:synq/features/conversation/presentation/widgets/message_list_item.dart';

class MessageList extends StatefulWidget {
  final Function(String id, String content) onPressed;
  final ScrollController scrollController;
  const MessageList({
    super.key,
    required this.onPressed,
    required this.scrollController,
  });

  @override
  State<MessageList> createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  final List<MessageModel> _messages = [];

  void addMultipleMessage(List<MessageModel> newMessages, String _cursor) {
    final existingIds = _messages.map((e) => e.id).toSet();

    final incoming = newMessages
        .where((m) => !existingIds.contains(m.id))
        .toList();

    for (int i = 0; i < incoming.length; i++) {
      _messages.insert(0, incoming[i]);
      _listKey.currentState!.insertItem(0);
    }
  }

  void onMoreItemsLoaded(List<MessageModel> messages) {
    for (int i = 0; i < messages.length; i++) {
      _messages.add(messages[i]);
      _listKey.currentState!.insertItem(_messages.indexOf(messages[i]));
    }
  }

  void addSingleMessage(MessageModel message) {
    print("INSIDE ADD NEW SINGLE MESSAGE");
    _messages.insert(0, message);
    _listKey.currentState!.insertItem(0);
  }

  void removeMessage(MessageModel message) {
    print("INSIDE REMOVE MESSAGE");
    int index = _messages.indexOf(message);
    _messages.removeAt(index);
    _listKey.currentState!.removeItem(
      index,
      duration: Duration(milliseconds: 100),
      (context, animation) => _messageItem(animation, message, index),
    );
  }

  void updateMessage(int index, MessageModel newMessage) {
    setState(() {
      _messages[index] = newMessage;
    });
  }

  bool showTimeHeader(List<MessageModel> list, int index) {
    if (index == list.length - 1) return true;
    final current = list[index].sendAt!.toLocal();
    final next = list[index + 1].sendAt!.toLocal();

    return current.year != next.year ||
        current.month != next.month ||
        current.day != next.day;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MessageBloc, MessageState>(
      listenWhen: (previous, current) =>
          current is MessageStateLoaded ||
          current is MessageStateMoreItemsLoaded ||
          current is MessageStateNewMessage ||
          current is MessageStateRemoved ||
          current is MessageStateUpdated,
      listener: (context, state) => switch (state) {
        MessageStateLoaded() => addMultipleMessage(
          state.messages.reversed.toList(),
          state.cursor,
        ),
        MessageStateMoreItemsLoaded() => onMoreItemsLoaded(state.messages),
        MessageStateNewMessage() => addSingleMessage(state.message),
        MessageStateRemoved() => removeMessage(state.message),
        MessageStateUpdated() => updateMessage(state.index, state.message),
        MessageState() => throw UnimplementedError(),
      },
      child: AnimatedList(
        controller: widget.scrollController,
        key: _listKey,
        reverse: true,
        initialItemCount: _messages.length,
        itemBuilder: (context, index, animation) {
          return _messageItem(animation, _messages[index], index);
        },
      ),
    );
  }

  Widget _messageItem(
    Animation<double> animation,
    MessageModel message,
    int index,
  ) {
    return SizeTransition(
      sizeFactor: animation,
      child: MessageListItem(
        onPressed: () => widget.onPressed(message.id, message.content),
        onDrag: (direction) async {
          context.read<MessageBoxCubit>().addReply(message.id, message.content);
          return false;
        },
        message: message,
        showTime: showTimeHeader(_messages, index),
        index: index,
      ),
    );
  }
}
