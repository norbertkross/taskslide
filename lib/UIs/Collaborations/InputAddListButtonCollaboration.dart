import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskslide/state/collaborationState.dart';

import '../../state/state.dart';

class InputAddListButtonCollaboration extends StatefulWidget {
  const InputAddListButtonCollaboration({
    Key key,
  }) : super(key: key);
  @override
  _InputAddListButtonCollaborationState createState() =>
      _InputAddListButtonCollaborationState();
}

class _InputAddListButtonCollaborationState
    extends State<InputAddListButtonCollaboration> {
  final taskState = Get.put(TaskState());
  final colllaborationState = Get.put(ColllaborationState());

  final TextEditingController controller = TextEditingController();
  String get input => controller.text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Container(
        key: UniqueKey(),
        child: Obx(
          () => Container(
            child: colllaborationState.showFrontInput.value == true
                ? Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Card(
                          shadowColor: Colors.transparent,
                          elevation: 20.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Container(
                            width: 200.0,
                            height: 40.0,
                            child: TextField(
                              onSubmitted: (String value) async{
                                String userid =await taskState
                                                        .getuserID();
                                if (input.trim().isNotEmpty) {
                                  print("VAL: $value   ---> $input");
                                  //taskState.callToAddParent(input);
                                  //taskState.getAndSetTaskValues(isInit: true);
                                  setState(() {
                                    DateTime dateTime = DateTime.now();

                                    colllaborationState.addNewProject(
                                      userid:userid ,
                                        name: input, time: dateTime.toString());
                                    colllaborationState
                                        .storeLocalValuesFromProjectHome();
                                    colllaborationState
                                        .showInputToCreateTask(false);
                                  });
                                  controller.clear();
                                }
                              },
                              controller: controller,
                              cursorColor: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(.5),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "New Project",
                                hintStyle: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context)
                                      .disabledColor
                                      .withOpacity(.3),
                                ),
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 8.0),
                              ),
                            ),
                          ),
                        ),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: ()async {
                                String userid =await taskState
                                                        .getuserID();
                              if (input.trim().isNotEmpty) {
                                //taskState.callToAddParent(input);
                                //taskState.getAndSetTaskValues(isInit: true);
                                setState(() {
                                  DateTime dateTime = DateTime.now();

                                  colllaborationState.addNewProject(
                                    userid: userid,
                                      name: input, time: dateTime.toString());
                                  colllaborationState
                                      .storeLocalValuesFromProjectHome();
                                  colllaborationState
                                      .showInputToCreateTask(false);
                                });
                                controller.clear();
                              }
                            },
                            child: Card(
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context)
                                      .primaryColor
                                      .withOpacity(.5),
                              shadowColor: Colors.transparent,
                              elevation: 20.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Container(
                                width: 80.0,
                                height: 35.0,
                                child: Center(
                                  child: Text(
                                    "Create",
                                    style: TextStyle(
                                      color: Theme.of(context).canvasColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            //setState(() {
                            // showFrontInput = false;
                            // generateList(taskList);
                            // });
                            //taskState.callToCloseParentAddition();
                            colllaborationState.showInputToCreateTask(false);
                          },
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: Container(
                              height: 35.0,
                              width: 30.0,
                              child: Icon(
                                Icons.close,
                                color: Theme.of(context).disabledColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : GestureDetector(
                    onTap: () {
                      // setState(() {
                      //     showFrontInput = true;
                      //     generateList(taskList);
                      // });
                      colllaborationState.showInputToCreateTask(true);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Tooltip(
                        message: "new project",
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: Card(
                            shadowColor:
                                Theme.of(context).primaryColor.withOpacity(.25),
                            //shadowColor: MediaQuery.of(context).size.width < 650.0?null:Colors.transparent,
                            elevation: MediaQuery.of(context).size.width < 650.0
                                ? 12.0
                                : 16.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Container(
                              width: MediaQuery.of(context).size.width < 650.0
                                  ? 60
                                  : 40.0,
                              height: MediaQuery.of(context).size.width < 650.0
                                  ? 50.0
                                  : 80.0,
                              child: Obx(
                                () => Icon(
                                  Icons.add,
                                  color: colllaborationState.themeMode.value ==
                                          true
                                      ? Theme.of(context).disabledColor
                                      : Colors.black.withOpacity(.4),
                                  size: 20.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
