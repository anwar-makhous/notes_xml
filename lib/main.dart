import 'package:flutter/material.dart';
import 'package:notes_xml/logic/check_list_provider.dart';
import 'package:notes_xml/logic/notes_provider.dart';
import 'package:provider/provider.dart';
import '/screens/about_us_screen.dart';
import '/screens/check_list_screen.dart';
import '/screens/note_screen.dart';

import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<NotesProvider>(
          create: (context) => NotesProvider(),
        ),
        ChangeNotifierProvider<CheckListsProvider>(
          create: (context) => CheckListsProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'ADE XML Notes',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
        ),
        routes: {
          "/": (context) {
            Provider.of<NotesProvider>(context, listen: false)
                .restoreProvider();
            Provider.of<CheckListsProvider>(context, listen: false)
                .restoreProvider();
            return const HomeScreen(title: "ADE XML Notes");
          },
          "/AboutUs": (context) => const AboutUs(),
          "/Notes": (context) => const NoteScreen(title: "title"),
          "/CheckLists": (context) => const CheckListScreen(title: "title"),
        },
      ),
    );
  }
}
