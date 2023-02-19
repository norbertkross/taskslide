import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reorderables/reorderables.dart';
import 'package:taskslide/state/collaborationState.dart';
import 'package:taskslide/state/state.dart';

class CollaborationTaskEditor extends StatefulWidget {
  const CollaborationTaskEditor({Key key}) : super(key: key);
  @override
  _CollaborationTaskEditorState createState() =>
      _CollaborationTaskEditorState();
}

class _CollaborationTaskEditorState extends State<CollaborationTaskEditor> {
// DECLARATIONS
  final taskState = Get.put(TaskState());
  final collaborationState = Get.put(ColllaborationState());
  double smallDevice = 650.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      taskState.closeTheMediumBar(value:false);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size mq = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          MediaQuery.of(context).size.width < smallDevice
              ? Container(
                  width: mq.width,
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).viewPadding.top),
                    child: Wrap(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            left: 12.0,
                            right: 12.0,
                          ),
                          child: SizedBox(
                            width: mq.width,
                            child: Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: GestureDetector(
                                    onTap: () {
                                      // taskState.switchPage(4);
                                      taskState.closeTheMediumBar();
                                    },
                                    child: RotatedBox(
                                      quarterTurns: 2,
                                      child: Icon(
                                          taskState.closeMediumBar.value ==
                                                  false
                                              ? Icons.chevron_left_rounded
                                              : Icons.chevron_right_rounded,
                                          size: 30,
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                  ),
                                ),
                                Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    
                                    IconButton(
                                        tooltip: "Theme",
                                        icon: Icon(
                                          Icons.brightness_6,
                                          size: 25,
                                          color:
                                              Theme.of(context).disabledColor,
                                        ),
                                        onPressed: () {
                                          taskState.setThemeMode();
                                        }),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    IconButton(
                                        tooltip: "People",
                                        icon: Icon(
                                          Icons.people,
                                          size: 27,
                                          color:
                                              Theme.of(context).disabledColor,
                                        ),
                                        onPressed: () {}),
                                    SizedBox(
                                      width: 12,
                                    ),
                                    Obx(
                                      () => (taskState.offlineMode.value ==
                                                  true) ||
                                              (taskState.currentHomePageIndex
                                                          .value ==
                                                      3 &&
                                                  collaborationState
                                                          .isEditing.value ==
                                                      true)
                                          ? Obx(
                                              () => Tooltip(
                                                message: taskState
                                                        .messageQue.isNotEmpty
                                                    ? "Save Project"
                                                    : "Already Saved",
                                                child: MouseRegion(
                                                  cursor:
                                                      SystemMouseCursors.click,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      if (taskState
                                                              .currentHomePageIndex
                                                              .value ==
                                                          3) {
                                                        /// You're editing a collaboration project
                                                        if (collaborationState
                                                                .isEditing
                                                                .value ==
                                                            true) {
                                                          /// The User is editing a collaborative project
                                                        } else {
                                                          /// The User is in collaboratione page but not editing a single task
                                                        }
                                                      } else if (taskState
                                                              .currentHomePageIndex
                                                              .value ==
                                                          0) {
                                                        /// You're editing a user project
                                                        if (taskState
                                                                .currentHomePageIndex
                                                                .value ==
                                                            0) {
                                                          // editing a single project item
                                                          //taskState.sendTaskToServer();
                                                        } else {
                                                          // in the homepage
                                                        }
                                                      }
                                                    },
                                                    child: Container(
                                                      child: Text(
                                                        "Save",
                                                        style: TextStyle(
                                                          color:
                                                              Theme.of(context)
                                                                  .cardColor,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 6,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        color: taskState
                                                                    .messageQue
                                                                    .length !=
                                                                0
                                                            ? Color(0xff5cdd41)
                                                            : Theme.of(context)
                                                                .disabledColor
                                                                .withOpacity(
                                                                    .1),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(3),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Container(),
                                    ),
                                    SizedBox(
                                      width: 16,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Row(
                  children: [
                    Container(
                      child: SizedBox(
                        width: mq.width,
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.start,
                          children: [
                            SizedBox(
                              width: 12,
                            ),
                            Tooltip(
                              message: "Home",
                              child: GestureDetector(
                                onTap: () {
                                  taskState.closeTheMediumBar();
                                  // collaborationState.swtichEditingMode(value: false);
                                },
                                child: MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: Obx(() => Icon(
                                        taskState.closeMediumBar.value == false
                                            ? Icons.chevron_left_rounded
                                            : Icons.chevron_right_rounded,
                                        size: 30,
                                        color: Theme.of(context).primaryColor,
                                      )),

                                  // Icon(Icons.arrow_back,
                                  //   size: 30,
                                  //   color: Theme.of(context).primaryColor,),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
          Flexible(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: MediaQuery.of(context).size.width < smallDevice
                    ? (mq.width < 350 ? mq.width + 100 : mq.width + 5)
                    : 1800.0,
                child: Stack(
                      children: [
                        ListView(
                          children: [
                            // Main List Body

                            Wrap(
                              alignment:
                                  mq.width < smallDevice && mq.width > 550.0
                                      ? WrapAlignment.center
                                      : WrapAlignment.start,
                              children: [
                                Container(
                                  child: GetBuilder<ColllaborationState>(
                                    builder: (builder) => ReorderableWrap(
                                        children:
                                            collaborationState.collabItems !=
                                                    null
                                                ? collaborationState.collabItems
                                                : (<Widget>[
                                                    Container(
                                                      key: UniqueKey(),
                                                    ),
                                                  ]),
                                        onReorder:
                                            collaborationState.setRedorder),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 30,
                            ),
                          ],
                        ),
                      ],
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
