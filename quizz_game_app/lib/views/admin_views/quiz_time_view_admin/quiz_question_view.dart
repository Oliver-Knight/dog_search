import 'dart:io';

import 'package:flutter/material.dart';
import 'package:quizz_game_app/Bloc/Auth_bloc/auth_bloc_bloc.dart';
import 'package:quizz_game_app/Bloc/Quiz_bloc/quiz_bloc_bloc.dart';
import 'package:quizz_game_app/Repo/Database/database_helper.dart';
import 'package:quizz_game_app/util/color.dart';
import 'package:quizz_game_app/util/db_table.dart';
import 'package:quizz_game_app/util/style.dart';
import 'package:quizz_game_app/views/admin_views/quiz_time_view_admin/quiz_arguments.dart';
import 'package:quizz_game_app/widget/dialog_widget/QuizQuesion/quiz_add_dialog.dart';
import 'package:quizz_game_app/widget/dialog_widget/animate_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QuizQuestionView extends StatefulWidget {
  QuizQuestionArgs args;
  QuizQuestionView({Key? key, required this.args}) : super(key: key);

  @override
  State<QuizQuestionView> createState() => _QuizQuestionViewState();
}

class _QuizQuestionViewState extends State<QuizQuestionView> {
  late final QuizBlocBloc _quizBloc = context.read<QuizBlocBloc>();
  @override
  void initState() {
    super.initState();
    _quizBloc.add(GetQuizQuestionEvent(keyword: widget.args.title!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              children: [
                Hero(
                  tag: '${widget.args.id}',
                  child: Container(
                    alignment: Alignment.topLeft,
                    width: MediaQuery.of(context).size.width,
                    height: 300,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: FileImage(File(widget.args.photo!)),
                            fit: BoxFit.cover)),
                  ),
                ),
                Container(
                    margin: const EdgeInsets.only(top: 10, left: 4),
                    decoration: const BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                          size: 30,
                          color: backgroundColor,
                        )))
              ],
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              width: MediaQuery.of(context).size.width,
              height: 60,
              color: secondaryColor,
              child: Text(
                "Current Questions of ${widget.args.title}",
                style: title.copyWith(fontSize: 22),
              ),
            ),
            BlocBuilder<QuizBlocBloc, QuizBlocState>(
              builder: (context, state) {
                if (state is GetQuizQuestionState) {
                  if (state.quizModal!.isEmpty) {
                    return const Text(
                      'No data for this Head Quiz',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.redAccent),
                    );
                  }
                  return Expanded(
                    child: ListView.builder(
                        itemCount: state.quizModal!.length,
                        itemBuilder: (_, index) {
                          return ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            tileColor: buttonColor,
                            leading: CircleAvatar(
                              radius: 40,
                              foregroundImage:
                                  FileImage(File(widget.args.photo!)),
                            ),
                            title: Text(state.quizModal![index].question!),
                            subtitle: Text(state.quizModal![index].keyword!),
                          );
                        }),
                  );
                } else if (state is QuizActionErrorState) {
                  return Text(state.errormessage!);
                }
                return const Center(child: Text("No data avaliable"));
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _quizBloc.add(GetQuizQuestionEvent(keyword: widget.args.title!));
          AnimatedDialog.showAnimateDialog(
            context: context,
            alert: BlocProvider(
              create: (context) => QuizBlocBloc(),
              child: QuizQuestionDialog(title: widget.args.title),
            ),
          );
        },
        backgroundColor: buttonColor,
        child: const Icon(
          Icons.add_card,
          size: 30,
        ),
      ),
    );
  }
}
