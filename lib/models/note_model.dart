import 'package:flutter/material.dart';

class Note {
  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();
  String date = "2022-04-16 22:00";
  String color = "White";

  Note({
    String title = "",
    String body = "",
    this.date = "2022-04-16 22:00",
    this.color = "White",
  }) {
    titleController = TextEditingController(text: title);
    bodyController = TextEditingController(text: body);
  }

  factory Note.fromJson(Map<String, dynamic> json) => Note(
        title: json["title"],
        body: json["body"],
        color: json["color"],
        date: json["date"],
      );

  Map<String, dynamic> toJson() => {
        "title": titleController.text,
        "body": bodyController.text,
        "color": color,
        "date": date,
      };
}
