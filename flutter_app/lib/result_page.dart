import 'package:flutter/material.dart';
import 'package:ncc_quiz/question.dart';
import "question_manager.dart";
import 'db_singleton.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({super.key});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  late QuestionManager questionManager;

  @override
  void initState() {
    () async {
      DBSingleton db = await DBSingleton.getDB();
      db.addManagerToData(questionManager);
    }();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    questionManager =
        ModalRoute.of(context)!.settings.arguments as QuestionManager;
    return PopScope(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Risultati"),
        ),
        body: Container(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  color: questionManager.isPassed()
                      ? Colors.green.shade200
                      : Colors.red.shade200,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(4, 4, 4, 8),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 32, 0, 32),
                          child: () {
                            if (!questionManager.isPassed()) {
                              return const Column(
                                children: [
                                  Icon(
                                    Icons.do_disturb,
                                    size: 64,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                                    child: Text(
                                      "Bocciato",
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }
                            return const Column(
                              children: [
                                Icon(
                                  Icons.emoji_events,
                                  size: 64,
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                                  child: Text(
                                    "Passato",
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }(),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "Corrette: ${questionManager.getCorrect()}",
                              style: const TextStyle(color: Colors.green),
                            ),
                            Text(
                              "Sbagliate: ${questionManager.getIncorrect()}",
                              style: const TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: questionManager.getLength(),
                itemBuilder: (context, index) {
                  return ResultQuestionCard(
                      data: questionManager.questionsData[index]);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
