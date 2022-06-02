import 'package:flutter/material.dart';
import 'package:notes_xml/global/color_map.dart';
import 'package:notes_xml/logic/check_list_provider.dart';
import 'package:provider/provider.dart';

class CheckListTab extends StatefulWidget {
  const CheckListTab({Key? key}) : super(key: key);

  @override
  State<CheckListTab> createState() => _CheckListTabState();
}

class _CheckListTabState extends State<CheckListTab> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CheckListsProvider>(
      builder: (context, provider, child) {
        if (provider.checkList.isEmpty) {
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
                    "Nothing yet\nCheck options to import XML backup\nOr click the add button to create new check-lists",
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
          itemCount: provider.checkList.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: MediaQuery.of(context).size.height * .3,
          ),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, "/CheckLists", arguments: index);
              },
              child: Container(
                margin:
                    EdgeInsets.all(MediaQuery.of(context).size.width * .025),
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * .025),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  color: getColor(provider.checkList[index].color),
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
                        provider.checkList[index].titleController.text,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    if (provider.checkList[index].body.isEmpty ||
                        (provider.checkList[index].body.length == 1 &&
                            provider.checkList[index].body.first
                                .contentController.text.isEmpty))
                      const Text(
                        "Empty Checklist!",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 25),
                      ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: provider.checkList[index].body.length <= 3
                          ? provider.checkList[index].body.length
                          : 3,
                      itemBuilder: (context, itemIndex) {
                        return Row(
                          children: [
                            Checkbox(
                              activeColor: Colors.green,
                              checkColor: Colors.white,
                              value: provider
                                  .checkList[index].body[itemIndex].checked,
                              onChanged: (value) {},
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .25,
                              child: Text(
                                provider.checkList[index].body[itemIndex]
                                    .contentController.text,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    provider.checkList[index].body.length > 3
                        ? Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "+${provider.checkList[index].body.length - 3} More....",
                            ),
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
