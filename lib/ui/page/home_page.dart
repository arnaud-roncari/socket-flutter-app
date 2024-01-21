import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socket_flutter_app/bloc/home/home_bloc.dart';
import 'package:socket_flutter_app/common/decoration.dart';
import 'package:socket_flutter_app/common/exception.dart';
import 'package:socket_flutter_app/model/user_model.dart';
import 'package:socket_flutter_app/ui/widget/chat_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(OnUserFetched());
  }

  Widget _buildAppBar(UserModel user) {
    return SizedBox(
      height: 40,
      child: Row(
        children: [
          Image.asset(
            "assets/${user.avatarNumber}.png",
            height: 40,
            width: 40,
          ),
          const SizedBox(width: 10),
          const Text(
            "Mes conversations",
            style: kBold14,
          ),
          const Spacer(),
          SizedBox(
            height: 40,
            width: 40,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                backgroundColor: kPrimary,
                padding: EdgeInsets.zero,
              ),
              onPressed: () {
                Navigator.pushNamed(context, "/create-chat");
              },
              child: const Icon(
                CupertinoIcons.bubble_left_bubble_right,
                color: kWhite,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is HomeFailure) {
            showSnackBarError(context: context, exception: state.exception);
          }
        },
        builder: (context, state) {
          if (state is! HomeSuccess) {
            return const Center(
              child: CircularProgressIndicator(color: kPrimary),
            );
          }

          return Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top,
              left: 20,
              right: 20,
            ),
            child: Column(
              children: [
                _buildAppBar(state.user),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: state.chats.length,
                    itemBuilder: (_, index) {
                      // If last, should contain 10 padding + bottom safe area padding
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: ChatCard(chat: state.chats[index]),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
