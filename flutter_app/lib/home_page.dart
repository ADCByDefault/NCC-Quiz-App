import "package:flutter/material.dart";

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home page")),
      body: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: StartQuiz()),
        ],
      ),
    );
  }
}

class StartQuiz extends StatelessWidget {
  const StartQuiz({super.key});

  void startQuiz(BuildContext context) {
    Navigator.pushNamed(context, "/quiz page");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Start Quiz"),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
          ),
          onPressed: () {
            startQuiz(context);
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            child: const Icon(
              Icons.play_arrow,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
