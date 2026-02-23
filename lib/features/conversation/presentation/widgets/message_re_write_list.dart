import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:synq/config/theme/app_text_colors.dart';
import 'package:synq/features/conversation/data/models/message_model.dart';
import 'package:synq/features/conversation/presentation/bloc/message-re-write/message_re_write_bloc.dart';
import 'package:synq/features/conversation/presentation/bloc/message-re-write/message_re_write_event.dart';
import 'package:synq/features/conversation/presentation/bloc/message-re-write/message_re_write_state.dart';
import 'package:synq/features/conversation/presentation/bloc/message/message_box_cubit.dart';
import 'package:synq/features/conversation/presentation/widgets/message_list_item.dart';

class MessageReWriteList extends StatefulWidget {
  final ItemScrollController scrollController;
  final ItemPositionsListener itemPositionsListener;
  final Function(MessageModel messsage) onItemPressed;
  const MessageReWriteList({
    super.key,
    required this.scrollController,
    required this.onItemPressed,
    required this.itemPositionsListener,
  });

  @override
  State<MessageReWriteList> createState() => _MessageReWriteListState();
}

class _MessageReWriteListState extends State<MessageReWriteList> {
  final List<MessageModel> _messages = [];
  final Set<String> _ids = {};
  bool _isLoading = false;
  String? scrollToMessageId;

  int _lastMinIndex = 0;

  @override
  void initState() {
    widget.itemPositionsListener.itemPositions.addListener(_onScroll);
    super.initState();
  }

  void _onScroll() {
    final positions = widget.itemPositionsListener.itemPositions.value;
    if (positions.isEmpty) return;

    final firstVisible = positions
        .where((p) => p.itemLeadingEdge < 1)
        .reduce((min, p) => p.index < min.index ? p : min);

    final lastVisible = positions
        .where((p) => p.itemTrailingEdge > 0)
        .reduce((max, p) => p.index > max.index ? p : max);

    final isScrollingDown = firstVisible.index < _lastMinIndex;
    final isScrollingUp = firstVisible.index > _lastMinIndex;
    _lastMinIndex = firstVisible.index;

    if (isScrollingDown) {
      _handleScrollDown(firstVisible.index);
    } else if (isScrollingUp) {
      _handleScrollUp(lastVisible.index);
    }
  }

  void _handleScrollDown(int firstVisibleIndex) {
    if (firstVisibleIndex <= 3 && !_isLoading) {
      print("Time to load new messages");
      context.read<MessageReWriteBloc>().add(LoadNewerMessages());
    }
  }

  void _handleScrollUp(int lastVisibleIndex) {
    if (lastVisibleIndex >= _messages.length - 4 && !_isLoading) {
      print("Time to load older messages");
      context.read<MessageReWriteBloc>().add(LoadOlderMessages());
    }
  }

  void addInitialMessages(List<MessageModel> messages) {
    _messages.clear();
    _ids.clear();
    messages.forEach((item) => _ids.add(item.id));
    _messages.addAll(messages);
  }

  void addOlderMessages(List<MessageModel> messages) {
    _isLoading = false;
    for (final msg in messages) {
      insertMessage(msg);
    }
  }

  void addNewMessages(List<MessageModel> messages) {
    _isLoading = false;
    for (final msg in messages) {
      insertMessage(msg);
    }
  }

  void insertMessage(MessageModel message) {
    if (_ids.contains(message.id)) return;

    _ids.add(message.id);

    int index = _messages.indexWhere(
      (item) => item.sendAt!.isBefore(message.sendAt!),
    );

    if (index == -1) {
      _messages.add(message);
    } else {
      _messages.insert(index, message);
    }
  }

  void whatTheFuck(List<MessageModel> fucks) {
    _ids.clear();
    _messages.clear();
    _messages.addAll(fucks);
    // if (scrollToMessageId != null) {
    //   int index = _messages.indexWhere((m) => m.id == scrollToMessageId);

    //   if (index != -1) {
    //     widget.scrollController.scrollTo(
    //       index: index,
    //       duration: Duration(milliseconds: 1000),
    //     );
    //   }
    // }
  }

  void updateMessage(String id, MessageModel message) {
    int index = _messages.indexWhere((m) => m.id == id);
    _messages[index] = message;
  }

  void removeMessage(String id) {
    _ids.remove(id);
    int index = _messages.indexWhere((m) => m.id == id);
    _messages.removeAt(index);
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
    final theme = Theme.of(context);
    final textTheme = theme.extension<AppTextColors>();
    return BlocListener<MessageReWriteBloc, MessageReWriteState>(
      listenWhen: (previous, current) =>
          current is MessageLoaded ||
          current is OldMessagesLoaded ||
          current is MessagesAroundMessageLoaded ||
          current is NewerMessagesLoaded ||
          current is MessageRecieved ||
          current is MessageUpdated ||
          current is MessageRemoved,
      listener: (context, state) => switch (state) {
        MessageLoaded() => addInitialMessages(state.messages),
        OldMessagesLoaded() => addOlderMessages(state.messages),
        MessagesAroundMessageLoaded() => whatTheFuck(
          state.messages.reversed.toList(),
        ),
        NewerMessagesLoaded() => addNewMessages(state.messages),
        MessageRecieved() => _messages.insert(0, state.message),
        MessageUpdated() => updateMessage(state.id, state.message),
        MessageRemoved() => removeMessage(state.id),
        MessageReWriteState() => throw UnimplementedError(),
      },
      child: BlocBuilder<MessageReWriteBloc, MessageReWriteState>(
        buildWhen: (previous, current) =>
            current is MessageLoading ||
            current is MessageLoaded ||
            current is OldMessagesLoaded ||
            current is MessagesAroundMessageLoaded ||
            current is NewerMessagesLoaded ||
            current is MessageRecieved ||
            current is MessageUpdated ||
            current is MessageRemoved ||
            current is MessageError,
        builder: (context, state) {
          if (state is MessageLoading) {
            return _buildLoading(textTheme);
          }
          if (state is MessageLoaded ||
              state is OldMessagesLoaded ||
              state is MessagesAroundMessageLoaded ||
              state is NewerMessagesLoaded ||
              state is MessageRecieved ||
              state is MessageUpdated ||
              state is MessageRemoved) {
            return _buildList();
          }
          if (state is MessageError) {
            return _buildError(state.error);
          }

          return SizedBox();
        },
      ),
    );
  }

  Widget _buildList() {
    return ScrollablePositionedList.builder(
      itemCount: _messages.length,
      reverse: true,
      itemScrollController: widget.scrollController,
      itemPositionsListener: widget.itemPositionsListener,
      itemBuilder: (context, index) {
        final message = _messages[index];
        return MessageListItem(
          key: ValueKey(message.id),
          onPressed: () => {widget.onItemPressed(_messages[index])},
          onReplyClicked: (id, sentAt) {
            int index = _messages.indexWhere((m) => m.id == id);
            if (index == -1) {
              scrollToMessageId = id;
              context.read<MessageReWriteBloc>().add(
                LoadMessagesAroundMessage(messageId: id, sentAt: sentAt),
              );
              return;
            }
            widget.scrollController.scrollTo(
              index: index,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
          message: _messages[index],
          onDrag: (_) async {
            context.read<MessageBoxCubit>().addReply(
              message.id,
              message.content,
            );
            return false;
          },
          index: index,
          showTime: showTimeHeader(_messages, index),
        );
      },
    );
  }

  Widget _buildLoading(AppTextColors? textTheme) {
    return Center(
      child: CircularProgressIndicator(color: textTheme?.primaryTextColor),
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Text(message, style: TextStyle(fontSize: 17, color: Colors.red)),
      ),
    );
  }
}
