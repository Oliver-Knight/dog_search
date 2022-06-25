import 'package:flutter/material.dart';
import 'package:quizz_game_app/Bloc/Auth_bloc/auth_bloc_bloc.dart';
import 'package:quizz_game_app/Repo/Database/database_helper.dart';
import 'package:quizz_game_app/util/color.dart';
import 'package:quizz_game_app/util/db_table.dart';
import 'package:quizz_game_app/util/style.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QuizAlertDialog extends StatefulWidget {
  final String title;
  final String content;
  final IconData icon;
  final bool logout;
  void Function()? onpress;
  QuizAlertDialog(
      {Key? key,
      this.onpress,
      required this.title,
      required this.content,
      this.icon = Icons.priority_high,
      this.logout = false})
      : super(key: key);

  @override
  State<QuizAlertDialog> createState() => _QuizAlertDialogState();
}

class _QuizAlertDialogState extends State<QuizAlertDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      elevation: 20,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 70),
            height: widget.content.length > 50 ? 300 : 250,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                color: appbarColor),
            child: Column(
              children: [
                Text(
                  widget.title,
                  style: alertTitleStyle,
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    widget.content,
                    style: alertContentStyle,
                  ),
                ),
                SizedBox(
                  height: widget.content.length > 50 ?  35 : 20,
                ),
                Container(
                  width: double.infinity,
                  height: 1,
                  color: Colors.grey,
                ),
                SizedBox(
                  height: widget.content.length > 50 ?  30 : 20,
                ),
                ElevatedButton(
                    style: alertButtonStyle,
                    onPressed: widget.logout
                        ? () {
                            context.read<AuthBlocBloc>().add(LogoutEvent());
                          }
                        :widget.onpress ?? (){context.read<AuthBlocBloc>().add(AuthInitialEvent()); Navigator.pop(context);},
                    child: widget.logout == false
                        ? const Text("Ok")
                        : const Text("Sure"))
              ],
            ),
          ),
          Positioned(
            top: -60,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(width: 8,color: appbarColor),
                shape: BoxShape.circle
              ),
              child: CircleAvatar(
                radius: 60,
                backgroundColor: buttonColor,
                child: Icon(
                  widget.icon,
                  size: 60,
                  color: const Color(0XFFFFFFFF),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
