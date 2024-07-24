import "dart:convert";

import "package:flutter/material.dart";

class Question {
  static int currentId = 0;
  late int id = currentId;
  final String num, text, A, B, C, correct, forType, type, date, filename, line;
  dynamic provincia;

  Question(
      {required this.num,
      required this.text,
      required this.A,
      required this.B,
      required this.C,
      required this.correct,
      required this.forType,
      required this.type,
      required this.date,
      required this.filename,
      required this.line,
      dynamic id}) {
    if (id is int && id >= 0) {
      this.id = id;
    } else {
      this.id = currentId;
    }
    if (this.id == currentId) {
      currentId++;
      return;
    }
    if (this.id < currentId) {
      print(
          "Might have interfered with question ids. Crated id : $id, should be : $currentId");
    }
    if (this.id > currentId) {
      print(
          "Jumped currentId counter from $currentId to ${this.id + 1}. Created id : $id");
      currentId = this.id + 1;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "num": num,
      "text": text,
      "A": A,
      "B": B,
      "C": C,
      "correct": correct,
      "provincia": provincia,
      "forType": forType,
      "type": type,
      "date": date,
      "filename": filename,
      "line": line
    };
  }

  static Question fromMap(Map<String, dynamic> map) {
    return Question(
        num: map["num"],
        text: map["text"],
        A: map["A"],
        B: map["B"],
        C: map["C"],
        correct: map["correct"],
        forType: map["forType"],
        type: map["type"],
        date: map["date"],
        filename: map["filename"],
        line: map["line"],
        id: map["id"]);
  }

  static List<Map<String, dynamic>> toMapFromList(List<Question> questions) {
    List<Map<String, dynamic>> maps = questions.map((q) {
      return q.toMap();
    }).toList();
    return maps;
  }

  static List<Question> toListFromMap(List<Map<String, dynamic>> questions) {
    return questions.map((q) {
      return Question.fromMap(q);
    }).toList();
  }

  static List<Question> fromJSON(String json) {
    List<Map<String, dynamic>> maps = jsonDecode(json);
    return toListFromMap(maps);
  }

  static List<Question> filterQuestions(
      List<Question> questions, String key, String value) {
    List<Question> filteredQuestions = [];
    for (int i = 0; i < questions.length; i++) {
      Question q = questions[i];
      Map<String, dynamic> map = questions[i].toMap();
      if (map[key] != value) continue;
      filteredQuestions.add(q);
      questions.remove(q);
    }
    return filteredQuestions;
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
/// Question Card for QuizPage
class QuestionQuizCard extends StatefulWidget {
  final Question question;

  const QuestionQuizCard({required this.question, super.key});

  @override
  State<QuestionQuizCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionQuizCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Text("${widget.question.id}"),
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
