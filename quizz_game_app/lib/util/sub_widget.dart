import 'package:flutter/cupertino.dart';
import 'package:quizz_game_app/util/color.dart';

Widget divider({Color? color = appbarColor}) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
    color: color,
    height: 1,
    width: double.infinity,
  );
}
