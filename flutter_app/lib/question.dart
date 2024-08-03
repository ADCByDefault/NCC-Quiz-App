import "dart:convert";
import "package:flutter/material.dart";
import 'question_manager.dart';

class Question {
  static int currentId = 0;
  late int id = currentId;
  final int? disable;
  final String num, text, A, B, C, correct, forType, type, date, filename, line;
  final String? provincia, img;

  static final List<Question> questions = [];

  Question(
      {required this.num,
      required this.text,
      required this.A,
      required this.B,
      required this.C,
      required this.correct,
      required this.forType,
      required this.type,
      required this.provincia,
      required this.date,
      required this.filename,
      required this.line,
      this.img,
      this.disable = 0,
      dynamic id}) {
    if (id is int) {
      this.id = id;
    } else {
      this.id = currentId;
    }
    questions.add(this);
    if (this.id == currentId) {
      currentId++;
      return;
    }
    if (this.id < currentId) {
      // print(
      //     "Might have interfered with question ids. Crated id : $id, should be : $currentId");
    }
    if (this.id > currentId) {
      // print(
      //     "Jumped currentId counter from $currentId to ${this.id + 1}. Created id : $id");
      currentId = this.id + 1;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "num": num,
      "disable": disable,
      "text": text,
      "A": A,
      "B": B,
      "C": C,
      "correct": correct,
      "img": img,
      "provincia": provincia,
      "forType": forType,
      "type": type,
      "date": date,
      "filename": filename,
      "line": line
    };
  }

  static Question fromMap(dynamic map) {
    return Question(
        num: map["num"],
        text: map["text"],
        A: map["A"],
        B: map["B"],
        C: map["C"],
        correct: map["correct"],
        img: map["img"],
        forType: map["forType"],
        type: map["type"],
        provincia: map["provincia"],
        date: map["date"],
        filename: map["filename"],
        line: map["line"].toString(),
        id: map["id"],
        disable: map["disable"]);
  }

  static List<Map<String, dynamic>> toMapFromList(List<Question> questions) {
    List<Map<String, dynamic>> maps = questions.map((q) {
      return q.toMap();
    }).toList();
    return maps;
  }

  static List<Question> toListFromMap(List<dynamic> questions) {
    return questions.map((q) {
      return Question.fromMap(q);
    }).toList();
  }

  static List<Question> fromJSON(String json) {
    List<dynamic> maps = jsonDecode(json);
    return toListFromMap(maps);
  }

  static List<Question> filterQuestions(dynamic key, dynamic value,
      [List<Question>? questions]) {
    List<Question> filteredQuestions = [];
    questions ??= Question.questions;
    for (int i = 0; i < questions.length; i++) {
      Question q = questions[i];
      if (q.isDisabled()) {
        continue;
      }
      Map<String, dynamic> map = questions[i].toMap();
      if (map[key] != value) continue;
      filteredQuestions.add(q);
      questions.remove(q);
    }
    return filteredQuestions;
  }

  static List<dynamic> getAllPossibleValuesOf(String key,
      [List<Question>? questions]) {
    questions ??= Question.questions;
    List values = questions.map((q) => q.toMap()[key]).toList();
    return values.toSet().toList();
  }

  static Question getById(int id, [List<Question>? questions]) {
    questions ??= Question.questions;
    for (Question q in questions) {
      if (q.id == id) return q;
    }
    return getById(-1);
  }

  bool isDisabled() {
    return disable == 1;
  }
}

//
//
//
//
//
//
//
//
//
//
class QuestionCard extends StatefulWidget {
  final Data data;
  final Function(Data data) onClick;

  const QuestionCard({
    super.key,
    required this.data,
    required this.onClick,
  });

  @override
  State<QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  ButtonStyle getBtnStyle(String option) {
    Color color =
        (option == widget.data.selected) ? Colors.green.shade100 : Colors.white;
    BorderSide side = (option == widget.data.selected)
        ? const BorderSide(width: 1, color: Colors.black)
        : BorderSide.none;

    ButtonStyle btnStyle = ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
        side: side,
      ),
      backgroundColor: color,
    );
    return btnStyle;
  }

  void answerPressed(String option) {
    setState(() {
      widget.data.selected = option;
    });
    widget.onClick(widget.data);
  }

  Widget getOption(String option, String text) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
      child: Center(
        child: ElevatedButton(
          onPressed: () => answerPressed(option),
          style: getBtnStyle(option),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black87),
            ),
          ),
        ),
      ),
    );
  }

  Widget getFooter() {
    List<Widget> list = [
      Text(
        "type: ${widget.data.question.type}, forType: ${widget.data.question.forType}",
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
      )
    ];
    if (widget.data.question.provincia != null) {
      list.add(Text(
        "provincia: ${widget.data.question.provincia}",
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
      ));
    }
    return Column(
      children: list,
    );
  }

  Widget getImageButtonifExists() {
    if (widget.data.question.img != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            backgroundColor: Colors.white,
            onPressed: () {
              showDialog(
                context: context,
                builder: (builder) => Card(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              child: const Icon(Icons.close),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                        Expanded(
                          child: Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                "assets/${widget.data.question.img}",
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
            child: const Icon(Icons.image),
          ),
        ],
      );
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
            child: SizedBox(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(5),
                ),
                padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
                child: Center(
                  child: Text(
                    widget.data.question.text,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
          Card(
            child: Container(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  getOption("A", widget.data.question.A),
                  getOption("B", widget.data.question.B),
                  getOption("C", widget.data.question.C),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
            child: getFooter(),
          ),
          getImageButtonifExists(),
        ],
      ),
    );
  }
}

//
//
//
//
//
//
//
//
//
//

class QuestionNumberBox extends StatefulWidget {
  final Data data;
  final int index;
  final Function(int index) onClick;

  const QuestionNumberBox(
      {super.key,
      required this.data,
      required this.index,
      required this.onClick});

  @override
  State<QuestionNumberBox> createState() => _QuestionNumberBoxState();
}

class _QuestionNumberBoxState extends State<QuestionNumberBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(4, 4, 4, 4),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor:
              widget.data.isAnswered() ? Colors.green.shade200 : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: () {
          setState(() {
            widget.onClick(widget.index);
          });
        },
        child: Container(
          padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
          child: Text(
            "${widget.index + 1}",
            style: const TextStyle(
              color: Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}

//
//
//
//
//
//
//
//
//
//
class ResultQuestionCard extends StatefulWidget {
  final Data data;

  const ResultQuestionCard({super.key, required this.data});

  @override
  State<ResultQuestionCard> createState() => _ResultQuestionCardState();
}

class _ResultQuestionCardState extends State<ResultQuestionCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) => ResultQuestionPopCard(data: widget.data));
        },
        child: SizedBox(
          height: 100,
          child: Row(
            children: [
              SizedBox(
                width: 6,
                child: Container(
                  color: widget.data.isCorrect()
                      ? Colors.green.shade400
                      : Colors.red.shade400,
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    widget.data.question.text,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    maxLines: 4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//
//
//
//
//
//
//
//
//
//
class ResultQuestionPopCard extends StatefulWidget {
  final Data data;

  const ResultQuestionPopCard({
    super.key,
    required this.data,
  });

  @override
  State<ResultQuestionPopCard> createState() => _ResultQuestionPopCardState();
}

class _ResultQuestionPopCardState extends State<ResultQuestionPopCard> {
  ButtonStyle getBtnStyle(String option) {
    Color color = (option == widget.data.question.correct)
        ? Colors.green.shade100
        : Colors.red.shade100;
    BorderSide side = (option == widget.data.selected)
        ? const BorderSide(width: 1, color: Colors.black)
        : BorderSide.none;

    ButtonStyle btnStyle = ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
        side: side,
      ),
      backgroundColor: color,
    );
    return btnStyle;
  }

  Widget getOption(String option, String text) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
      child: Center(
        child: Column(
          children: [
            () {
              if (widget.data.selected == option) {
                return const Text("La tua risposta: ");
              }
              return Container();
            }(),
            ElevatedButton(
              onPressed: () => () {},
              style: getBtnStyle(option),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.black87),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getFooter() {
    List<Widget> list = [
      Text(
        "type: ${widget.data.question.type}, forType: ${widget.data.question.forType}",
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
      )
    ];
    if (widget.data.question.provincia != null) {
      list.add(Text(
        "provincia: ${widget.data.question.provincia}",
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
      ));
    }
    return Column(
      children: list,
    );
  }

  Widget getImageButtonifExists() {
    if (widget.data.question.img != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            backgroundColor: Colors.white,
            onPressed: () {
              showDialog(
                context: context,
                builder: (builder) => Card(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              child: const Icon(Icons.close),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                        Expanded(
                          child: Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                "assets/${widget.data.question.img}",
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
            child: const Icon(Icons.image),
          ),
        ],
      );
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color:
          widget.data.isCorrect() ? Colors.green.shade200 : Colors.red.shade200,
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Icon(Icons.close),
              ),
            ],
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                  child: SizedBox(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
                      child: Center(
                        child: Text(
                          widget.data.question.text,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
                Card(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        getOption("A", widget.data.question.A),
                        getOption("B", widget.data.question.B),
                        getOption("C", widget.data.question.C),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
                  child: getFooter(),
                ),
                getImageButtonifExists(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
