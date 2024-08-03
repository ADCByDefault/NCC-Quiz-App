import "dart:async";

import "question.dart";
import 'question_manager.dart';
import "package:hive_flutter/hive_flutter.dart";

class DBSingleton {
  static dynamic db;
  late final Box dataBox;
  late final Box settingBox;
  List<Question> questions = Question.questions;

  DBSingleton._init(this.dataBox, this.settingBox) {
    db = this;
  }

  static Future<DBSingleton> getDB() async {
    if (db is DBSingleton) {
      return db;
    }
    await Hive.initFlutter();
    if (!Hive.isBoxOpen("dataBox")) {
      await Hive.openBox("dataBox");
    }
    if (!Hive.isBoxOpen("settingBox")) {
      await Hive.openBox("settingBox");
    }
    DBSingleton._init(Hive.box("dataBox"), Hive.box("settingBox"));
    return db;
  }

  Future<bool> addManagerToData(QuestionManager manager) async {
    bool isAdded = false;
    await setInitialized(false);
    List managers = getMappedManagers();
    managers.add(manager.toMap());
    await updateManagerList(managers);
    await setInitialized(true);
    return isAdded;
  }

  List<dynamic> getMappedManagers() {
    if (dataBox.get("managers") == null) {
      return [];
    }
    return dataBox.get("managers");
  }

  Future<bool> updateManagerList(List updatedList) async {
    await setInitialized(false);
    await dataBox.put("managers", updatedList);
    await setInitialized(true);
    return true;
  }

  Future<bool> updateQuestionList(
      List<Map<String, dynamic>> updatedList) async {
    await setInitialized(false);
    await dataBox.put("questions", updatedList);
    await setInitialized(true);
    return true;
  }

  bool getInitialized() {
    return (settingBox.get("isInitialized") == 1) ? true : false;
  }

  Future<bool> setInitialized(bool value) async {
    int v = value ? 1 : 0;
    await settingBox.put("isInitialized", v);
    return getInitialized();
  }
}
