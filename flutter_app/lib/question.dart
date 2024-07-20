import "package:flutter/material.dart";

class Question {
  String question, A, B, C, corretta, type, forType;
  dynamic provincia, risposta;

  Question(
      {required this.question,
      required this.A,
      required this.B,
      required this.C,
      required this.corretta,
      required this.forType,
      required this.type,
      this.provincia});
}

class QuestionCard extends StatefulWidget {
  final Question question;
  final Function(int n) onBtnPressed;

  const QuestionCard(
      {super.key, required this.question, required this.onBtnPressed});

  @override
  State<QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  bool isAnswered = false;
  Color? cardBgColor = Colors.grey[100];

  ButtonStyle getButtonStyle(String option) {
    Color bgColor = Colors.deepPurple;
    if (isAnswered == true) {
      bgColor = Colors.red;
      if (option == widget.question.corretta) {
        bgColor = Colors.green;
      }
    }
    return ElevatedButton.styleFrom(
      alignment: Alignment.center,
      minimumSize: const Size(88, 36),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(2)),
      ),
      backgroundColor: bgColor,
    );
  }

  @override
  void initState() {
    if (widget.question.risposta == null) {
      super.initState();
      return;
    }
    isAnswered = true;
    if (widget.question.corretta == widget.question.risposta) {
      cardBgColor = Colors.green[100];
    } else {
      cardBgColor = Colors.red[100];
    }
    super.initState();
  }

  void buttonPressed(String a) {
    if (isAnswered) {
      return;
    }
    setState(() {
      isAnswered = true;
      widget.question.risposta = a;
      if (widget.question.corretta == a) {
        widget.onBtnPressed(1);
        cardBgColor = Colors.green[100];
      } else {
        widget.onBtnPressed(-1);
        cardBgColor = Colors.red[100];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Card(
        color: cardBgColor,
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(16, 0, 16, 48),
                child: Text(
                  widget.question.question,
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                child: FilledButton(
                  style: getButtonStyle("A"),
                  onPressed: () {
                    buttonPressed("A");
                  },
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(4, 12, 4, 12),
                    child: Text(
                      widget.question.A,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                child: FilledButton(
                  style: getButtonStyle("B"),
                  onPressed: () {
                    buttonPressed("B");
                  },
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(4, 12, 4, 12),
                    child: Text(widget.question.B),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 16, 0, 64),
                child: FilledButton(
                  style: getButtonStyle("C"),
                  onPressed: () {
                    buttonPressed("C");
                  },
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(4, 12, 4, 12),
                    child: Text(widget.question.C),
                  ),
                ),
              ),
              Text(
                "${widget.question.forType} : ${widget.question.type}",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w200,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
