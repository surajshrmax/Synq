import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:synq/config/theme/app_text_colors.dart';
import 'package:synq/features/message/data/models/message_model.dart';
import 'package:synq/features/message/presentation/bloc/fab/fab_cubit.dart';
import 'package:synq/features/message/presentation/bloc/message/message_bloc.dart';
import 'package:synq/features/message/presentation/bloc/message/message_event.dart';
import 'package:synq/features/message/presentation/bloc/message/message_state.dart';
import 'package:synq/features/message/presentation/bloc/message-box/message_box_cubit.dart';
import 'package:synq/features/message/presentation/widgets/message_list_item.dart';

class MessageList extends StatefulWidget {
  final AutoScrollController autoScrollController;
  final Function(MessageModel messsage) onItemPressed;
  const MessageList({
    super.key,
    required this.onItemPressed,
    required this.autoScrollController,
  });

  @override
  State<MessageList> createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  late AutoScrollController scrollController;
  final List<MessageModel> _messages = [];
  final Set<String> _ids = {};
  bool _isLoading = false;
  bool _hasMoreMessagesAfter = false;
  bool _hasMoreMessageBefore = false;
  String? scrollToMessageId;

  double _oldOffset = 0;
  double _oldMaxExtent = 0;

  @override
  void initState() {
    scrollController = widget.autoScrollController;
    scrollController.addListener(_onScroll);
    super.initState();
  }

  void _onScroll() {
    double maxScrollIntent = scrollController.position.maxScrollExtent;
    double minScrollIntent = scrollController.position.minScrollExtent;
    double currentPixel = scrollController.position.pixels;
    final scrollDir = scrollController.position.userScrollDirection;
    bool isScrollingForward = scrollDir == ScrollDirection.forward;

    if (!isScrollingForward && currentPixel > maxScrollIntent - 200) {
      _loadOldMessages();
    }

    if (isScrollingForward && currentPixel < minScrollIntent + 200) {
      _loadNewMessages();
    }
    
  }

  void _loadOldMessages() {
    if (!_isLoading && _hasMoreMessageBefore) {
      _isLoading = true;
      context.read<MessageBloc>().add(LoadOlderMessages());
    }
  }

  void _loadNewMessages() {
    if (!_isLoading && _hasMoreMessagesAfter) {
      _isLoading = true;
      context.read<MessageBloc>().add(LoadNewerMessages());
    }
  }

  void captureCurrentState() {
    _oldOffset = scrollController.offset;
    _oldMaxExtent = scrollController.position.maxScrollExtent;
  }

  void addOlderMessages(List<MessageModel> messages) {
    _isLoading = false;
    setState(() {
      _messages.addAll(messages);
    });
  }

  void addNewMessages(List<MessageModel> messages) {
    _isLoading = false;

    for (final msg in messages) {
      captureCurrentState();
      setState(() {
        insertMessage(msg);
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final newMax = scrollController.position.maxScrollExtent;
      final delta = newMax - _oldMaxExtent;
      scrollController.jumpTo(_oldOffset + delta);
    });
  }

  void addMessages(MessageLoaded state) {
    final type = state.type;
    final messages = state.messages;

    _hasMoreMessageBefore = state.hasMoreBefore;
    _hasMoreMessagesAfter = state.hasMoreAfter;

    if (type == LoadedMessagesType.initial ||
        type == LoadedMessagesType.around) {
      _messages.clear();
      _ids.clear();
      for (var item in messages) {
        _ids.add(item.id);
      }
      setState(() {
        if (type == LoadedMessagesType.around) {
          _messages.addAll(messages.reversed);

          if (scrollToMessageId != null) {
            int index = _messages.indexWhere((m) => m.id == scrollToMessageId!);
            if (index != -1) {
              scrollController.scrollToIndex(
                index,
                preferPosition: AutoScrollPosition.middle,
              );
            }
          }
        } else {
          _messages.addAll(messages);
        }
      });
    }

    if (type == LoadedMessagesType.old) {
      addOlderMessages(messages);
    }

    if (type == LoadedMessagesType.newer) {
      addNewMessages(messages);
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
    return BlocListener<MessageBloc, MessageState>(
      listenWhen: (previous, current) =>
          current is MessageLoaded ||
          current is MessageRecieved ||
          current is MessageUpdated ||
          current is MessageRemoved,
      listener: (context, state) {
        return switch (state) {
          MessageLoaded() => addMessages(state),
          MessageRecieved() => _messages.insert(0, state.message),
          MessageUpdated() => updateMessage(state.id, state.message),
          MessageRemoved() => removeMessage(state.id),
          MessageState() => throw UnimplementedError(),
        };
      },
      child: BlocBuilder<MessageBloc, MessageState>(
        buildWhen: (previous, current) =>
            current is MessageLoading ||
            current is MessageLoaded &&
                current.type == LoadedMessagesType.initial ||
            current is MessageRecieved ||
            current is MessageUpdated ||
            current is MessageRemoved ||
            current is MessageError,
        builder: (context, state) {
          if (state is MessageLoading) {
            return _buildLoading(textTheme);
          }
          if (state is MessageLoaded ||
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
    return ListView.builder(
      itemCount: _messages.length,
      reverse: true,
      controller: scrollController,
      itemBuilder: (context, index) {
        final message = _messages[index];
        return AutoScrollTag(
          key: ValueKey(message.id),
          controller: scrollController,
          index: index,
          child: MessageListItem(
            onPressed: () => {widget.onItemPressed(_messages[index])},
            onReplyClicked: (id, sentAt) {
              int index = _messages.indexWhere((m) => m.id == id);
              if (index == -1) {
                scrollToMessageId = id;
                context.read<MessageBloc>().add(
                  LoadMessagesAroundMessage(messageId: id, sentAt: sentAt),
                );
                return;
              }

              scrollController.scrollToIndex(
                index,
                preferPosition: AutoScrollPosition.middle,
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
          ),
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
