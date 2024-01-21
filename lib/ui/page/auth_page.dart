import 'package:flutter/material.dart';
import 'package:socket_flutter_app/common/decoration.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Spacer(),
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: kPrimary,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50),
                topRight: Radius.circular(50),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 60),
                  const Text(
                    "Bienvenue",
                    style: kBold40,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Discutez avec vos amis !",
                    style: kRegular20,
                  ),
                  const SizedBox(height: 40),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 60,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: kBlack),
                            onPressed: () {
                              Navigator.pushNamed(context, "/login");
                            },
                            child: Text(
                              "Connexion",
                              style: kBold18.copyWith(color: kWhite),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: SizedBox(
                          height: 60,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, "/signup");
                            },
                            child: Text(
                              "Inscription",
                              style: kBold18.copyWith(color: kBlack),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(height: MediaQuery.of(context).padding.bottom),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
