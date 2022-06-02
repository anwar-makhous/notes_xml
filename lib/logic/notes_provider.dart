import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:notes_xml/global/color_map.dart';
import 'package:notes_xml/models/note_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotesProvider with ChangeNotifier {
  List<Note> notesList = [];

  importList(List<Note> importedList) {
    notesList.addAll(importedList);
    saveProvider();
    notifyListeners();
  }

  saveProvider() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> temp = notesList.map((e) => json.encode(e.toJson())).toList();
    prefs.setStringList('Notes', temp);
  }

  restoreProvider() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> temp = prefs.getStringList("Notes") ?? List.empty();
    if (temp.isNotEmpty) {
      notesList = temp.map((e) => Note.fromJson(json.decode(e))).toList();
      notifyListeners();
    } else {
      notifyListeners();
    }
  }

  int createNote() {
    int randomColorIndex =
        Random(DateTime.now().microsecond).nextInt(myColors.length);
    notesList.add(Note(
      date: DateTime.now().toString().substring(0, 16),
      color: myColors.keys.elementAt(randomColorIndex),
    ));
    saveProvider();
    notifyListeners();
    return notesList.length - 1;
  }

  deleteNote(int index) async {
    await Future.delayed(const Duration(seconds: 1));
    notesList.removeAt(index);
    saveProvider();
    notifyListeners();
  }

  editing(int index) {
    notesList[index].date = DateTime.now().toString().substring(0, 16);
    saveProvider();
    notifyListeners();
  }

  deleteAll() {
    notesList.clear();
    saveProvider();
    notifyListeners();
  }
}
