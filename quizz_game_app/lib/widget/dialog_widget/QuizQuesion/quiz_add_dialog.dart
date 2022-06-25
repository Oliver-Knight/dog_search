import 'package:flutter/material.dart';
import 'package:quizz_game_app/Bloc/Quiz_bloc/quiz_bloc_bloc.dart';
import 'package:quizz_game_app/Modal/quiz/quiz_question_modal.dart';
import 'package:quizz_game_app/util/color.dart';
import 'package:quizz_game_app/util/style.dart';
import 'package:quizz_game_app/widget/dialog_widget/QuizQuesion/quiz_radio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizz_game_app/widget/dialog_widget/animate_dialog.dart';
import 'package:quizz_game_app/widget/dialog_widget/auth_dialog.dart';

class QuizQuestionDialog extends StatefulWidget {
  final String? title;
  const QuizQuestionDialog({Key? key, required this.title}) : super(key: key);

  @override
  State<QuizQuestionDialog> createState() => _QuizQuestionDialogState();
}

class _QuizQuestionDialogState extends State<QuizQuestionDialog> {
  late final QuizBlocBloc _quizBloc = context.read<QuizBlocBloc>();
  final TextEditingController _questionC = TextEditingController();
  final TextEditingController _ans1C = TextEditingController();
  final TextEditingController _ans2C = TextEditingController();
  final TextEditingController _ans3C = TextEditingController();

  final FocusNode _questionF = FocusNode();
  final FocusNode _ans1F = FocusNode();
  final FocusNode _ans2F = FocusNode();
  final FocusNode _ans3F = FocusNode();
  final FocusNode _rAnsF = FocusNode();

  final GlobalKey<FormState> _key = GlobalKey();

  int? _value;

  void save() {
    if (_key.currentState?.validate() == true || _value != null) {
      _quizBloc.add(QuizQuestionAddEvent(
          modal: QuizQuestionModal(
        keyword: widget.title,
        question: _questionC.text,
        answer1: _ans1C.text,
        answer2: _ans2C.text,
        answer3: _ans3C.text,
        rightAnswer: _value,
      )));
      Navigator.pop(context);
    }
  }
  @override
  void dispose() {
    // _quizBloc.add(GetQuizQuestionEvent(keyword: widget.title!));
    _questionC.dispose();
    _ans1C.dispose();
    _ans2C.dispose();
    _ans3C.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsAlignment: MainAxisAlignment.center,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      elevation: 10,
      contentPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 23),
      backgroundColor: appbarColor,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "${widget.title} add",
            style: quizTitleStyle,
          ),
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close),
            color: backgroundColor,
            iconSize: 30,
            splashRadius: 20,
          )
        ],
      ),
      content: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Form(
            key: _key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                quizTextField(
                  "Quiz question",
                  _questionF,
                  _questionC,
                  validator: (_) {
                    return _questionC.text.isEmpty
                        ? "Question Required !"
                        : null;
                  },
                  onEditingComplete: () {
                    _ans1F.requestFocus();
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                quizTextField(
                  "Answer1",
                  _ans1F,
                  _ans1C,
                  validator: (_) {
                    return _ans1C.text.isEmpty ? "Answer1 Required !" : null;
                  },
                  onEditingComplete: () {
                    _ans2F.requestFocus();
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                quizTextField(
                  "Answer2",
                  _ans2F,
                  _ans2C,
                  validator: (_) {
                    return _ans2C.text.isEmpty ? "Answer2 Required !" : null;
                  },
                  onEditingComplete: () {
                    _ans3F.requestFocus();
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                quizTextField(
                  "Answer3",
                  _ans3F,
                  _ans3C,
                  validator: (_) {
                    return _ans3C.text.isEmpty ? "Answer3 Required !" : null;
                  },
                  onEditingComplete: () {
                    //todo
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    "Choose Right Answer",
                    style: scoreStyle.copyWith(
                        fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
                RadioButtonWidget(values: _value)
              ],
            ),
          ),
        ),
      ),
      actions: [
        ElevatedButton.icon(
          style: alertButtonStyle,
          onPressed: () {
            //todo
            save();
          },
          icon: const Icon(Icons.save),
          label: BlocConsumer<QuizBlocBloc, QuizBlocState>(
            listener: (context, state) {
              if (state is QuizActionSuccessState) {
                return AnimatedDialog.showAnimateDialog(
                    context: context,
                    alert: QuizAlertDialog(
                        title: "Success",
                        content: "${widget.title} added successfully",
                        icon: Icons.task_alt,
                        ),
                        );
              } else if(state is QuizActionErrorState) {
                return AnimatedDialog.showAnimateDialog(
                    context: context,
                    alert: QuizAlertDialog(
                        title: "Failed",
                        content: "${state.errormessage}"));
              }
            },
            builder: (context, state) {
              return const Text("Save");
            },
          ),
        )
      ],
    );
  }
}

Widget quizTextField(
    String title, FocusNode focus, TextEditingController _controller,
    {required String? Function(String?)? validator,
    required void Function()? onEditingComplete,
    int line = 1,
    bool readOnly = false}) {
  return TextFormField(
    autovalidateMode: AutovalidateMode.onUserInteraction,
    onEditingComplete: onEditingComplete,
    maxLines: line,
    validator: validator,
    controller: _controller,
    focusNode: focus,
    style: const TextStyle(color: backgroundColor),
    readOnly: readOnly,
    cursorColor: backgroundColor,
    decoration: InputDecoration(
      errorStyle: const TextStyle(fontSize: 15),
      hintStyle: hint,
      hintText: title,
      filled: true,
      fillColor: secondaryColor,
      border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: Colors.white)),
      enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: Color(0xFFFFFFFF))),
    ),
  );
}
