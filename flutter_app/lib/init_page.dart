import "package:flutter/material.dart";
import "package:hive_flutter/adapters.dart";
import "question.dart";

class InitPage extends StatefulWidget {
  const InitPage({super.key});

  @override
  State<InitPage> createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  Widget messageWidget = const Text("Initializing...");

  @override
  void initState() {
    initApp().then((ret) {
      if (ret) {
        Navigator.pushNamedAndRemoveUntil(context, "/HomePage", (route) => false);
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
    await Hive.initFlutter();
    Box settingBox = await getBox("settingBox");
    Box questionBox = await getBox("questionBox");

    // Question q = Question(
    //     id: 1,
    //     num: "1",
    //     text: "text",
    //     A: "A",
    //     B: "B",
    //     C: "C",
    //     correct: "correct",
    //     forType: "forType",
    //     type: "type",
    //     date: "date",
    //     filename: "filename",
    //     line: "line");
    // questionBox.put(q.id, q);
    // q = Question(
    //     id: 2,
    //     num: "num",
    //     text: "text2",
    //     A: "A",
    //     B: "B",
    //     C: "C",
    //     correct: "correct",
    //     forType: "forType",
    //     type: "type",
    //     date: "date",
    //     filename: "filename",
    //     line: "line");
    // questionBox.put(q.id, q);
    return true;
  }

  /// returns a Hive Box Object by name
  /// if box doesn't exists it will be initialized
  Future<Box> getBox(String name) async {
    if (!Hive.isBoxOpen(name)) {
      return await Hive.openBox(name);
    }
    return Hive.box(name);
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
