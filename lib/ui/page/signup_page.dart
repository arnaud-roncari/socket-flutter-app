import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socket_flutter_app/bloc/auth/auth_bloc.dart';
import 'package:socket_flutter_app/common/decoration.dart';
import 'package:socket_flutter_app/common/exception.dart';
import 'package:socket_flutter_app/common/validators.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
          TextButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, "/login");
            },
            child: Text("Login", style: kBold18.copyWith(color: kBlack)),
          ),
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
          Text("Signup", style: kBold40),
          SizedBox(height: 10),
          Text(
            "Create an account with a username and password.",
            style: kRegular20,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimary,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            showSnackBarError(context: context, exception: state.exception);
          }

          if (state is AuthSuccess) {
            Navigator.pushReplacementNamed(context, "/home");
          }
        },
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAppBar(),
                const Spacer(),
                _buildTitle(),
                const SizedBox(height: 40),
                Container(
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
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const SizedBox(height: 60),
                          TextFormField(
                            decoration: kTfDecoration.copyWith(hintText: 'Username'),
                            controller: _usernameController,
                            validator: Validator.username,
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            obscureText: true,
                            decoration: kTfDecoration.copyWith(hintText: 'Password'),
                            controller: _passwordController,
                            validator: Validator.password,
                          ),
                          const SizedBox(height: 40),
                          SizedBox(
                            height: 60,
                            width: double.infinity,
                            child: state is AuthLoading
                                ? const Center(
                                    child: CircularProgressIndicator(color: kPrimary),
                                  )
                                : ElevatedButton(
                                    style: ElevatedButton.styleFrom(backgroundColor: kBlack),
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        context.read<AuthBloc>().add(
                                              OnSignupButtonPressed(
                                                username: _usernameController.text.trim(),
                                                password: _passwordController.text.trim(),
                                              ),
                                            );
                                      }
                                    },
                                    child: Text(
                                      "Signup",
                                      style: kBold18.copyWith(color: kWhite),
                                    ),
                                  ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(height: MediaQuery.of(context).padding.bottom),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
