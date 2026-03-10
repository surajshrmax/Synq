import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:synq/config/theme/app_text_colors.dart';
import 'package:synq/core/widgets/synq_container.dart';

class SwipeToReply extends StatefulWidget {
  final Widget child;
  final VoidCallback onReply;
  final VoidCallback onPressed;
  const SwipeToReply({
    super.key,
    required this.child,
    required this.onReply,
    required this.onPressed,
  });

  @override
  State<SwipeToReply> createState() => _SwipeToReplyState();
}

class _SwipeToReplyState extends State<SwipeToReply>
    with SingleTickerProviderStateMixin {
  double offsetX = 0;

  late AnimationController controller;
  late Animation<double> animation;

  final double triggerOffset = 80;
  bool replyTriggerred = false;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    animation = Tween<double>(begin: 0, end: 0).animate(controller)
      ..addListener(() {
        setState(() {
          offsetX = animation.value;
        });
      });
  }

  void resetPosition() {
    animation = Tween<double>(begin: offsetX, end: 0).animate(controller);
    controller.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.extension<AppTextColors>();
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        offsetX += details.delta.dx;

        offsetX = offsetX.clamp(0, 100);

        if (offsetX > triggerOffset && !replyTriggerred) {
          HapticFeedback.lightImpact();
          replyTriggerred = true;
          widget.onReply();
        }

        setState(() {});
      },

      onHorizontalDragEnd: (_) {
        replyTriggerred = false;
        resetPosition();
      },

      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Transform.translate(
            offset: Offset((offsetX / 2) * 0.55, 0),
            child: Transform.scale(
              scale: offsetX / 100 * 1,
              child: HugeIcon(
                icon: HugeIcons.strokeRoundedArrowMoveUpRight,
                strokeWidth: 2,
                color: textTheme?.secondaryTextColor,
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(offsetX, 0),
            child: SynqContainer(
              onPressed: () => widget.onPressed(),
              backgroundColor: offsetX > 0
                  ? theme.cardColor
                  : Colors.transparent,
              child: widget.child,
            ),
          ),
        ],
      ),
    );
  }
}
