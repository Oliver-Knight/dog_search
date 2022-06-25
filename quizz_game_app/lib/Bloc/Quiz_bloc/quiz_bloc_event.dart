part of 'quiz_bloc_bloc.dart';

@immutable
abstract class QuizBlocEvent {}

class HeaderQuizAddEvent extends QuizBlocEvent{
  QuizModal quizModal;
  HeaderQuizAddEvent({required this.quizModal});
}

class HeaderQuizUpdateEvent extends QuizBlocEvent{}

class GetHeaderQuizEvent extends QuizBlocEvent{}

class HeaderQuizDeleteEvent extends QuizBlocEvent{}

class QuizQuestionAddEvent extends QuizBlocEvent{
  QuizQuestionModal modal;
  QuizQuestionAddEvent({required this.modal});
}

class GetQuizQuestionEvent extends QuizBlocEvent{
  final String keyword;
  GetQuizQuestionEvent({required this.keyword});
}

