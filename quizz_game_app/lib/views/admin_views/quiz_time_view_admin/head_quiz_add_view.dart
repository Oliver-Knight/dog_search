import 'dart:io';

import 'package:flutter/material.dart';
import 'package:quizz_game_app/Bloc/Auth_bloc/auth_bloc_bloc.dart';
import 'package:quizz_game_app/Bloc/Quiz_bloc/quiz_bloc_bloc.dart';
import 'package:quizz_game_app/Modal/quiz/quiz_modal.dart';
import 'package:quizz_game_app/Repo/Database/database_helper.dart';
import 'package:quizz_game_app/util/color.dart';
import 'package:quizz_game_app/util/pages.dart';
import 'package:quizz_game_app/util/style.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quizz_game_app/widget/dialog_widget/animate_dialog.dart';
import 'package:quizz_game_app/widget/dialog_widget/auth_dialog.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HeadQuizView extends StatefulWidget {
  const HeadQuizView({Key? key}) : super(key: key);

  @override
  State<HeadQuizView> createState() => _HeadQuizViewState();
}

class _HeadQuizViewState extends State<HeadQuizView> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _desController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  final FocusNode _titleF = FocusNode();
  final FocusNode _desF = FocusNode();
  final FocusNode _dateF = FocusNode();
  final ImagePicker _imagePicker = ImagePicker();

  final GlobalKey<FormState> _key = GlobalKey();
  DateTime now = DateTime.now();
  DateTime current = DateTime.now();
  late String date;

  late final QuizBlocBloc _quiz = context.read<QuizBlocBloc>();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: DateTime(current.year - 100),
        lastDate: current);
    if (picked != null && picked != now) {
      setState(() {
        now = picked;
      });
    }
  }

  XFile? _photo;

  void addQuiz() {
    if (_key.currentState!.validate() != true) {
      return;
    }
    if (_photo == null) {
      _dateF.unfocus();
      AnimatedDialog.showAnimateDialog(
        context: context,
        alert: QuizAlertDialog(
          title: "Quiz Header Add Fail",
          content: "You Need to Choose Photo for your Quiz",
          icon: Icons.error,
          onpress: () {
            _desF.unfocus();
            Navigator.pop(context);
          },
        ),
      );
    }
    else{
      _quiz.add(
      HeaderQuizAddEvent(
        quizModal: QuizModal(
          title: _titleController.text,
          description: _desController.text,
          date: date,
          photo: _photo!.path.toString(),
        ),
      ),
    );
    }
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _desController.dispose();
    _dateController.dispose();
    _titleF.unfocus();
    _desF.unfocus();
    _dateF.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    date = DateFormat('dd-MM-yy').format(now);
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                alignment: Alignment.centerLeft,
                decoration: const BoxDecoration(color: appbarColor, boxShadow: [
                  BoxShadow(blurRadius: 5, offset: Offset(0, 5))
                ]),
                width: MediaQuery.of(context).size.width,
                height: 80,
                child: TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 1000),
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            context
                                .read<AuthBlocBloc>()
                                .add(AuthInitialEvent());
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.arrow_back,
                            color: backgroundColor,
                            size: 30,
                          )),
                      const SizedBox(
                        width: 30,
                      ),
                      const Text(
                        "Add Quiz Header",
                        style: quizTitleStyle,
                      ),
                    ],
                  ),
                  builder: (_, double _val, Widget? child) {
                    return Opacity(
                      opacity: _val,
                      child: child,
                    );
                  },
                ),
              ),
              InkWell(
                onTap: () async {
                  _photo =
                      await _imagePicker.pickImage(source: ImageSource.gallery);
                  setState(() {});
                  if (_photo == null) return;
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: secondBgColor,
                      image: _photo != null
                          ? DecorationImage(
                              image: FileImage(File(_photo!.path)),
                              fit: BoxFit.cover)
                          : null),
                  margin: const EdgeInsets.only(top: 0),
                  height: 250,
                  width: MediaQuery.of(context).size.width,
                  child: _photo == null
                      ? const Icon(
                          Icons.add_a_photo,
                          color: backgroundColor,
                          size: 50,
                        )
                      : null,
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.56,
                // width: MediaQuery.of(context).size.width * 1,
                decoration: const BoxDecoration(
                  color: appbarColor,
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: Form(
                  key: _key,
                  child: Column(
                    children: [
                      quizTextField(
                        "Title",
                        _titleF,
                        _titleController,
                        validator: (_) => _titleController.text.isEmpty
                            ? "Title Required !"
                            : null,
                        onEditingComplete: () => _desF.requestFocus(),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      quizTextField("description", _desF, _desController,
                          validator: (_) => _desController.text.isEmpty
                              ? "Description Required !"
                              : null,
                          onEditingComplete: () async =>
                              await _selectDate(context),
                          line: 3),
                      const SizedBox(
                        height: 20,
                      ),
                      // quizTextField(
                      //   "date",
                      //   _dateF,
                      //   _dateController,
                      //   validator: (_) => _titleController.text.isEmpty
                      //       ? "Date Required !"
                      //       : null,
                      //   onEditingComplete: () => _desF.requestFocus(),
                      //   readOnly: true
                      // ),
                      Container(
                          width: MediaQuery.of(context).size.width,
                          height: 60,
                          decoration: BoxDecoration(
                              color: secondaryColor,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              border: Border.all(color: backgroundColor)),
                          child: TextButton(
                              onPressed: () async {
                                await _selectDate(context);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    date,
                                    style: const TextStyle(
                                        color: backgroundColor, fontSize: 16),
                                  ),
                                ],
                              ))),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          child: BlocConsumer<QuizBlocBloc, QuizBlocState>(
                            listener: (context, state) {
                              if (state is QuizActionSuccessState) {
                                AnimatedDialog.showAnimateDialog(
                                    context: context,
                                    alert: QuizAlertDialog(
                                        title: "Success!",
                                        content:
                                            "Quiz Header added successfully",
                                        icon: Icons.task_alt,
                                        onpress: () {
                                          _titleController.clear();
                                          _desController.clear();
                                          _dateController.clear();
                                          _desF.unfocus();
                                          _photo = null;
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        }));
                              }
                              if (state is QuizActionErrorState) {
                                AnimatedDialog.showAnimateDialog(
                                    context: context,
                                    alert: QuizAlertDialog(
                                        title: "Failed!",
                                        content: "Adding Quiz Header failed !",
                                        icon: Icons.task_alt,
                                        onpress: () {
                                          _titleController.clear();
                                          _desController.clear();
                                          _dateController.clear();
                                          _desF.unfocus();
                                          _photo = null;
                                          Navigator.pop(context);
                                        }));
                              }
                            },
                            builder: (context, state) {
                              return ElevatedButton(
                                  style: alertButtonStyle,
                                  onPressed: addQuiz,
                                  child: const Text("Add"));
                            },
                          ))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
        errorStyle: TextStyle(fontSize: 15),
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
}
