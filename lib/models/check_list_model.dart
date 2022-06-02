import 'package:flutter/cupertino.dart';

class CheckList {
  TextEditingController titleController = TextEditingController();
  List<CheckListItem> body = [];
  String date = "2022-04-16 22:00";
  String color = "White";

  CheckList(
      {String title = "",
      List<CheckListItem>? initialBody,
      this.date = "2022-04-16 22:00",
      this.color = "White"}) {
    titleController = TextEditingController(text: title);
    body = initialBody!;
  }
  factory CheckList.fromJson(Map<String, dynamic> jsonData) {
    return CheckList(
      title: jsonData["title"],
      initialBody: List<CheckListItem>.from(jsonData["body"].map((e) {
        return CheckListItem.fromJson(e);
      })),
      color: jsonData["color"],
      date: jsonData["date"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "title": titleController.text,
      "body": body.map((e) => e.toJson()).toList(),
      "color": color,
      "date": date,
    };
  }
}

class CheckListItem {
  TextEditingController contentController = TextEditingController();
  bool checked = false;

  CheckListItem({
    String content = "",
    this.checked = false,
  }) {
    contentController = TextEditingController(text: content);
  }

  factory CheckListItem.fromJson(Map<String, dynamic> json) => CheckListItem(
        content: json["content"],
        checked: json["checked"] == "true" ? true : false,
      );

  Map<String, dynamic> toJson() =>
      {"content": contentController.text, "checked": checked.toString()};
}
