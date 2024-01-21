import 'package:flutter/material.dart';
import 'package:socket_flutter_app/common/decoration.dart';
import 'package:socket_flutter_app/model/message_model.dart';

// isAuthor (message de l'auteur)
// top incurved bool
// bottom incurved bool

class MessageBubble extends StatelessWidget {
  /// Is the message send by the author. -> trouver un meilleur mot clés (qui sera utilsier dans toutes lapp)
  final bool isSender;
  final MessageModel message;

  /// Determine bubble radius.
  /// Radius is applied only for messages from same sender.
  final bool isPreviousMessage;
  final bool isNextMessage;

  const MessageBubble({
    super.key,
    required this.isSender,
    required this.message,
    required this.isPreviousMessage,
    required this.isNextMessage,
  });

  @override
  Widget build(BuildContext context) {
    if (isSender) {
      return Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 20),
          child: Container(
            decoration: BoxDecoration(
              color: kSecondary,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(20),
                bottomLeft: const Radius.circular(20),
                topRight: isPreviousMessage ? Radius.zero : const Radius.circular(20),
                bottomRight: isNextMessage ? Radius.zero : const Radius.circular(20),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Text(
                message.text,
                style: kRegular14,
              ),
            ),
          ),
        ),
      );
    } else {
      return Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 20),
          child: Container(
            decoration: BoxDecoration(
              color: kWhite,
              borderRadius: BorderRadius.only(
                topRight: const Radius.circular(20),
                bottomRight: const Radius.circular(20),
                topLeft: isPreviousMessage ? Radius.zero : const Radius.circular(20),
                bottomLeft: isNextMessage ? Radius.zero : const Radius.circular(20),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Text(
                message.text,
                style: kRegular14,
              ),
            ),
          ),
        ),
      );
    }
  }
}
