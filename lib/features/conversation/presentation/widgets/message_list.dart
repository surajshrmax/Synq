import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synq/features/conversation/data/models/message_model.dart';
import 'package:synq/features/conversation/presentation/bloc/message/message_bloc.dart';
import 'package:synq/features/conversation/presentation/bloc/message/message_state.dart';
import 'package:synq/features/conversation/presentation/widgets/message_list_item.dart';

class MessageList extends StatefulWidget {
  final Function(String id, String content) onPressed;
  const MessageList({super.key, required this.onPressed});

  @override
  State<MessageList> createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  final List<MessageModel> _messages = [];

  late OverlayEntry overlayEntry;

  void applyDiff(List<MessageModel> newMessages) {
    final existingIds = _messages.map((e) => e.id).toSet();

    final newIds = newMessages.map((m) => m.id).toSet();

    final deletes = _messages.where((e) => !newIds.contains(e.id)).toList();

    for (final msg in deletes) {
      print("INSIDE APPLY_DIFF DELETING MESSAGE");
      int index = _messages.indexOf(msg);
      _messages.removeAt(index);
      _listKey.currentState!.removeItem(
        index,
        duration: Duration(milliseconds: 100),
        (context, animation) => _messageItem(animation, msg, index),
      );
    }

    final incoming = newMessages
        .where((m) => !existingIds.contains(m.id))
        .toList();

    for (int i = 0; i < incoming.length; i++) {
      _messages.insert(0, incoming[i]);
      _listKey.currentState!.insertItem(0);
    }
  }

  bool showTimeHeader(List<MessageModel> list, int index) {
    if (index == list.length - 1) return true;
    final current = list[index].sendAt.toLocal();
    final next = list[index + 1].sendAt.toLocal();

    return current.year != next.year ||
        current.month != next.month ||
        current.day != next.day;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MessageBloc, MessageState>(
      listenWhen: (previous, current) => current is MessageStateLoaded,
      listener: (context, state) =>
          applyDiff((state as MessageStateLoaded).messages.reversed.toList()),
      child: AnimatedList(
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
        name: message.sender.profile!.name,
        message: message.content,
        imageUrl: message.sender.profile!.imageUrl,
        time: message.sendAt,
        showTime: showTimeHeader(_messages, index),
      ),
    );
  }
}
