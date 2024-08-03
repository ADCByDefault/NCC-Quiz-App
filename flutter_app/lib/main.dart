import "package:flutter/material.dart";
import "package:ncc_quiz/result_page.dart";
import "init_page.dart";
import 'home_page.dart';
import "quiz_page.dart";

void main() {
  runApp(MaterialApp(
    title: "NCC Quiz",
    initialRoute: "/InitPage",
    routes: {
      "/HomePage": (BuildContext context) => const HomePage(),
      "/InitPage": (BuildContext context) => const InitPage(),
      "/QuizPage": (BuildContext context) => const QuizPage(),
      "/ResultPage" : (BuildContext context) => const ResultPage(),
    },
  ));
}
