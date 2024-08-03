import "package:flutter/material.dart";
import "package:ncc_quiz/question.dart";
import "package:ncc_quiz/question_manager.dart";

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  late QuestionManager questionManager;
  final PageController pageController = PageController();
  final ScrollController listViewController = ScrollController();

  void onClickOption(Data data) {
    setState(() {
      questionManager = questionManager;
    });
    int index = questionManager.getIndex(data);
    if (index + 1 >= questionManager.getLength()) {
      return;
    }
    pageController.nextPage(
        duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
  }

  void onClickNumberBox(int index) {
    pageController.animateToPage(index,
        duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
  }

  int getFirstNotAnswerPage() {
    for (int i = 0; i < questionManager.questionsData.length; i++) {
      if (!questionManager.questionsData[i].isAnswered()) {
        return i;
      }
    }
    return questionManager.questionsData.length - 1;
  }

  @override
  Widget build(BuildContext context) {
    questionManager =
        ModalRoute.of(context)!.settings.arguments as QuestionManager;

    Widget getAction(String text, Color color, void Function() onClick) {
      return ElevatedButton(
        onPressed: onClick,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            side: BorderSide(color: color, width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
          backgroundColor: Colors.white,
        ),
        child: Text(
          text,
          style: TextStyle(
            color: color,
          ),
        ),
      );
    }

    Future<bool?> createDialog(String text, List<Widget> actions) {
      return showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              actionsAlignment: MainAxisAlignment.spaceAround,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
              content: Container(
                padding: const EdgeInsets.fromLTRB(8, 16, 8, 0),
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              actions: actions,
            );
          });
    }

    Future<bool?> showPopDialog(didPop) async {
      return createDialog("Vuoi davvero uscire?", [
        getAction("Esci", Colors.red.shade500, () {
          Navigator.of(context).pop(true);
        }),
        getAction("Rimani", Colors.green.shade500, () {
          Navigator.of(context).pop(false);
        }),
      ]);
    }

    Future<bool?> showDoneDialog() async {
      String text = "Vuoi davvero consegnare?";
      for (Data data in questionManager.questionsData) {
        if (!["A", "B", "C"].contains(data.selected)) {
          text += " alcune risposte mancanti";
          break;
        }
      }
      return createDialog(text, [
        getAction("Consegna", Colors.red.shade500, () {
          Navigator.of(context).pop(true);
        }),
        getAction("Rimani", Colors.green.shade500, () {
          Navigator.of(context).pop(false);
        }),
      ]);
    }

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) {
          return;
        }
        bool? shouldPop = await showPopDialog(didPop);
        if (shouldPop == true && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Quiz Page"),
          actions: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
              child: ElevatedButton(
                onPressed: () async {
                  bool? isDone = await showDoneDialog();
                  if (isDone == true && context.mounted) {
                    Navigator.of(context).pop();
                    Navigator.of(context)
                        .pushNamed("/ResultPage", arguments: questionManager);
                  }
                },
                child: const Icon(Icons.flag),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: SizedBox(
                height: 50,
                child: Row(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        controller: listViewController,
                        scrollDirection: Axis.horizontal,
                        itemCount: questionManager.getLength(),
                        itemBuilder: (context, index) {
                          return QuestionNumberBox(
                              data: questionManager.questionsData[index],
                              index: index,
                              onClick: onClickNumberBox);
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: PageView(
                controller: pageController,
                children: questionManager.getCards(onClickOption),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
