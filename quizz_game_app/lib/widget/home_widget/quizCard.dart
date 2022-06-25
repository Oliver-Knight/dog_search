import 'dart:io';

import 'package:flutter/material.dart';
import 'package:quizz_game_app/util/color.dart';
import 'package:quizz_game_app/util/style.dart';

class QuizCard extends StatelessWidget {
  final String photoUrl;
  final String quizTitle;
  final String quizDescription;
  final String quizDate;
  final int? id;
  const QuizCard({ Key? key,this.id, required this.photoUrl, required this.quizTitle, required this.quizDescription, required this.quizDate }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
                children: [
                  SizedBox(
                    height: 150,
                    child: Card(
                      color: appbarColor,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      margin: const EdgeInsets.only(top: 7.5, bottom: 7.5),
                      elevation: 10,
                      child: Row(
                        children: [
                        Flexible(
                          flex: 2,
                          child: Hero(
                            tag: '$id',
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: FileImage(File(photoUrl)),
                                ),
                              ),
                              height: 150,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(quizTitle, style: quizTitleStyle),
                              Text(quizDescription, maxLines: 3, style: quizdescriptionStyle,),
                              Row(children: [
                                const Text("Last Updated : ",style: quizUpdateDateStyle,),
                                Text(quizDate, style : quizUpdateDateStyle)
                              ],)
                            ],
                          ),
                        )
                      ]),
                    ),
                  )
                ],
              );
  }
}