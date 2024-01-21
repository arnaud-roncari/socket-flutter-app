import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socket_flutter_app/bloc/chat/chat_bloc.dart';
import 'package:socket_flutter_app/common/decoration.dart';
import 'package:socket_flutter_app/common/extensions/time.dart';
import 'package:socket_flutter_app/model/chat_model.dart';
import 'package:socket_flutter_app/model/message_model.dart';
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

                /// Upgrade Implement socket
                Text(
                  "En ligne",
                  style: kBold12.copyWith(color: kGrey),
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
            maxLines: null,
            decoration: kTfDecoration.copyWith(hintText: "Écrivez un message..."),
            onSubmitted: (String message) {
              // Envoyer un message en DB
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ChatBloc bloc = context.read<ChatBloc>();
    chat = bloc.chat;
    sender = bloc.sender;
    recipient = bloc.recipient;
    return Scaffold(
      backgroundColor: kLightGrey,
      body: Column(
        children: [
          _buildAppBar(),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: chat.messages.length,
              itemBuilder: (_, int index) {
                MessageModel message = chat.messages.elementAt(index);
                bool isSender = message.userId == sender.id;

                bool isPreviousMessage = false;
                bool isNextMessage = false;

                /// We want to disable the curve effect only with messages from same author.
                /// Same behavior as Messenger.
                /// So we first check if the previous message is from the same author.
                /// Then, same for the next.
                /// The booleans will be used to define the curve. if it's 0 or not.
                if (index > 0 && chat.messages[index - 1].userId == message.userId) {
                  isPreviousMessage = true;
                }
                if (index + 1 < chat.messages.length && chat.messages[index + 1].userId == message.userId) {
                  isNextMessage = true;
                }

                /// Only display if next message is older than one minute, or if this is the last message.
                bool isTimeDisplayed = (index + 1 < chat.messages.length &&
                        chat.messages[index + 1].createdAt.difference(message.createdAt).inMinutes > 1) ||
                    index == chat.messages.length - 1;

                /// The day is only displayed if message is older than 24 hours.
                String displayedTime = DateTime.now().difference(message.createdAt).inHours > 24
                    ? message.createdAt.getWTime()
                    : message.createdAt.getTime();
                return Column(
                  children: [
                    Padding(
                      padding: index == 0 ? const EdgeInsets.only(top: 10) : EdgeInsets.zero,
                      child: MessageBubble(
                        isSender: isSender,
                        message: message,
                        isPreviousMessage: isPreviousMessage,
                        isNextMessage: isNextMessage,
                      ),
                    ),
                    if (isTimeDisplayed)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Text(displayedTime, style: kRegular10.copyWith(color: kGrey)),
                      )
                  ],
                );
              },
            ),
          ),
          _buildTextField(context),
        ],
      ),
    );
  }
}
