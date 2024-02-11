import 'package:flutter/material.dart';
import 'package:socket_flutter_app/common/decoration.dart';
import 'package:socket_flutter_app/common/extensions/time.dart';
import 'package:socket_flutter_app/model/message_model.dart';
import 'package:socket_flutter_app/model/user_model.dart';

class MessageBubble extends StatelessWidget {
  final UserModel sender;
  final MessageModel message;
  final MessageModel? previousMessage;
  final MessageModel? nextMessage;

  const MessageBubble({
    super.key,
    required this.sender,
    required this.message,
    this.previousMessage,
    this.nextMessage,
  });

  @override
  Widget build(BuildContext context) {
    late bool displayTime;
    // Is older than one minute ?
    if (DateTime.now().toLocal().difference(message.createdAt.toLocal()).inMinutes > 1) {
      // Does the next message was sent in the same minute ?
      if (nextMessage != null &&
          nextMessage!.createdAt.toLocal().difference(message.createdAt.toLocal()).inMinutes < 1) {
        displayTime = false;
      } else {
        displayTime = true;
      }
    } else {
      displayTime = false;
    }

    late BorderRadius borderRadius;
    late Alignment alignment;
    late Color color;

    /// Is sender message
    if (message.userId == sender.id) {
      alignment = Alignment.centerRight;
      color = message.status == MessageStatus.failed ? Colors.red : kSecondary;
      borderRadius = BorderRadius.only(
        topLeft: const Radius.circular(20),
        bottomLeft: const Radius.circular(20),
        topRight: previousMessage != null &&
                previousMessage!.userId == message.userId &&
                message.createdAt.toLocal().difference(previousMessage!.createdAt.toLocal()).inMinutes < 1
            ? Radius.zero
            : const Radius.circular(20),
        bottomRight: nextMessage != null && nextMessage!.userId == message.userId && !displayTime
            ? Radius.zero
            : const Radius.circular(20),
      );
    } else {
      alignment = Alignment.centerLeft;
      color = message.status == MessageStatus.failed ? Colors.red : kWhite;
      borderRadius = BorderRadius.only(
        topRight: const Radius.circular(20),
        bottomRight: const Radius.circular(20),
        topLeft: previousMessage != null &&
                previousMessage!.userId == message.userId &&
                message.createdAt.toLocal().difference(previousMessage!.createdAt.toLocal()).inMinutes < 1
            ? Radius.zero
            : const Radius.circular(20),
        bottomLeft: nextMessage != null && nextMessage!.userId == message.userId && !displayTime
            ? Radius.zero
            : const Radius.circular(20),
      );
    }

    return Padding(
      padding: EdgeInsets.only(bottom: nextMessage == null ? 10 : 0),
      child: Column(
        children: [
          Align(
            alignment: alignment,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 2,
                horizontal: 20,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: borderRadius,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 10,
                  ),
                  child: Text(
                    message.text,
                    style: kRegular14,
                  ),
                ),
              ),
            ),
          ),
          if (displayTime)
            Text(
              DateTime.now().difference(message.createdAt).inHours > 24
                  ? message.createdAt.getWTime()
                  : message.createdAt.getTime(),
              style: kRegular10.copyWith(
                color: kGrey,
              ),
            ),
        ],
      ),
    );
  }
}
