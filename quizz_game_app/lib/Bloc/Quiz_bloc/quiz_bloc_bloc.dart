import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:quizz_game_app/Modal/quiz/quiz_modal.dart';
import 'package:quizz_game_app/Modal/quiz/quiz_question_modal.dart';
import 'package:quizz_game_app/Repo/Database/database_helper.dart';

part 'quiz_bloc_event.dart';
part 'quiz_bloc_state.dart';

class QuizBlocBloc extends Bloc<QuizBlocEvent, QuizBlocState> {
  QuizBlocBloc() : super(QuizBlocInitial()) {
    on<HeaderQuizAddEvent>(_headerQuizAdd);
    on<GetHeaderQuizEvent>(_getHeaderQuiz);
    on<QuizQuestionAddEvent>(_quizQuestionAdd);
    on<GetQuizQuestionEvent>(_getQuizQuestion);
  }

  Future<void> _getQuizQuestion(
      GetQuizQuestionEvent event, Emitter<QuizBlocState> emit) async {
        try {
          emit(QuizLoadingState());
          List<QuizQuestionModal> _question = await DatabaseHelper.instance.getQuizQuestion(event.keyword);
          emit(GetQuizQuestionState(quizModal: _question));
        } catch (e) {
          emit(QuizActionErrorState(errormessage: e.toString()));
        }
      }

  Future<void> _quizQuestionAdd(
      QuizQuestionAddEvent event, Emitter<QuizBlocState> emit) async {
    try {
      emit(QuizLoadingState());
      await DatabaseHelper.instance.quizQuestionAdd(event.modal);
      emit(QuizActionSuccessState());
      // await DatabaseHelper.instance.getQuizQuestion();
    } catch (e) {
      emit(QuizActionErrorState(errormessage: e.toString()));
    }
  }

  void _headerQuizAdd(HeaderQuizAddEvent event, Emitter<QuizBlocState> emit) {
    try {
      DatabaseHelper.instance.insertQuizHead(event.quizModal);
      emit(QuizActionSuccessState());
    } catch (e) {
      emit(QuizActionErrorState(errormessage: e.toString()));
    }
  }

  void _getHeaderQuiz(
      GetHeaderQuizEvent event, Emitter<QuizBlocState> emit) async {
    try {
      List<QuizModal> _quizList = await DatabaseHelper.instance.getQuizHeader();
      emit(GetHeadQuizState(quizModal: _quizList));
    } catch (e) {
      emit(QuizActionErrorState(errormessage: e.toString()));
    }
  }
}
