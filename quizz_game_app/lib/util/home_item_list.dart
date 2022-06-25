
import 'package:flutter/material.dart';
import 'package:quizz_game_app/widget/home_widget/quizCard.dart';

class HomeItem{
static List<Widget> quizCards = const [
              QuizCard(
                photoUrl: 'images/dota2.jpg',
                quizTitle: "Dota2 Quiz",
                quizDescription: "This is dota2 quiz about the spells and dota2 items, so you should have some knowledge about dota2 Game.",
                quizDate: "22-4-2022"),

              QuizCard(
                photoUrl: "images/csgo.jpg",
                quizTitle: "Counter Strike Quiz",
                quizDescription: "This is Counter Strike quiz about the guns and other related things, so you should have some knowledge about Counter Strike Game.",
                quizDate: "22-4-2022"),

              QuizCard(
                photoUrl: "images/fortnite.jpg",
                quizTitle: "Fortnite Quiz",
                quizDescription: "This is Fortnite quiz about the weapons and related things, so you should have some knowledge about Frotnite Game ",
                quizDate: "22-4-2022"),

              QuizCard(
                photoUrl: "images/Lol.png",
                quizTitle: "League of Legend Quiz",
                quizDescription: "This is League of Legend quiz about the heros and related things, so you should have some knowledge about League of Legend Game ",
                quizDate: "22-4-2022"),

              QuizCard(
                photoUrl: "images/apex.jpg",
                quizTitle: "Apex Legend Quiz",
                quizDescription: "This is Apex Legend quiz about the Weapons and related things, so you should have some knowledge about Apex Legend Game ",
                quizDate: "22-4-2022"),
                ];
}

