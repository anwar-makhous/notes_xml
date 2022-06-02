import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:notes_xml/global/color_map.dart';
import 'package:notes_xml/models/check_list_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckListsProvider with ChangeNotifier {
  List<CheckList> checkList = [];

  importList(List<CheckList> importedList) {
    checkList.addAll(importedList);
    saveProvider();
    notifyListeners();
  }

  saveProvider() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> temp = checkList.map((e) => json.encode(e.toJson())).toList();
    prefs.setStringList('Check-Lists', temp);
  }

  restoreProvider() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> temp = prefs.getStringList("Check-Lists") ?? List.empty();
    if (temp.isNotEmpty) {
      checkList = temp.map((e) => CheckList.fromJson(json.decode(e))).toList();
      notifyListeners();
    } else {
      notifyListeners();
    }
  }

  int createCheckList() {
    int randomColorIndex =
        Random(DateTime.now().microsecond).nextInt(myColors.length);
    checkList.add(CheckList(
      initialBody: [
        CheckListItem(content: "", checked: false),
      ],
      date: DateTime.now().toString().substring(0, 16),
      color: myColors.keys.elementAt(randomColorIndex),
    ));
    saveProvider();
    notifyListeners();
    return checkList.length - 1;
  }

  deleteCheckList(int index) async {
    await Future.delayed(const Duration(seconds: 1));
    checkList.removeAt(index);
    saveProvider();
    notifyListeners();
  }

  addCheckItem(int index) {
    checkList[index].body.add(CheckListItem(content: "", checked: false));
    editing(index);
  }

  editing(int index) {
    checkList[index].date = DateTime.now().toString().substring(0, 16);
    saveProvider();
    notifyListeners();
  }

  deleteAll() {
    checkList.clear();
    saveProvider();
    notifyListeners();
  }
}
