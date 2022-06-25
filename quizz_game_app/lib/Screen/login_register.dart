import 'package:flutter/material.dart';
import 'package:quizz_game_app/Bloc/Auth_bloc/auth_bloc_bloc.dart';
import 'package:quizz_game_app/Repo/Database/database_helper.dart';
import 'package:quizz_game_app/util/color.dart';
import 'package:quizz_game_app/util/db_table.dart';
import 'package:quizz_game_app/util/pages.dart';
import 'package:quizz_game_app/util/style.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginRegister extends StatefulWidget {
  const LoginRegister({Key? key}) : super(key: key);

  @override
  State<LoginRegister> createState() => _LoginRegisterState();
}

class _LoginRegisterState extends State<LoginRegister> {
  final String url = "images/Auth.png";
  @override
  Widget build(BuildContext context) {
    AuthBlocBloc _auth = context.read<AuthBlocBloc>();
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration:
              BoxDecoration(image: DecorationImage(image: AssetImage(url))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("Welcome To Quizz Game ",style: title.copyWith(color: appbarColor),),
              Container(
                margin: const EdgeInsets.only(top: 300),
                child: Column(
                  children: [
                    SizedBox(
                      width: 200,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).pushNamed(AuthLoginScreen);
                        },
                        icon: const Icon(Icons.login),
                        label: const Text("Login"),
                        style: buttonStyle,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: 200,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          //todo
                          Navigator.of(context).pushNamed(AuthRegisterScreen);
                        },
                        icon: const Icon(Icons.fact_check),
                        label: const Text("Register"),
                        style: buttonStyle,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
