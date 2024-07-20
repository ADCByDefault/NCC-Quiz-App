import "dart:convert";
import "dart:math";
import "package:flutter/services.dart";
import "package:flutter/material.dart";
import "question.dart";

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int errors = 0;
  int correct = 0;

  PageController quizPageController = PageController();

  List<Question> normativaQuestions = [];
  Map<String, List<Question>> tecnicaQuestions = {};
  List<Question> questionsToShow = [];

  @override
  void initState() {
    getQuestions().then((qs) {
      Map<String, List<Question>> t = qs["parte_tecnica"];
      List<Question> n = qs["parte_normativa"];
      List<Question> temp = [];
      Random random = Random();
      for (int i = 0; i < 30; i++) {
        int num = random.nextInt(n.length);
        temp.add(n[num]);
        n.removeAt(num);
      }
      for (int i = 0; i < 10; i++) {
        int num = random.nextInt(t["FIRENZE"]!.length);
        temp.add(t["FIRENZE"]![num]);
        t["FIRENZE"]?.removeAt(num);
      }
      setState(() {
        questionsToShow = temp;
        tecnicaQuestions = t;
        normativaQuestions = n;
      });
    });
    super.initState();
  }

  Future<Map<String, dynamic>> getQuestions() async {
    //getting json data from assets/data.json
    String stringData = await rootBundle.loadString("assets/data.json");
    List<dynamic> data = jsonDecode(stringData);

    //organizing data
    List<Question> normativaQuestions = [];
    Map<String, List<Question>> tecnicaQuestions = {};

    for (var q in data) {
      if (!(q["forType"] == "autovetture")) {
        continue;
      }
      Question question = Question(
          question: q["question"],
          A: q["A"],
          B: q["B"],
          C: q["C"],
          corretta: q["correct"],
          forType: q["forType"],
          type: q["type"]);
      if (question.type == "parte_normativa") {
        normativaQuestions.add(question);
      } else {
        question.provincia = q["provincia"];

        if (!tecnicaQuestions.containsKey(question.provincia)) {
          List<Question> list = [];
          list.add(question);
          tecnicaQuestions.addAll({question.provincia: list});
        } else {
          tecnicaQuestions[question.provincia]?.add(question);
        }
      }
    }
    return ({
      "parte_tecnica": tecnicaQuestions,
      "parte_normativa": normativaQuestions
    });
  }

  @override
  void dispose() {
    quizPageController.dispose();
    super.dispose();
  }

  void onBtnPressed(int n) {
    setState(() {
      if (n < 0) {
        errors++;
      } else {
        correct++;
      }
    });
    quizPageController.nextPage(
        duration: Durations.long2, curve: Easing.legacyAccelerate);
  }

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      appBar: AppBar(
        title: const Text("Quiz page"),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Errori: $errors",
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(
                height: 20,
                width: 50,
              ),
              Text(
                "Corrette: $correct",
                style: const TextStyle(color: Colors.green),
              ),
            ],
          ),
          Expanded(
            child: PageView.builder(
              controller: quizPageController,
              itemCount: questionsToShow.length,
              itemBuilder: (context, i) {
                return QuestionCard(
                    question: questionsToShow[i], onBtnPressed: onBtnPressed);
              },
            ),
          ),
          const SizedBox(
            height: 40,
            width: 40,
          ),
        ],
      ),
    ));
  }
}
