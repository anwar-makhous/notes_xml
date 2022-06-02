import 'package:flutter/material.dart';
import 'package:notes_xml/global/color_map.dart';
import 'package:notes_xml/logic/notes_provider.dart';
import 'package:provider/provider.dart';

class NotesTab extends StatefulWidget {
  const NotesTab({Key? key}) : super(key: key);

  @override
  State<NotesTab> createState() => _NotesTabState();
}

class _NotesTabState extends State<NotesTab> {
  @override
  Widget build(BuildContext context) {
    return Consumer<NotesProvider>(
      builder: (context, provider, child) {
        if (provider.notesList.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.note_add,
                    color: Colors.grey,
                    size: 100,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .05,
                  ),
                  const Text(
                    "Nothing yet\nCheck options to import XML backup\nOr click the add button to create new notes",
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }
        return GridView.builder(
          itemCount: provider.notesList.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: MediaQuery.of(context).size.height * .3,
          ),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, "/Notes", arguments: index);
              },
              child: Container(
                margin:
                    EdgeInsets.all(MediaQuery.of(context).size.width * .025),
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * .025),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  color: getColor(provider.notesList[index].color),
                  border: Border.all(width: 2, color: Colors.black54),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.0125,
                        bottom: 4,
                      ),
                      child: Text(
                        provider.notesList[index].titleController.text,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Text(
                      provider.notesList[index].bodyController.text.isEmpty
                          ? "Empty Note!"
                          : provider.notesList[index].bodyController.text,
                      textAlign:
                          provider.notesList[index].bodyController.text.isEmpty
                              ? TextAlign.center
                              : TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 7,
                      style: TextStyle(
                          fontSize: (provider.notesList[index].bodyController
                                      .text.length >=
                                  30)
                              ? 18
                              : 25),
                    ),
                    provider.notesList[index].bodyController.text.length >= 64
                        ? const Align(
                            child: Text("View Note..."),
                            alignment: Alignment.centerLeft,
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
