import 'package:async_loader/async_loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskslide/UIs/Collaborations/CollaborationTaskEditor.dart';
import 'package:taskslide/UIs/chat/components/loading_error_widget.dart';
import 'package:taskslide/UIs/chat/components/not_part_of_any_project.dart';
import 'package:taskslide/UIs/chat/components/request_error_widget.dart';
import 'package:taskslide/UIs/chat/components/task_item_widget_collab.dart';
import 'package:taskslide/state/collaborationState.dart';
import 'package:taskslide/state/state.dart';

import 'InputAddListButtonCollaboration.dart';

class Collaborations extends StatefulWidget {
  @override
  _CollaborationsState createState() => _CollaborationsState();
}

class _CollaborationsState extends State<Collaborations> {
  final GlobalKey<AsyncLoaderState> _asyncLoaderState =
      GlobalKey<AsyncLoaderState>();
  double smallDevice = 650.0;
  bool showBuilder = true;

  final colllaborationState = Get.put(ColllaborationState());
  final taskState = Get.put(TaskState());

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
                                        renderError: ([error]) =>
                                            RequestErrorWidget(
                                              onRetry: () {
                                                _asyncLoaderState.currentState
                                                    .reloadState()
                                                    .whenComplete(() => print(
                                                        'finished reload'));
                                              },
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
                                                        color: Theme.of(context)
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
                                                        .getuserID(),
                                                    context: context),
                                        renderSuccess: ({data}) {
                                          if (data.length > 0) {
                                            return GetBuilder<
                                                    ColllaborationState>(
                                                builder: (builder) => Wrap(
                                                      children: [
                                                       
                                                        for (int projectsIndex =
                                                                0;
                                                            projectsIndex <=
                                                                colllaborationState
                                                                        .collabAllTasks
                                                                        .length -
                                                                    1;
                                                            projectsIndex++)
                                                          TaskItemCollab(
                                                            projectsIndex:
                                                                projectsIndex,
                                                          ),
                                                        Wrap(
                                                          children: [
                                                            Obx(
                                                              () => colllaborationState
                                                                          .addingNewProjectToServerIndicator
                                                                          .value ==
                                                                      true
                                                                  ? Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          top:
                                                                              20.0),
                                                                      child:
                                                                          CupertinoActivityIndicator(
                                                                        color: Theme.of(context)
                                                                            .primaryColor,
                                                                        radius:
                                                                            16,
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
                                            return NotInAnyProject(
                                              onReload: () {
                                                _asyncLoaderState.currentState
                                                    .reloadState()
                                                    .whenComplete(() => print(
                                                        'finished reload'));
                                              },
                                            );
                                          } else {
                                            return LoadingErrorState();
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
}
