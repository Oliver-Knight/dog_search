import 'package:flutter/foundation.dart';

class QuizQuestionModal{
  final int? id;
  final String? keyword;
  final String? question;
  final String? answer1;
  final String? answer2;
  final String? answer3;
  final int? rightAnswer;

  QuizQuestionModal({this.id, this.keyword,this.question,this.answer1,this.answer2,this.answer3,this.rightAnswer,});

  Map<String,dynamic> toMap(){
    return {
      'keyword' : keyword,
      'questoin' : question,
      'answer1' : answer1,
      'answer2' : answer2,
      'answer3' : answer3,
      'rightAnswer' : rightAnswer
    };
  }

  factory QuizQuestionModal.fromMap(Map<String,dynamic> data){
    return QuizQuestionModal(
      id : data['id'],
      keyword: data['keyword'],
      question: data['questoin'],
      answer1: data['answer1'],
      answer2: data['answer2'],
      answer3: data['answer3'],
      rightAnswer: data['rightAnswer']
    );
  }

}