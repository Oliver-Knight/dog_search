import 'package:flutter/material.dart';
import 'package:quizz_game_app/Repo/Database/database_helper.dart';
import 'package:quizz_game_app/util/db_table.dart';
import 'package:quizz_game_app/util/home_item_list.dart';
import 'package:quizz_game_app/util/color.dart';
import 'package:quizz_game_app/util/pages.dart';
import 'package:quizz_game_app/util/style.dart';
import 'package:quizz_game_app/Bloc/Quiz_bloc/quiz_bloc_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizz_game_app/views/admin_views/quiz_time_view_admin/quiz_arguments.dart';
import 'package:quizz_game_app/views/admin_views/quiz_time_view_admin/quiz_question_view.dart';
import 'package:quizz_game_app/widget/dialog_widget/animate_dialog.dart';
import 'package:quizz_game_app/widget/dialog_widget/auth_dialog.dart';
import 'package:quizz_game_app/widget/home_widget/quizCard.dart';

class AdminHomeView extends StatefulWidget {
  AdminHomeView({Key? key}) : super(key: key);
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  @override
  State<AdminHomeView> createState() => _AdminHomeViewState();
}

class _AdminHomeViewState extends State<AdminHomeView> {
  late final QuizBlocBloc _quizBloc = context.read<QuizBlocBloc>();
  // static final Tween<Offset> _position =
  //     Tween(begin: const Offset(1, 0), end: const Offset(0, 0));
  @override
  void initState() {
    super.initState();
    _quizBloc.add(GetHeaderQuizEvent());
  }

  @override
  Widget build(BuildContext context) {
    print(_quizBloc.state);
    return SafeArea(
      child: Container(
        color: backgroundColor,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 20, right: 20),
              alignment: Alignment.centerLeft,
              decoration: const BoxDecoration(
                  color: appbarColor,
                  boxShadow: [BoxShadow(blurRadius: 5, offset: Offset(0, 5))]),
              width: MediaQuery.of(context).size.width,
              height: 80,
              child: TweenAnimationBuilder(
                tween: Tween<double>(begin: 0, end: 1),
                duration: const Duration(milliseconds: 1000),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Quiz App Home Admin",
                      style: quizTitleStyle,
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.pushNamed(context, HeadQuizAdd);
                        },
                        icon: const Icon(
                          Icons.add,
                          color: backgroundColor,
                          size: 30,
                        ))
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
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: BlocBuilder<QuizBlocBloc, QuizBlocState>(
                    builder: (context, state) {
                      if (state is GetHeadQuizState) {
                        return RefreshIndicator(
                          color:appbarColor,
                          backgroundColor: backgroundColor,
                          onRefresh: ()async {
                             _quizBloc.add(GetHeaderQuizEvent());
                          },
                          child: ListView(
                            children: [
                              for (var i in state.quizModal!) ...[
                                TweenAnimationBuilder(
                                  duration: const Duration(milliseconds: 500),
                                  tween: Tween<double>(begin: 150, end: 0),
                                  child: InkWell(
                                    onLongPress: () {
                                      AnimatedDialog.showAnimateDialog(
                                        context: context,
                                        alert: QuizAlertDialog(
                                            title: "Delete Header Quiz ${i.id}",
                                            content:
                                                "It will delete the Header Quiz parmentaly from database !!!",
                                            icon: Icons.warning_rounded,
                                            onpress: (){
                                              // DatabaseHelper.instance.dropTable(DbTable.headQuizTable);
                                              DatabaseHelper.instance.deleteQuizHeader(i.id!);
                                              _quizBloc.add(GetHeaderQuizEvent());
                                              Navigator.pop(context);
                                            },
                                            ),
                                      );
                                    },
                                    onTap: () {
                                      //todo
                                      Navigator.pushNamed(context, QuizQuestionAdd,arguments: QuizQuestionArgs(i.id, i.title, i.photo));
                                    },
                                    child: QuizCard(
                                      photoUrl: i.photo,
                                      quizTitle: i.title,
                                      quizDescription: i.description,
                                      quizDate: i.date,
                                      id: i.id,
                                    ),
                                  ),
                                  builder: (_, double _val, Widget? child) {
                                    return Padding(
                                      padding: EdgeInsets.only(top: _val),
                                      child: child,
                                    );
                                  },
                                )
                              ]
                            ],
                          ),
                        );
                      } else if (state is QuizActionErrorState) {
                        AnimatedDialog.showAnimateDialog(
                            context: context,
                            alert: QuizAlertDialog(
                                title: "Error", content: state.errormessage!));
                      }
                      return SizedBox();
                    },
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
