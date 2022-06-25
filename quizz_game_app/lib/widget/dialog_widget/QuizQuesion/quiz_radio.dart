import 'package:flutter/material.dart';
import 'package:quizz_game_app/util/color.dart';

class RadioButtonWidget extends StatefulWidget {
  int? values;
  RadioButtonWidget({ Key? key, required this.values }) : super(key: key);

  @override
  State<RadioButtonWidget> createState() => _RadioButtonWidgetState();
}

class _RadioButtonWidgetState extends State<RadioButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return FormField(builder: (state){
      return Column(
        children: [
          Row(
                  children: [
                    Radio(
                      splashRadius: 15,
                      value: 1,
                      groupValue: widget.values,
                      onChanged: (value) {
                        setState(() {
                          widget.values = int.parse(value.toString());
                        });
                      },
                      fillColor: widget.values != 1
                          ? MaterialStateProperty.all(backgroundColor)
                          : MaterialStateProperty.all(buttonColor),
                    ),
                    Text(
                      "Answer1",
                      style: TextStyle(
                          fontSize: 18,
                          color: widget.values == 1
                              ? buttonColor
                              : backgroundColor,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Radio(
                      value: 2,
                      splashRadius: 15,
                      groupValue: widget.values,
                      onChanged: (value) {
                        setState(() {
                         widget.values = int.parse(value.toString());
                        });
                      },
                      fillColor: widget.values != 2
                          ? MaterialStateProperty.all(backgroundColor)
                          : MaterialStateProperty.all(buttonColor),
                    ),
                    Text(
                      "Answer2",
                      style: TextStyle(
                          fontSize: 18,
                          color: widget.values == 2
                              ? buttonColor
                              : backgroundColor,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Radio(
                      value: 3,
                      splashRadius: 15,
                      groupValue: widget.values,
                      onChanged: (value) {
                        widget.values = int.parse(value.toString());
                        setState(() {});
                      },
                      fillColor: widget.values != 3
                          ? MaterialStateProperty.all(backgroundColor)
                          : MaterialStateProperty.all(buttonColor),
                    ),
                    Text(
                      "Answer3",
                      style: TextStyle(
                          fontSize: 18,
                          color: widget.values == 3
                              ? buttonColor
                              : backgroundColor,
                          fontWeight: FontWeight.w600),
                    )
                  ],
                ),
                Text(
                  state.errorText ?? '',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16
                  ),
                )
        ],
      );
    },
    validator: (_){
      if(widget.values == null){
        return 'You must choose the right answer';
      }
      else{
        return null;
      }
    },
    );
  }
}