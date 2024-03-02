import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socket_flutter_app/bloc/chat/chat_bloc.dart';
import 'package:socket_flutter_app/common/decoration.dart';
import 'package:socket_flutter_app/model/chat_model.dart';
import 'package:socket_flutter_app/model/user_model.dart';
import 'package:socket_flutter_app/ui/widget/message_bubble.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late ChatModel chat;
  late UserModel sender;
  late UserModel recipient;
  final TextEditingController _messageController = TextEditingController();
  Timer? timer;

  Widget _buildAppBar() {
    return Container(
      color: kWhite,
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: MediaQuery.of(context).padding.top,
          bottom: 20,
        ),
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                context.read<ChatBloc>().add(OnChatClosed());
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios),
            ),
            Image.asset(
              "assets/${recipient.avatarNumber}.png",
              height: 50,
              width: 50,
            ),
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
                  "Online",
                  style: kBold12.copyWith(color: recipient.isConnected ? kGrey : kWhite),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(BuildContext context) {
    return Container(
      color: kWhite,
      child: Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: MediaQuery.of(context).padding.top),
        child: Container(
          constraints: const BoxConstraints(maxHeight: 100),
          child: TextField(
            controller: _messageController,
            maxLines: null,
            onChanged: (_) {
              /// Re build page to display the tap button to send message.
              setState(() {});

              /// Notify server that sender is writing.
              /// If already set, we restart the timer.
              if (timer != null) {
                timer!.cancel();
                timer = Timer.periodic(const Duration(seconds: 2), (_) {
                  context.read<ChatBloc>().add(OnTyping(chat: chat, isTyping: false));
                  timer!.cancel();
                  timer = null;
                });
              } else {
                /// Otherwise we notify the server that the sender is writing.
                context.read<ChatBloc>().add(OnTyping(chat: chat, isTyping: true));
                timer = Timer.periodic(const Duration(seconds: 2), (_) {
                  context.read<ChatBloc>().add(OnTyping(chat: chat, isTyping: false));
                  timer!.cancel();
                  timer = null;
                });
              }
            },
            decoration: kTfDecoration.copyWith(
              hintText: "Type a message...",
              suffixIcon: _messageController.text.isEmpty
                  ? null
                  : IconButton(
                      onPressed: () {
                        context.read<ChatBloc>().add(
                              OnCreateMessage(
                                text: _messageController.text,
                                chat: chat,
                              ),
                            );
                        _messageController.clear();
                      },
                      icon: const Icon(CupertinoIcons.arrow_up),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    ChatBloc bloc = context.read<ChatBloc>();
    chat = bloc.chat;
    sender = bloc.sender;
    recipient = bloc.recipient;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLightGrey,
      body: BlocConsumer<ChatBloc, ChatState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Column(
            children: [
              _buildAppBar(),
              Expanded(
                child: Builder(
                  builder: (_) {
                    List<Widget> messageBubbles = [];
                    for (int i = chat.messages.length - 1; i >= 0; i--) {
                      messageBubbles.add(
                        MessageBubble(
                          sender: sender,
                          message: chat.messages[i],
                          previousMessage: i - 1 >= 0 ? chat.messages[i - 1] : null,
                          nextMessage: i + 1 < chat.messages.length ? chat.messages[i + 1] : null,
                        ),
                      );
                    }
                    return ListView(
                      reverse: true,
                      padding: EdgeInsets.zero,
                      children: messageBubbles,
                    );
                  },
                ),
              ),
              if (recipient.isTyping)
                Padding(
                  padding: const EdgeInsets.only(bottom: 5, left: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "${recipient.username} is typing ...",
                      style: kBold12.copyWith(color: kGrey),
                    ),
                  ),
                ),
              _buildTextField(context),
            ],
          );
        },
      ),
    );
  }
}
