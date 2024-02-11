import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socket_flutter_app/bloc/chat/chat_bloc.dart';
import 'package:socket_flutter_app/bloc/create_chat/create_chat_bloc.dart';
import 'package:socket_flutter_app/bloc/home/home_bloc.dart';
import 'package:socket_flutter_app/common/decoration.dart';
import 'package:socket_flutter_app/common/exception.dart';
import 'package:socket_flutter_app/model/user_model.dart';

class CreateChatPage extends StatefulWidget {
  const CreateChatPage({super.key});

  @override
  State<CreateChatPage> createState() => _CreateChatPageState();
}

class _CreateChatPageState extends State<CreateChatPage> {
  final TextEditingController _usernameController = TextEditingController();
  List<UserModel> filterdUsers = [];

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Create a chat", style: kBold40),
          SizedBox(height: 10),
          Text(
            "Add a friend with his username and start chatting!",
            style: kRegular20,
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    context.read<CreateChatBloc>().add(OnUsersFetched());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimary,
      body: BlocConsumer<CreateChatBloc, CreateChatState>(listener: (context, state) {
        if (state is CreateChatFailure) {
          showSnackBarError(context: context, exception: state.exception);
        }
        if (state is OnChatCreatedSuccess) {
          context
              .read<ChatBloc>()
              .add(OnChatOpened(recipient: state.recipient, sender: state.sender, chat: state.chat));
          Navigator.pushReplacementNamed(context, "/chat");
        }
      }, builder: (_, state) {
        return Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAppBar(),
              const SizedBox(height: 20),
              _buildTitle(),
              const SizedBox(height: 40),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: kWhite,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: state is CreateChatLoading
                        ? const Center(
                            child: CircularProgressIndicator(color: kPrimary),
                          )
                        : Column(
                            children: [
                              const SizedBox(height: 60),
                              TextField(
                                decoration: kTfDecoration.copyWith(hintText: 'Username'),
                                controller: _usernameController,
                                onChanged: (String username) {
                                  filterdUsers.clear();
                                  if (username == '') {
                                    setState(() {});
                                    return;
                                  }
                                  for (UserModel user in (state as CreateChatSuccess).users) {
                                    if (user.username.toLowerCase().startsWith(username.toLowerCase())) {
                                      filterdUsers.add(user);
                                    }
                                  }
                                  setState(() {});
                                },
                              ),
                              Expanded(
                                child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  itemCount: filterdUsers.length,
                                  itemBuilder: (BuildContext _, int index) {
                                    UserModel user = filterdUsers.elementAt(index);
                                    return Material(
                                      color: kWhite,
                                      child: SizedBox(
                                        height: 50,
                                        child: InkWell(
                                          onTap: () {
                                            UserModel sender = context.read<HomeBloc>().user;
                                            context
                                                .read<CreateChatBloc>()
                                                .add(OnCreateChat(recipient: user, sender: sender));
                                          },
                                          child: Row(
                                            children: [
                                              Image.asset(
                                                "assets/${user.avatarNumber}.png",
                                                height: 40,
                                                width: 40,
                                              ),
                                              const SizedBox(width: 10),
                                              Text(
                                                user.username,
                                                style: kRegular14,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}
