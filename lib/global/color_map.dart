import 'package:flutter/material.dart';

const Map<String, Color> myColors = {
  "Red": Colors.red,
  "Green": Colors.green,
  "Blue": Colors.blue,
  "Yellow": Colors.yellow,
  "Orange": Colors.deepOrange,
  "Pink": Colors.pink,
  "Grey": Colors.grey,
  "White": Colors.white,
};

Color getColor(String color) {
  return myColors[color] ?? Colors.white;
}
