import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "question.dart";

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: Container(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Filters(),
            StartQuiz(),
          ],
        ),
      ),
    );
  }
}

class StartQuiz extends StatelessWidget {
  const StartQuiz({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Text("Start Quiz"),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, "/QuizPage", (route) => false);
            },
            child: const Icon(Icons.play_arrow),
          ),
        ],
      ),
    );
  }
}

class Filters extends StatefulWidget {
  const Filters({super.key});

  @override
  State<Filters> createState() => _FiltersState();
}

class _FiltersState extends State<Filters> {
  Map<String, List<Map>> toCheckbox = {};

  @override
  void initState() {
    toCheckbox = {
      "type": mapFilterOptions("type", exceptions: [
        {"name": "parte_normativa", "state": true, "num": 30},
      ]),
      "forType": mapFilterOptions("forType", exceptions: [
        {"name": "autovetture", "state": true, "num": 10},
      ]),
      "provincia": mapFilterOptions("provincia", exceptions: [
        {"name": "FIRENZE", "state": true, "num": 10},
      ]),
    };
    super.initState();
  }

  List<Map> mapFilterOptions(String parent, {List exceptions = const []}) {
    List list = Question.getAllPossibleValuesOf(parent);
    List<Map> mapList = [];
    for (int i = 0; i < list.length; i++) {
      int num = 10;
      bool state = false;
      exceptions.any((e) {
        if (e["name"] != list[i]) {
          return false;
        }
        num = e["num"] ?? 10;
        state = e["state"] ?? false;
        return true;
      });
      mapList.add({
        "name": list[i],
        "state": state,
        "num": num,
      });
    }
    return mapList;
  }

  void checkBoxClicked(String parent, String element, int index) {
    if (!toCheckbox.containsKey(parent)) {
      return;
    }
    List<dynamic> list = toCheckbox[parent]!;
    bool isOnlyTrue = !list.any((e) => e["state"] && !(e["name"] == element));
    if (isOnlyTrue) {
      return;
    }
    list[index]["state"] = !list[index]["state"];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [BoxShadow(color: Colors.black87, blurRadius: 5)],
        borderRadius: BorderRadius.all(Radius.circular(5)),
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        height: 200,
        child: Container(
          padding: const EdgeInsets.all(0),
          child: ListView.builder(
            itemBuilder: (context, i) {
              var key = toCheckbox.keys.toList()[i];
              List mapList = toCheckbox[key]!;
              List<Widget> widgets = [];
              for (int j = 0; j < mapList.length; j++) {
                widgets.add(FilterCheckBox(
                    values: mapList[j],
                    onClicked: () {
                      checkBoxClicked(key, "${mapList[j]["name"]}", j);
                    }));
              }

              widgets.add(const Divider(
                height: 20,
              ));
              return Column(
                children: widgets,
              );
            },
            itemCount: toCheckbox.length,
          ),
        ),
      ),
    );
  }
}

class FilterCheckBox extends StatefulWidget {
  final Map values;
  final Function onClicked;

  const FilterCheckBox(
      {super.key, required this.values, required this.onClicked});

  @override
  State<FilterCheckBox> createState() => _FilterCheckBoxState();
}

class _FilterCheckBoxState extends State<FilterCheckBox> {
  late TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController(text: "${widget.values["num"]}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Row(
        children: [
          Text("${widget.values["name"]}"),
          Expanded(
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: TextField(
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  CustomRangeTextInputFormatter(),
                ],
                controller: controller,
                onChanged: (n) {
                  int newNum = int.parse(n);
                  widget.values["num"] = newNum;
                },
                keyboardType: TextInputType.number,
              ),
            ),
          ),
          Checkbox( onChanged: (value){
            setState(() {
              widget.onClicked();
            });
          }, value: widget.values["state"],),
        ],
      ),
    );
  }
}

class CustomRangeTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text == '') {
      return const TextEditingValue();
    }
    if (int.parse(newValue.text) < 1) {
      return const TextEditingValue().copyWith(text: '1');
    }

    return int.parse(newValue.text) > 20
        ? const TextEditingValue().copyWith(text: '20')
        : newValue;
  }
}
