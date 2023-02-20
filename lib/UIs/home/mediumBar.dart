import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskslide/state/state.dart';

import '../../state/collaborationState.dart';

class MediumBar extends StatefulWidget {
  @override
  _MediumBarState createState() => _MediumBarState();
}

class _MediumBarState extends State<MediumBar> {
  final colllaborationState = Get.put(ColllaborationState());
  final taskState = Get.put(TaskState());
  TextEditingController _controller = TextEditingController();
  String get inputText => _controller.text;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          SizedBox(
            height: 20.0,
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Your Projects",
              style: TextStyle(
                fontSize: 18.0,
                color: Theme.of(context).disabledColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Textfield for name
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              // height: 40.0,
              decoration: BoxDecoration(
                color: Theme.of(context).disabledColor.withOpacity(.06),
                borderRadius: BorderRadius.circular(
                  8.0,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    bottom: 0.0001, left: 4.0, right: 4.0),
                // padding: const EdgeInsets.only(bottom:12.0,left: 4.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0.0),
                        child: TextField(
                          controller: _controller,
                          onChanged: (String textValue) {
                            colllaborationState.searchForPattern(textValue);
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Search Project",
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Icon(Icons.search,
                          color: Theme.of(context)
                              .disabledColor
                              .withOpacity(.3)),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Projects List

          GetBuilder<ColllaborationState>(
              builder: (builder) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (int projects = 0;
                          projects <
                              (colllaborationState.searchableArray.isNotEmpty &&
                                      inputText.trim().isNotEmpty
                                  ? (colllaborationState
                                          .searchableArray.length)
                                  : (colllaborationState.collabAllTasks.length));
                          projects++)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: Obx(
                              () => GestureDetector(
                                onTap: () {
                                  if (colllaborationState.isSearching.value !=
                                      true) {
                                    debugPrint("HEER");
                                    colllaborationState
                                        .switchCurrentRunningProcess(projects);

                                    /// Join a socketio room when someone hits a collaboration room
                                    colllaborationState.joinTaskRoom();
                                  } else {
                                    int indexOfTask = colllaborationState
                                            .searchableArray[projects]
                                        ['task_real_index'];
                                    colllaborationState
                                        .switchCurrentRunningProcess(
                                            indexOfTask);

                                    /// Join a socketio room when someone hits a collaboration room
                                    colllaborationState.joinTaskRoom();
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color:colllaborationState.searchableArray.isNotEmpty &&
                                      inputText.trim().isNotEmpty? Theme.of(context).primaryColor : (colllaborationState
                                                .currentCollabRunningProjectId
                                                .value ==
                                            projects
                                        ? Theme.of(context).primaryColor
                                        : Theme.of(context)
                                            .primaryColor
                                            .withOpacity(.3)),
                                    borderRadius: BorderRadius.circular(
                                      8.0,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 0.0001, left: 4.0, right: 4.0),
                                    // padding: const EdgeInsets.only(bottom:12.0,left: 4.0),
                                    child: SizedBox(
                                       width: MediaQuery.of(context).size.width,                   

                                      child: Wrap(
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 5.0,
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(
                                                colllaborationState.searchableArray.isNotEmpty &&
                                                inputText.trim().isNotEmpty?
                                                "${colllaborationState.searchableArray[projects]["project-name"]}"
                                                :
                                                "${colllaborationState.collabAllTasks[projects]["project-name"]}",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  color:
                                                      Theme.of(context).cardColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  )),
        ],
      ),
    );
  }
}
