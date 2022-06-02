import 'package:flutter/material.dart';
import 'package:notes_xml/global/color_map.dart';
import 'package:notes_xml/logic/notes_provider.dart';
import 'package:provider/provider.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  @override
  Widget build(BuildContext context) {
    final index = ModalRoute.of(context)!.settings.arguments as int;
    return Consumer<NotesProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            foregroundColor: Colors.black,
            backgroundColor: Colors.white,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: DropdownButton<String>(
                  hint: Container(
                    color: Colors.black12,
                    child: Icon(
                      Icons.color_lens,
                      color: getColor(provider.notesList[index].color),
                      size: 36,
                    ),
                  ),
                  items: myColors.keys
                      .map(
                        (e) => DropdownMenuItem<String>(
                          child: Text(e),
                          value: e,
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    provider.notesList[index].color = value!;
                    provider.editing(index);
                  },
                ),
              ),
            ],
          ),
          backgroundColor: getColor(provider.notesList[index].color),
          resizeToAvoidBottomInset: true,
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.025,
                ),
                TextFormField(
                  controller: provider.notesList[index].titleController,
                  textInputAction: TextInputAction.next,
                  cursorColor: Colors.black45,
                  textAlign: TextAlign.center,
                  onChanged: (_) {
                    provider.editing(index);
                  },
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    hintText: "title",
                    hintStyle: const TextStyle(fontWeight: FontWeight.w600),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
                    contentPadding: EdgeInsets.all(
                        MediaQuery.of(context).size.width * 0.025),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.025,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.55,
                  child: TextFormField(
                    controller: provider.notesList[index].bodyController,
                    cursorColor: Colors.black45,
                    maxLength: 10000,
                    maxLines: null,
                    minLines: null,
                    onChanged: (_) {
                      provider.editing(index);
                    },
                    decoration: InputDecoration(
                      hintText: "Your Note",
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.transparent,
                        ),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.transparent,
                        ),
                      ),
                      contentPadding: EdgeInsets.all(
                          MediaQuery.of(context).size.width * 0.025),
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: Container(
            height: MediaQuery.of(context).size.height * .1,
            alignment: Alignment.center,
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * .025),
                  child: Text("Last Edit On ${provider.notesList[index].date}"),
                ),
                IconButton(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * .025),
                  onPressed: () async {
                    provider.deleteNote(index);
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                    size: 36,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
