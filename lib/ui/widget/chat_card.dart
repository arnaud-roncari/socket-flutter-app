import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socket_flutter_app/bloc/chat/chat_bloc.dart';
import 'package:socket_flutter_app/bloc/home/home_bloc.dart';
import 'package:socket_flutter_app/common/decoration.dart';
import 'package:socket_flutter_app/common/extensions/time.dart';
import 'package:socket_flutter_app/model/chat_model.dart';
import 'package:socket_flutter_app/model/user_model.dart';

class ChatCard extends StatefulWidget {
  final ChatModel chat;
  const ChatCard({super.key, required this.chat});

  @override
  State<ChatCard> createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {
  late UserModel sender;
  late UserModel recipient;

  @override
  void initState() {
    super.initState();
    UserModel sender = context.read<HomeBloc>().user;
    for (UserModel user in widget.chat.users) {
      if (user.id == sender.id) {
        this.sender = user;
      } else {
        recipient = user;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 70,
      child: Material(
        color: kLightGrey,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          onTap: () {
            context.read<ChatBloc>().add(
                  OnChatOpened(
                    recipient: recipient,
                    sender: sender,
                    chat: widget.chat,
                  ),
                );
            Navigator.pushNamed(context, "/chat");
          },
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Image.asset("assets/${recipient.avatarNumber}.png"),
                const SizedBox(width: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipient.username,
                      style: kBold14,
                    ),
                    Text(
                      widget.chat.messages.isEmpty ? "" : widget.chat.messages.first.text,
                      style: kRegular12.copyWith(color: kGrey),
                    ),
                  ],
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.chat.messages.isEmpty
                          ? ""
                          : DateTime.now().difference(widget.chat.messages.first.createdAt).inHours > 24
                              ? widget.chat.messages.first.createdAt.getWeekday()
                              : widget.chat.messages.first.createdAt.getTime(),
                      style: kRegular12.copyWith(color: kGrey),
                    ),
                    // Upgrade : Implement notification with socket (unread message)
                    const Text(
                      "",
                      style: kRegular12,
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
