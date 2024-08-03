import "package:flutter/material.dart";
import "dart:math";
import "question.dart";
import 'question_manager.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  void autovettureFI() {
    List<Question> questions = [];
    List temp = Question.filterQuestions("type", "parte_normativa",
        Question.filterQuestions("forType", "autovetture"));
    Random rng = Random();
    for (int i = 0; i < 30; i++) {
      if (temp.isEmpty) continue;
      questions.add(temp[rng.nextInt(temp.length)]);
    }
    temp = (Question.filterQuestions("provincia", "FIRENZE",
        Question.filterQuestions("forType", "autovetture")));
    for (int i = 0; i < 10; i++) {
      if (temp.isEmpty) continue;
      questions.add(temp[rng.nextInt(temp.length)]);
    }
    QuestionManager questionManager = QuestionManager.fromList(questions);
    Navigator.pushNamed(context, "/QuizPage", arguments: questionManager);
  }

  void autovettureTecnicaFI() {
    List<Question> questions = [];
    Random rng = Random();
    List temp = (Question.filterQuestions("provincia", "FIRENZE",
        Question.filterQuestions("forType", "autovetture")));
    for (int i = 0; i < 40; i++) {
      if (temp.isEmpty) continue;
      questions.add(temp[rng.nextInt(temp.length)]);
    }
    QuestionManager questionManager = QuestionManager.fromList(questions);
    Navigator.pushNamed(context, "/QuizPage", arguments: questionManager);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: Container(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StartQuizCard(
              text: "NCC classic FI",
              icon: const Icon(Icons.play_arrow),
              onClick: autovettureFI,
            ),
            StartQuizCard(
              text: "NCC tecnica FI",
              icon: const Icon(Icons.play_arrow),
              onClick: autovettureTecnicaFI,
            ),
          ],
        ),
      ),
    );
  }
}

class StartQuizCard extends StatelessWidget {
  final String text;
  final Icon icon;
  final Function onClick;

  const StartQuizCard({
    super.key,
    required this.text,
    required this.icon,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
        ),
        onPressed: () => onClick(),
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 16, 0, 8),
                    child: Text(text),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                    child: const Icon(Icons.play_arrow),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
