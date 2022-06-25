part of 'quiz_bloc_bloc.dart';

@immutable
abstract class QuizBlocState {}

class QuizBlocInitial extends QuizBlocState {}

class QuizActionSuccessState extends QuizBlocState{
  // List<QuizModal>? quizModal;
  // QuizActionSuccessState({this.quizModal});
}

class QuizLoadingState extends QuizBlocState{}

class GetHeadQuizState extends QuizBlocState{
  List<QuizModal>? quizModal;
  GetHeadQuizState({this.quizModal});
}

class GetQuizQuestionState extends QuizBlocState{
  List<QuizQuestionModal>? quizModal;
  GetQuizQuestionState({this.quizModal});
}

class QuizActionErrorState extends QuizBlocState{
  final String? errormessage;
  QuizActionErrorState({this.errormessage});
}
