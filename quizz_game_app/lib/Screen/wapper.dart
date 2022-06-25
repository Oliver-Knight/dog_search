import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:quizz_game_app/Bloc/Auth_bloc/auth_bloc_bloc.dart';
import 'package:quizz_game_app/Modal/user/user_modal.dart';
import 'package:quizz_game_app/Repo/Database/database_helper.dart';
import 'package:quizz_game_app/util/color.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizz_game_app/util/pages.dart';

class Wapper extends StatefulWidget {
  const Wapper({Key? key}) : super(key: key);

  @override
  State<Wapper> createState() => _WapperState();
}

class _WapperState extends State<Wapper> {
  late final AuthBlocBloc _state = context.read<AuthBlocBloc>();
  @override
  void initState() {
    super.initState();
    _state.add(AuthInitialEvent());
    _loading();
  }
  void _loading(){
    Future.delayed(const Duration(seconds: 2),() async {
     if (_state.state is AuthLogoutState) {
        //logout user
        Navigator.of(context).pushNamedAndRemoveUntil(LoginScreen, (_) => false);
      } else if (_state.state is AuthSuccessState) {
        //login user
        Navigator.of(context).pushNamedAndRemoveUntil(HomeScreen, (_) => false);
      }
      else{
        _loading();
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
            body: Container(
              color: appbarColor,
              child: Center(
                child: Lottie.asset('asset/wapper_quiz.json'),
                // child: CircularProgressIndicator(),
              ),
            ),
          );
  }
}
