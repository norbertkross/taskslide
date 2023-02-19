import 'package:async_loader/async_loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskslide/UIs/Collaborations/CollaborationTaskEditor.dart';
import 'package:taskslide/UIs/CreatedProjectsHome/editProjectTitle.dart';
import 'package:taskslide/state/collaborationState.dart';
import 'package:taskslide/state/state.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'InputAddListButtonCollaboration.dart';

class Collaborations extends StatefulWidget {
  @override
  _CollaborationsState createState() => _CollaborationsState();
}

class _CollaborationsState extends State<Collaborations> {
  final GlobalKey<AsyncLoaderState> _asyncLoaderState =
      GlobalKey<AsyncLoaderState>();
  double gridItemWidth = 200.0;
  int currentHover = -1;
  double smallDevice = 650.0;
  bool showBuilder = true;

  final colllaborationState = Get.put(ColllaborationState());
  final taskState = Get.put(TaskState());

  String giveTime(int index) {
    return timeago.format(
      DateTime.parse(colllaborationState.collabAllTasks[index]["date-time"]),
      //locale: "en_short",
    );
  }

  dateTimeRangePicker(int index) async {
    DateTimeRange picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 2),
      lastDate: DateTime(DateTime.now().year + 10),
      initialDateRange: DateTimeRange(
        start: DateTime.now(),
        end: DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day + 3),
      ),
    );

    if (picked != null) {
      colllaborationState.setDateRange(index,
          start: "${picked.start}", end: "${picked.end}");
    }
  }

  @override
  Widget build(BuildContext context) {
    Size mq = MediaQuery.of(context).size;
    return Scaffold(
      //backgroundColor: Color(0xffF4F5F7),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: mq.width < smallDevice ? (mq.width + 200) : 1800.0,
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (__) {
              __.disallowIndicator();
              return false;
            },
            child: Obx(
              () => colllaborationState.isEditing.value == false
                  ? ListView(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              children: [
                                showBuilder == true
                                    ? AsyncLoader(
                                        key: _asyncLoaderState,
                                        // Show error widget when there's  an error
                                        renderError: ([error]) => Container(
                                              child: SizedBox(
                                                width: mq.width,
                                                child: Column(
                                                  children: [
                                                    Wrap(
                                                      alignment:
                                                          WrapAlignment.center,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 40),
                                                          child: Text(
                                                            "There was an error please\ncheck your network and\ntry again",
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Wrap(
                                                        alignment: WrapAlignment
                                                            .center,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 14.0),
                                                            child: Tooltip(
                                                              message: "Retry",
                                                              child:
                                                                  MouseRegion(
                                                                cursor:
                                                                    SystemMouseCursors
                                                                        .click,
                                                                child:
                                                                    GestureDetector(
                                                                  onTap: () {
                                                                    //  setState((){ });
                                                                    _asyncLoaderState
                                                                        .currentState
                                                                        .reloadState()
                                                                        .whenComplete(() =>
                                                                            print('finished reload'));
                                                                  },
                                                                  child: Card(
                                                                    elevation:
                                                                        30,
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              16.0),
                                                                    ),
                                                                    color: Theme.of(
                                                                            context)
                                                                        .primaryColor,
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                              .symmetric(
                                                                          horizontal:
                                                                              12.0,
                                                                          vertical:
                                                                              4),
                                                                      child:
                                                                          Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.min,
                                                                        children: [
                                                                          Text(
                                                                            "Retry",
                                                                            style:
                                                                                TextStyle(
                                                                              color: Theme.of(context).cardColor,
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                6,
                                                                          ),
                                                                          RotatedBox(
                                                                              quarterTurns: 3,
                                                                              child: Icon(
                                                                                Icons.refresh_rounded,
                                                                                color: Theme.of(context).cardColor,
                                                                                size: 22,
                                                                              ))
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        ]),
                                                  ],
                                                ),
                                              ),
                                            ),

                                        // Show loader whille data is loading
                                        renderLoad: () => Container(
                                              child: SizedBox(
                                                width: mq.width,
                                                child: Wrap(
                                                  alignment:
                                                      WrapAlignment.center,
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 40),
                                                      child:
                                                           CupertinoActivityIndicator(
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                                radius: 17,
                                                              ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                        initState: () async =>
                                            await colllaborationState
                                                .getCollaborationsStream(
                                                    email: await taskState
                                                        .getuserID()),
                                        renderSuccess: ({data}) {
                                          if (data.length > 0) {
                                            return GetBuilder<ColllaborationState>(
                                    builder: (builder) => Wrap(
                                              children: [
                                    //             GetBuilder<ColllaborationState>(
                                    // builder: (builder) =>)
                                                for (int projectsIndex = 0;
                                                    projectsIndex <=
                                                        colllaborationState
                                                                .collabAllTasks
                                                                .length -
                                                            1;
                                                    projectsIndex++)
                                                  taskItem(
                                                      projectsIndex:
                                                          projectsIndex),
                                                Wrap(
                                                  children: [
                                                    Obx(
                                                      () => colllaborationState
                                                                  .addingNewProjectToServerIndicator
                                                                  .value ==
                                                              true
                                                          ? Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top:
                                                                          20.0),
                                                              child:
                                                                  CupertinoActivityIndicator(
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                                radius: 16,
                                                              ),
                                                            )
                                                          : SizedBox(),
                                                    ),
                                                    InputAddListButtonCollaboration(),
                                                  ],
                                                ),
                                              ],
                                            ));
                                          } else if (data.length == 0) {
                                            return Container(
                                              child: SizedBox(
                                                width: mq.width,
                                                child: Column(
                                                  children: [
                                                    Wrap(
                                                      alignment:
                                                          WrapAlignment.center,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 40),
                                                          child: Text(
                                                            "You're currently not part of any project",
                                                            style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Wrap(
                                                        alignment: WrapAlignment
                                                            .center,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 14.0),
                                                            child: Tooltip(
                                                              message: "Retry",
                                                              child:
                                                                  MouseRegion(
                                                                cursor:
                                                                    SystemMouseCursors
                                                                        .click,
                                                                child:
                                                                    GestureDetector(
                                                                  onTap: () {
                                                                    //  setState((){ });
                                                                    _asyncLoaderState
                                                                        .currentState
                                                                        .reloadState()
                                                                        .whenComplete(() =>
                                                                            print('finished reload'));
                                                                  },
                                                                  child: Card(
                                                                    elevation:
                                                                        30,
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              16.0),
                                                                    ),
                                                                    color: Theme.of(
                                                                            context)
                                                                        .primaryColor,
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                              .symmetric(
                                                                          horizontal:
                                                                              12.0,
                                                                          vertical:
                                                                              4),
                                                                      child:
                                                                          Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.min,
                                                                        children: [
                                                                          Text(
                                                                            "Retry",
                                                                            style:
                                                                                TextStyle(
                                                                              color: Theme.of(context).cardColor,
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                6,
                                                                          ),
                                                                          RotatedBox(
                                                                              quarterTurns: 3,
                                                                              child: Icon(
                                                                                Icons.refresh_rounded,
                                                                                color: Theme.of(context).cardColor,
                                                                                size: 22,
                                                                              ))
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        ])
                                                  ],
                                                ),
                                              ),
                                            );
                                          } else {
                                            return Container(
                                              child: SizedBox(
                                                width: mq.width < smallDevice
                                                    ? (mq.width + 200)
                                                    : 1800.0,
                                                child: Wrap(
                                                  alignment:
                                                      WrapAlignment.start,
                                                  children: [
                                                    Text(
                                                      "There Was an error",
                                                      style: TextStyle(
                                                          color: Colors.red,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }
                                        })
                                    : Container(),
                              ],
                            ),
                          ],
                        ),
                      ],
                    )
                  : CollaborationTaskEditor(),
            ),
          ),
        ),
      ),
    );
  }

  Widget taskItem({int projectsIndex}) {
    return Padding(
      padding: EdgeInsets.only(
        top: 8.0,
        left: currentHover == projectsIndex ? 12.0 : 8.0,
        bottom: 8.0,
        right: 8.0,
      ),
      child: MouseRegion(
        onEnter: (_) {
          //setState(() {
          // currentHover = projectsIndex;
          //});
        },
        onExit: (_) {
          // setState(() {
          //   currentHover = -1;
          // });
        },
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            colllaborationState.switchCurrentRunningProcess(projectsIndex);
            // taskState.switchPage(0);
            colllaborationState.swtichEditingMode();

            /// Join a socketio room when someone hits a collaboration room
            colllaborationState.joinTaskRoom();
          },
          child: Card(
            shadowColor: currentHover == projectsIndex
                ? Theme.of(context).primaryColor.withOpacity(.2)
                : Colors.transparent,
            elevation: 20.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6.0),
            ),
            child: Container(
              width: gridItemWidth,
              child: Column(
                children: [
                  SizedBox(
                    width: gridItemWidth,
                    child: Wrap(
                      alignment: WrapAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: gridItemWidth,
                                child: Wrap(
                                  alignment: WrapAlignment.end,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        taskState.buildEditDialog(
                                          context,
                                          child: EditProjectTitle(
                                            index: projectsIndex,
                                            title:
                                                "${colllaborationState.collabAllTasks[projectsIndex]["project-name"]}",
                                          ),
                                        );
                                      },
                                      child: Tooltip(
                                        message: "Edit title",
                                        child: MouseRegion(
                                          cursor: SystemMouseCursors.click,
                                          child: Icon(Icons.edit,
                                              size: 18.0,
                                              color: Theme.of(context)
                                                  .disabledColor
                                                  .withOpacity(.2)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                "${colllaborationState.collabAllTasks[projectsIndex]["project-name"]}",
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .disabledColor
                                      .withOpacity(.6),
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                //${taskState.allTasks[projectsIndex]["project-body"].length}
                                child: Text(
                                  "${giveTime(projectsIndex)}",
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .disabledColor
                                        .withOpacity(.2),
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 120,
                        ),
                        SizedBox(
                          width: gridItemWidth,
                          child: Wrap(
                            alignment: WrapAlignment.end,
                            children: [
                              IconButton(
                                  hoverColor: Colors.transparent,
                                  tooltip: "Delete",
                                  icon: Icon(Icons.delete_outline,
                                      size: 18.0, color: Colors.red),
                                  onPressed: () {
                                    taskState.buildEditDialog(context,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 16,
                                          ),
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            child: Container(
                                              width: 200.0,
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 8,
                                                        horizontal: 3),
                                                    child: Text(
                                                      "Do you want to delete this project?",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 10),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          colllaborationState
                                                              .collabAllTasks
                                                              .removeAt(
                                                                  projectsIndex);
                                                          colllaborationState
                                                              .generateList();
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: MouseRegion(
                                                          cursor:
                                                              SystemMouseCursors
                                                                  .click,
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              color: Colors.red
                                                                  .withOpacity(
                                                                      .3),
                                                            ),
                                                            child: Padding(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      16,
                                                                  vertical: 6),
                                                              child: Text(
                                                                "Yes",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .red,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 30.0,
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: MouseRegion(
                                                          cursor:
                                                              SystemMouseCursors
                                                                  .click,
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              color: Colors
                                                                  .green
                                                                  .withOpacity(
                                                                      .3),
                                                            ),
                                                            child: Padding(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      16,
                                                                  vertical: 6),
                                                              child: Text(
                                                                "No",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .green,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 10),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ));
                                  }),
                              IconButton(
                                  hoverColor: Colors.transparent,
                                  tooltip: "People",
                                  icon: Icon(Icons.people_alt,
                                      size: 18.0,
                                      color: Theme.of(context)
                                          .disabledColor
                                          .withOpacity(.2)),
                                  onPressed: () {}),
                              IconButton(
                                  hoverColor: Colors.transparent,
                                  tooltip: "Set date",
                                  icon: Icon(Icons.date_range_outlined,
                                      size: 18.0, color: Colors.green),
                                  onPressed: () {
                                    dateTimeRangePicker(projectsIndex);
                                  }),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 8,
                    width: gridItemWidth,
                    decoration: BoxDecoration(
                      color: taskState.currentRunningProjectId.value ==
                              projectsIndex
                          ? Theme.of(context).primaryColor
                          : Colors.transparent,
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(6.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
