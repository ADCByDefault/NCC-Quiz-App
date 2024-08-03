import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "question.dart";
import "db_singleton.dart";

class InitPage extends StatefulWidget {
  const InitPage({super.key});

  @override
  State<InitPage> createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  Widget messageWidget = const CircularProgressIndicator(
    color: Colors.green,
  );

  @override
  void initState() {
    initApp().then((ret) {
      if (ret) {
        Navigator.pushNamedAndRemoveUntil(
            context, "/HomePage", (route) => false);
      } else {
        setState(() {
          messageWidget = const Text(
            "Cannot Initialize",
            style: TextStyle(color: Colors.red),
          );
        });
      }
    });
    super.initState();
  }

  Future<bool> initApp() async {
    Question(
        num: "null",
        text: "null",
        A: "null",
        B: "null",
        C: "null",
        correct: "null",
        forType: "null",
        type: "null",
        provincia: "null",
        date: "null",
        filename: "null",
        line: "null",
        id: -1);
    DBSingleton db = await DBSingleton.getDB();
    if (!db.getInitialized()) {
      String json = await rootBundle.loadString("assets/data.json");
      List<Map<String, dynamic>> mapped =
          Question.toMapFromList(Question.fromJSON(json));
      await db.updateQuestionList(mapped);
      await db.setInitialized(true);
    } else {
      List mapped = db.dataBox.get("questions");
      Question.toListFromMap(mapped);
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      body: Center(
        child: messageWidget,
      ),
    ));
  }
}
