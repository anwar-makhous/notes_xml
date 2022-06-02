import 'package:flutter/material.dart';
import 'package:notes_xml/global/import_and_export.dart';
import 'package:notes_xml/logic/check_list_provider.dart';
import 'package:notes_xml/logic/notes_provider.dart';
import 'package:notes_xml/widgets/check_list_tab.dart';
import 'package:notes_xml/widgets/notes_tab.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.title}) : super(key: key);

  final String title;
  static bool isLoading = false;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: HomeScreen.isLoading
          ? Container(
              color: Colors.white,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Scaffold(
              appBar: AppBar(
                title: Text(widget.title),
                centerTitle: true,
                actions: [
                  PopupMenuButton(
                    child: const Icon(
                      Icons.more_vert,
                      color: Colors.white,
                      size: 30,
                    ),
                    onSelected: (value) {
                      switch (value) {
                        case "Delete All":
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    actions: [
                                      TextButton(
                                        child: const Text("Yes"),
                                        onPressed: () {
                                          Provider.of<NotesProvider>(context,
                                                  listen: false)
                                              .deleteAll();
                                          Provider.of<CheckListsProvider>(
                                                  context,
                                                  listen: false)
                                              .deleteAll();
                                          Navigator.pop(context);
                                        },
                                      ),
                                      TextButton(
                                        child: const Text("Cancel"),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                    content: const Text(
                                        "Are you sure you want to delete all your notes and check-lists?"),
                                    title: const Text("Delete all"),
                                  ));
                          break;
                        case "Import":
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    actions: [
                                      TextButton(
                                        child: const Text("Choose file"),
                                        onPressed: () async {
                                          await importFromXML(context);
                                          Navigator.pop(context);
                                        },
                                      ),
                                      TextButton(
                                        child: const Text("Cancel"),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                    content: const Text(
                                        "Please choose .xml file to import backup"),
                                    title: const Text("Import from XML"),
                                  ));
                          break;
                        case "Export":
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    actions: [
                                      TextButton(
                                        child: const Text("Yes"),
                                        onPressed: () async {
                                          Navigator.pop(context);
                                          String backupPath =
                                              await exportToXML(context);
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text("OK"),
                                                ),
                                              ],
                                              content: Text(
                                                "Saved Successfully to $backupPath/",
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      TextButton(
                                        child: const Text("No"),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                    content: const Text(
                                        "Export your notes and check-lists to .xml backup file?"),
                                    title: const Text("Export to XML"),
                                  ));
                          break;
                        case "About Us":
                          Navigator.pushNamed(context, "/AboutUs");
                          break;
                        default:
                          debugPrint("Default Reached");
                          break;
                      }
                    },
                    itemBuilder: (context) {
                      return const [
                        PopupMenuItem(
                          value: "Import",
                          child: Text("Import from XML"),
                        ),
                        PopupMenuItem(
                          value: "Export",
                          child: Text("Export to XML"),
                        ),
                        PopupMenuItem(
                          value: "Delete All",
                          child: Text("Delete all"),
                        ),
                        PopupMenuItem(
                          value: "About Us",
                          child: Text("About Us"),
                        ),
                      ];
                    },
                  ),
                ],
                bottom: const TabBar(
                  indicatorWeight: 5,
                  labelPadding: EdgeInsets.all(8.0),
                  tabs: [
                    Text("Notes"),
                    Text("Check-Lists"),
                  ],
                ),
              ),
              body: const TabBarView(
                children: [NotesTab(), CheckListTab()],
              ),
              floatingActionButton: FloatingActionButton(
                child: PopupMenuButton(
                  color: Colors.deepOrange,
                  icon: const Icon(Icons.add),
                  padding: EdgeInsets.zero,
                  offset: Offset(-MediaQuery.of(context).size.width * .1,
                      -MediaQuery.of(context).size.height * .16),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(60),
                      topRight: Radius.circular(60),
                    ),
                  ),
                  onSelected: (value) {
                    switch (value) {
                      case "Note":
                        int index =
                            Provider.of<NotesProvider>(context, listen: false)
                                .createNote();
                        Navigator.pushNamed(context, "/Notes",
                            arguments: index);
                        break;
                      case "Check List":
                        int index = Provider.of<CheckListsProvider>(context,
                                listen: false)
                            .createCheckList();
                        Navigator.pushNamed(context, "/CheckLists",
                            arguments: index);
                        break;
                    }
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "New Note",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      value: "Note",
                      padding: EdgeInsets.all(16),
                    ),
                    PopupMenuItem(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "New Check-List",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      value: "Check List",
                      padding: EdgeInsets.all(16),
                    ),
                  ],
                ),
                onPressed: null,
              ),
            ),
    );
  }
}
