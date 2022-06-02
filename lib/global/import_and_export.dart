import 'dart:io';
// com.example.notes_xml
import 'package:external_path/external_path.dart';
import 'package:flutter/cupertino.dart';
import 'package:notes_xml/logic/check_list_provider.dart';
import 'package:notes_xml/logic/notes_provider.dart';
import 'package:notes_xml/models/check_list_model.dart';
import 'package:notes_xml/models/note_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:xml/xml.dart';
import 'package:file_picker/file_picker.dart';

Future<String> exportToXML(BuildContext context) async {
  List<Note> notesList =
      Provider.of<NotesProvider>(context, listen: false).notesList;
  List<CheckList> checkList =
      Provider.of<CheckListsProvider>(context, listen: false).checkList;
  final xmlNotesBuilder = XmlBuilder();
  xmlNotesBuilder.processing('xml', 'version="1.0" encoding="utf-8"');
  xmlNotesBuilder.element("notes", nest: () {
    for (int i = 0; i < notesList.length; i++) {
      xmlNotesBuilder.element('note', nest: () {
        xmlNotesBuilder.attribute("type", "text");
        xmlNotesBuilder.element('title',
            nest: notesList[i].titleController.text);
        xmlNotesBuilder.element('body', nest: notesList[i].bodyController.text);
        xmlNotesBuilder.element('color', nest: notesList[i].color);
        xmlNotesBuilder.element('date', nest: notesList[i].date);
      });
    }
    for (int noteIndex = 0; noteIndex < checkList.length; noteIndex++) {
      xmlNotesBuilder.element('note', nest: () {
        xmlNotesBuilder.attribute("type", "check-list");
        xmlNotesBuilder.element('title',
            nest: checkList[noteIndex].titleController.text);
        xmlNotesBuilder.element('body', nest: () {
          for (int itemIndex = 0;
              itemIndex < checkList[noteIndex].body.length;
              itemIndex++) {
            xmlNotesBuilder.element("check-list-item", nest: () {
              xmlNotesBuilder.element("content",
                  nest: checkList[noteIndex]
                      .body[itemIndex]
                      .contentController
                      .text);
              xmlNotesBuilder.element("checked",
                  nest:
                      checkList[noteIndex].body[itemIndex].checked.toString());
            });
          }
        });
        xmlNotesBuilder.element('color', nest: checkList[noteIndex].color);
        xmlNotesBuilder.element('date', nest: checkList[noteIndex].date);
      });
    }
  });
  final xmlBackup =
      xmlNotesBuilder.buildDocument().toXmlString(pretty: true, indent: '\t');
  final directory = Directory(
      await ExternalPath.getExternalStoragePublicDirectory(
              ExternalPath.DIRECTORY_DOWNLOADS)
          .then((path) => path.replaceAll("Download", "ADE_XML_Notes")));
  var status = await Permission.storage.status;
  if (!status.isGranted) {
    await Permission.storage.request();
  }
  if ((!await directory.exists())) {
    directory.create();
  }
  String fileName =
      'notes_xml_backup_${DateTime.now().toString().substring(0, 19).replaceAll(" ", "").replaceAll("-", "").replaceAll(":", "")}.xml';
  final File file = File('${directory.path}/$fileName');
  await file.writeAsString(xmlBackup);
  return directory.path;
}

// Future<bool>
importFromXML(BuildContext context) async {
  var status = await Permission.storage.status;
  if (!status.isGranted) {
    await Permission.storage.request();
  }
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['xml'],
    allowMultiple: false,
  );

  if (result != null) {
    File file = File(result.files.single.path!);
    XmlDocument xmlDocument = XmlDocument.parse(await file.readAsString());
    List<XmlElement> xmlNotesList = [];
    List<XmlElement> xmlCheckList = [];
    List<XmlElement> notes = xmlDocument.findAllElements("note").toList();
    for (int index = 0; index < notes.length; index++) {
      if (notes[index].getAttribute("type") == "text") {
        xmlNotesList.add(notes[index]);
      } else {
        xmlCheckList.add(notes[index]);
      }
    }
    List<Note> notesList = xmlNotesList
        .map(
          (e) => Note(
            title: e.getElement("title")!.text,
            body: e.getElement("body")!.text,
            color: e.getElement("color")!.text,
            date: e.getElement("date")!.text,
          ),
        )
        .toList();
    Provider.of<NotesProvider>(context, listen: false).importList(notesList);
    List<CheckList> checkList = xmlCheckList
        .map(
          (e) => CheckList(
            title: e.getElement("title")!.text,
            initialBody: e
                .getElement("body")!
                .findAllElements("check-list-item")
                .map((item) => CheckListItem(
                      content: item.getElement("content")!.text,
                      checked: item.getElement("checked")!.text == "true"
                          ? true
                          : false,
                    ))
                .toList(),
            color: e.getElement("color")!.text,
            date: e.getElement("date")!.text,
          ),
        )
        .toList();
    Provider.of<CheckListsProvider>(context, listen: false)
        .importList(checkList);
  }
}
