import "package:flutter/material.dart";
import 'package:quiz_app/quiz_page.dart';
import 'home_page.dart';

void main() {
  runApp(MaterialApp(
    title: "NCC Quiz",
    initialRoute: "/",
    routes: {
      "/": (context) => const HomePage(),
      "/quiz page": (context) => const QuizPage(),
    },
  ));
}
