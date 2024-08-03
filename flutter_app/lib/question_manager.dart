import 'question.dart';

class QuestionManager {
  static List<QuestionManager> managers = [];
  late List<Data> questionsData;
  DateTime createdAt = DateTime.now();

  QuestionManager({required this.questionsData, required this.createdAt}) {
    managers.add(this);
  }

  QuestionManager.fromList(List<Question> questions) {
    questionsData = questions.map((q) => Data(question: q)).toList();
  }

  Map<String, dynamic> toMap() {
    return {"createdAt": createdAt.millisecondsSinceEpoch, "data": mapData()};
  }

  List<Map<String, dynamic>> mapData() {
    return questionsData.map((data) => data.toMap()).toList();
  }

  static QuestionManager fromMap(Map<String, dynamic> map) {
    DateTime createdAt = map["createdAt"];
    List<Data> data = map["data"].map((map) => Data.fromMap(map)).toList();
    return QuestionManager(questionsData: data, createdAt: createdAt);
  }

  Data? getQuestionData(Question question) {
    for (Data d in questionsData) {
      if (d.question == question) {
        return d;
      }
    }
    return null;
  }

  List<QuestionCard> getCards(Function(Data data) onClick) {
    List<QuestionCard> cards = [];
    for (Data data in questionsData) {
      cards.add(QuestionCard(
        data: data,
        onClick: onClick,
      ));
    }
    return cards;
  }

  int getLength() {
    return questionsData.length;
  }

  int getCorrect() {
    int count = 0;
    for (Data data in questionsData) {
      if (data.isCorrect()) {
        count++;
      }
    }
    return count;
  }

  int getIncorrect() {
    int count = 0;
    for (Data data in questionsData) {
      if (!data.isCorrect()) {
        count++;
      }
    }
    return count;
  }

  bool isPassed() {
    if (getIncorrect() > (getLength() * 0.1)) {
      return false;
    }
    return true;
  }

  int getIndex(Data data) {
    for (int i = 0; i < getLength(); i++) {
      if (questionsData[i] == data) {
        return i;
      }
    }
    return -1;
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
class Data {
  Question question;
  String selected = "";

  Data({required this.question});

  bool isAnswered() {
    if (["A", "B", "C"].contains(selected)) {
      return true;
    }
    return false;
  }

  bool isCorrect() {
    if (selected == question.correct) {
      return true;
    }
    return false;
  }

  Map<String, dynamic> toMap() {
    return {
      "questionId": question.id,
      "selected": selected,
    };
  }

  static Data fromMap(Map<String, dynamic> map) {
    Data data = Data(question: Question.getById(map["questionId"]));
    data.selected = map["selected"];
    return data;
  }
}
