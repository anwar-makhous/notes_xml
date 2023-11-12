import 'package:flutter/material.dart';
import 'package:notes_xml/global/color_map.dart';
import 'package:notes_xml/logic/check_list_provider.dart';
import 'package:provider/provider.dart';

class CheckListScreen extends StatefulWidget {
  const CheckListScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<CheckListScreen> createState() => _CheckListScreenState();
}

class _CheckListScreenState extends State<CheckListScreen> {
  @override
  Widget build(BuildContext context) {
    final index = ModalRoute.of(context)!.settings.arguments as int;
    return Consumer<CheckListsProvider>(
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
                      color: getColor(
                        provider.checkList[index].color,
                      ),
                      size: 36,
                    ),
                  ),
                  items: myColors.keys
                      .map((e) => DropdownMenuItem<String>(
                            child: Text(e),
                            value: e,
                          ))
                      .toList(),
                  onChanged: (value) {
                    provider.checkList[index].color = value!;
                    provider.editing(index);
                  },
                ),
              ),
            ],
          ),
          backgroundColor: getColor(provider.checkList[index].color),
          resizeToAvoidBottomInset: true,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.025,
                  ),
                  TextFormField(
                    controller: provider.checkList[index].titleController,
                    textInputAction: TextInputAction.next,
                    cursorColor: Colors.black45,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    onChanged: (_) {
                      provider.editing(index);
                    },
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
                    child: ListView.builder(
                      itemCount: provider.checkList[index].body.length + 1,
                      itemBuilder: (context, itemIndex) => (itemIndex <
                              provider.checkList[index].body.length)
                          ? Row(
                              children: [
                                StatefulBuilder(
                                  builder: (context, setState) {
                                    return Checkbox(
                                      activeColor: Colors.green,
                                      checkColor: Colors.white,
                                      value: provider.checkList[index]
                                          .body[itemIndex].checked,
                                      onChanged: (value) {
                                        provider.checkList[index]
                                            .body[itemIndex].checked = value!;
                                        provider.editing(index);
                                      },
                                    );
                                  },
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * .7,
                                  child: TextFormField(
                                    controller: provider.checkList[index]
                                        .body[itemIndex].contentController,
                                    cursorColor: Colors.black45,
                                    onChanged: (_) {
                                      provider.editing(index);
                                    },
                                    decoration: const InputDecoration(
                                      hintText: "What do you need to do?",
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.black45,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    provider.checkList[index].body
                                        .removeAt(itemIndex);
                                    provider.editing(index);
                                  },
                                  icon: const Icon(
                                    Icons.clear,
                                    color: Colors.black45,
                                  ),
                                ),
                              ],
                            )
                          : GestureDetector(
                              onTap: () {
                                provider.addCheckItem(index);
                                debugPrint("List Item");
                              },
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add),
                                  Text(
                                    "New Item",
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              )),
                    ),
                  ),
                ],
              ),
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
                  child: Text("Last Edit On ${provider.checkList[index].date}"),
                ),
                IconButton(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * .025),
                  onPressed: () async {
                    provider.deleteCheckList(index);
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
