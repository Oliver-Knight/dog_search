import 'package:flutter/material.dart';
import 'package:quizz_game_app/util/color.dart';

const TextStyle quizTitleStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,
  color: backgroundColor,
);

const TextStyle quizdescriptionStyle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: Color(0XFFFFFFFF),
    overflow: TextOverflow.ellipsis);

const TextStyle quizUpdateDateStyle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: Color(0XFFE4E4E4),
    overflow: TextOverflow.ellipsis);

const TextStyle profileName = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w600,
  color: Color(0XFFE4E4E4),
);

const TextStyle scoreStyle = TextStyle(
  fontSize: 15,
  fontWeight: FontWeight.w400,
  color: Color(0XFFE4E4E4),
);

const TextStyle title = TextStyle(
  fontSize: 25,
  fontWeight: FontWeight.bold,
  color: backgroundColor,
);

const TextStyle hint = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w600,
  color: Colors.white54,
);

const TextStyle alertContentStyle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w600,
  color: Color(0XFFFFFFFF),
  overflow: TextOverflow.fade
);

const TextStyle alertTitleStyle = TextStyle(
  fontSize: 25,
  fontWeight: FontWeight.bold,
  color: backgroundColor,
);

ButtonStyle buttonStyle = ButtonStyle(
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    )),
    elevation: MaterialStateProperty.all(15),
    textStyle: MaterialStateProperty.all(const TextStyle(
        fontSize: 18, color: backgroundColor, fontWeight: FontWeight.w600)),
    backgroundColor: MaterialStateProperty.all(appbarColor));

ButtonStyle alertButtonStyle = ButtonStyle(
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    )),
    elevation: MaterialStateProperty.all(15),
    textStyle: MaterialStateProperty.all(const TextStyle(
        fontSize: 18, color: backgroundColor, fontWeight: FontWeight.w600)),
    backgroundColor: MaterialStateProperty.all(buttonColor));
