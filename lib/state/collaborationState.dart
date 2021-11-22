import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskslide/UIs/Collaborations/collab-list-widgets/ParentInputAndButton.dart';
import 'package:taskslide/UIs/Collaborations/collab-list-widgets/ParentList.dart';
import 'package:taskslide/UIs/Collaborations/collab-list-widgets/childList.dart';
import 'package:taskslide/UIs/Collaborations/collab-list-widgets/collabInput.dart';
// Importing this with prefix to fix multiple packages error
import 'package:dio/dio.dart' as packageDio;

import 'package:taskslide/UIs/CustomDialogBody/CustomBodyDialog.dart';
import 'package:taskslide/state/BaseUrl.dart';
import 'package:taskslide/state/state.dart';

class ColllaborationState extends GetxController {
// DECLARATIONS

  List collabAllTasks = [].obs;

  List collabTaskList = [].obs;

  List<Widget> collabItems = []..obs;

  List collabChildrenItems = []..obs;

  var currentCollabRunningProjectId = 0.obs;

  var feelingLucky = false.obs;

  var themeMode = false.obs;

  var showInput = false.obs;
  var showChildInput = false.obs;

  var currentInputIndex = "currentid".obs;

  var isEditing = false.obs;

  var userIsEditingAnItemInAProject = false.obs;

  var subChildrenPopUpIndex = -1
    ..obs;

  var childListCurrentTouchParentKey = -1
    ..obs;

  final taskState = Get.put(TaskState());

  @override
  void onInit() {
    listenOnEvent();
    super.onInit();
  }

  // METHODS
  void generateList() {
    List<Widget> children = [];

    if (collabChildrenItems.length > 0) {
      collabChildrenItems = [];
    }

    if (collabItems != null) collabItems = [];

    if (collabTaskList != null)
      for (int n = 0; n <= collabTaskList.length - 1; n++) {
        children = [];

        for (int sub = 0;
            sub <= collabTaskList[n]["sub-children"].length - 1;
            sub++) {
          children.add(
            CollaborationChildList(
              //key:UniqueKey(),
              key: ValueKey("$sub/k/$n"),
              header: collabTaskList[n]["sub-children"][sub]["name"].toString(),
              childkey: sub.toString(),
              parentKey: collabTaskList != null ? n.toString() : "0",
              state: collabTaskList[n]["sub-children"][sub]["state"].toString(),
            ),
          );

          if (sub == collabTaskList[n]["sub-children"].length - 1) {
            children.add(CollaborationInputChildItems(
                key: UniqueKey(), thisParentId: n.toString()));
          }
        }

        // add inputfield Anyways if there are nocollabItems

        if (collabTaskList[n]["sub-children"].length == 0) {
          children.add(CollaborationInputChildItems(
              key: UniqueKey(), thisParentId: n.toString()));
        }

        collabChildrenItems.insert(n, children);

        collabItems.add(
          CollaborationParentList(
            nPos: n,
            header: collabTaskList != null
                ? collabTaskList[n]["name"].toString()
                : "Aberor",
            mainKeys: n.toString(),
            key: UniqueKey(),
          ),
        );

        if (n == collabTaskList.length - 1) {
          collabItems.add(CollaborationParentInputAndButton(
            key: UniqueKey(),
          ));
        }
      }

    // add Button Anyways if there are nocollabItems
    if (collabTaskList.length == 0) {
      // print("Items Zero, adding Button");
      collabItems.add(CollaborationParentInputAndButton(
        key: UniqueKey(),
      ));
    }
  }

  void addParentCard(String label) {
    var cardData =
        // Single Task Item
        {
      "id": "${collabTaskList.length}",
      "color": "#0",
      "name": "$label",
      "sub-children": [],
      'done': false,
    };

    collabTaskList.add(cardData);
    generateList();
  }

  void addChildToParent(int maxN, {String header, String description}) {
    // A Task Child Item
    var childData = {
      "id": "${collabTaskList[maxN]["sub-children"].length}",
      "color": "#0",
      "state": "waiting",
      "name": "$header",
      "description": "$description",
      "people": [
        {
          "person-id": "id110",
          "profile-pic": "",
        }
      ]
    };

    collabTaskList[maxN]["sub-children"].add(childData);
    generateList();
  }

  void buildEditDialog(BuildContext context,
      {Widget child, String mainId, String subId}) {
    userIsEditingAnItemInAProject.value = true;
    var res = Navigator.of(context).push(
      PageRouteBuilder(
          opaque: false,
          pageBuilder: (pageBuilder, __, _) => CustomBodyDialog(
                child: child,
              )),
    );

    res.then((value) {
      print("HAS FINISHED WITH EDITING");
      userIsEditingAnItemInAProject.value = false;
    });
  }

  void setSubChildrenPopUpIndex(newint, parentkey) {
    subChildrenPopUpIndex = newint;
    childListCurrentTouchParentKey = parentkey;
    //generateList();
    update();
  }

  void editCardClicked(
    BuildContext context, {
    Widget child,
  }) {
    buildEditDialog(context, child: child);
  }

  void setIsEditingProject(bool state) {
    /// To validate whether a user is typing or using a dialog or not
    userIsEditingAnItemInAProject.value = state;
    print("User Editing State: ${userIsEditingAnItemInAProject.value}");
  }

  void callToAddChildToParent(int maxN, {String header, String description}) {
    showChildInput.value = false;
    addChildToParent(maxN, header: header, description: description);
    update();

    // Send Updates to server
    sendCollaborationTaskToServer();
  }

  void childListClose() {
    currentInputIndex.value = "currentid";
    showChildInput.value = false;
    generateList();
  }

  void editChildCardDetailsClick(int mainIndex, int subIndex,
      {String name, String color}) {
    collabTaskList[mainIndex]["sub-children"][subIndex]["name"] = name;
    collabTaskList[mainIndex]["sub-children"][subIndex]["color"] = color;
    generateList();
    update();

    // Send Updates to server
    sendCollaborationTaskToServer();
  }

  void editCardUpdateClick(int index, {String name, String color}) {
    collabTaskList[index]["name"] = name;
    collabTaskList[index]["color"] = color;
    generateList();
    update();

    // Send Updates to server
    sendCollaborationTaskToServer();
  }

  void deleteChildCardClick(
    int mainIndex,
    int subIndex,
  ) {
    collabTaskList[mainIndex]["sub-children"].removeAt(subIndex);
    generateList();
    update();

    // Send Updates to server
    sendCollaborationTaskToServer();
  }

  void deleteParentCardClick(int index) {
    collabTaskList.removeAt(index);
    generateList();
    update();

    // Send Updates to server
    sendCollaborationTaskToServer();
  }

  void checkItem(int nth, int subnth) {
    if (collabTaskList[nth]["sub-children"][subnth]["state"] == "done") {
      collabTaskList[nth]["sub-children"][subnth]["state"] = "waiting";
    } else {
      collabTaskList[nth]["sub-children"][subnth]["state"] = "done";
    }
    //generateList();
    update();

    // Send Updates to server
    sendCollaborationTaskToServer();
  }

  switchCurrentRunningProcess(int newid) {
    currentCollabRunningProjectId.value = newid;
    collabTaskList =
        collabAllTasks[currentCollabRunningProjectId.value]["project-body"];
    generateList();
    update();
  }

  setFeelingLuckyMode() async {
    feelingLucky.value = !feelingLucky.value;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('feeling', feelingLucky.value);
    } catch (e) {}
  }

  setThemeMode() async {
    themeMode.value = !themeMode.value;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('theme', themeMode.value);
    } catch (e) {}
  }

  void setRedorder(int oldIndex, int newIndex) {
    if (oldIndex != collabItems.length - 1 &&
        newIndex != collabItems.length - 1) {
      Widget row = collabItems.removeAt(oldIndex);
      collabItems.insert(newIndex, row);

      // // Reorder Main List
      var holder;
      holder = collabTaskList[oldIndex];
      collabTaskList[oldIndex] = collabTaskList[newIndex];
      collabTaskList[newIndex] = holder;

      generateList();
      update();
    }

    // Send Updates to server
    sendCollaborationTaskToServer();
  }

  void setDateRange(int index, {String start, String end}) {
    collabAllTasks[index]["date-start"] = "$start";
    collabAllTasks[index]["date-end"] = "$end";
    generateList();
    update();
  }

  addNewProject({String name, String time}) {
    List newItem = [
      {
        "id": 0,
        "project-name": "$name",
        "date-time": "$time",
        "date-start": "",
        "date-end": "",
        "people": [],
        "project-body": [],
        'done': false,
      },
    ];

    var addMore = {
      "id": collabAllTasks.length,
      "project-name": "$name",
      "date-time": "$time",
      "date-start": "",
      "date-end": "",
      "people": [],
      "project-body": [],
      'done': false,
    };

    if (collabAllTasks.length == 0) {
      collabAllTasks = newItem;
    } else {
      collabAllTasks.add(addMore);
    }
    update();
  }

  void hasFinishedProject(
    int parentid,
  ) {
    if (collabTaskList[parentid]['done'] == true) {
      collabTaskList[parentid]['done'] = false;
    } else {
      collabTaskList[parentid]['done'] = true;
    }
    update();

    // Send Updates to server
    sendCollaborationTaskToServer();
  }

  void callToAddParent(String input) {
    showInput.value = false;
    addParentCard(input);
    update();

    // Send Updates to server
    sendCollaborationTaskToServer();
  }

  void callToCloseParentAddition() {
    showInput.value = false;
    generateList();
  }

  void addToParentButton() {
    showInput.value = true;
    generateList();
  }

  void parentReorder(_oldIndex, _newIndex, nPos) {
    Widget row = collabChildrenItems[nPos].removeAt(_oldIndex);
    collabChildrenItems[nPos].insert(_newIndex, row);
    update();

    // Send Updates to server
    sendCollaborationTaskToServer();
  }

  void reorderSubTaskList(int nthMain, {oldIndex, newIndex}) {
    var holder;
    holder = collabTaskList[nthMain]["sub-children"][oldIndex];
    collabTaskList[nthMain]["sub-children"][oldIndex] =
        collabTaskList[nthMain]["sub-children"][newIndex];
    collabTaskList[nthMain]["sub-children"][newIndex] = holder;

    generateList();
    update();

    // Send Updates to server
    sendCollaborationTaskToServer();
  }

  void clickedParentAddNew(String mainKeys) {
    showChildInput.value = true;
    // The index which you want to show this input for
    currentInputIndex.value = "$mainKeys";
    generateList();
  }

  void poulateCollabAllTasks(List incomingList) {
    if (incomingList != null) {
      collabAllTasks.clear();
      collabAllTasks = incomingList;
      collabTaskList =
          collabAllTasks[currentCollabRunningProjectId.value]["project-body"];
      generateList();
      //update();
    }
  }

  /// Get all Tasks that the user is collaborating in AS a STREAM
  //Stream<List>
  Future getCollaborationsStream({String email}) async {
    packageDio.Dio dio = packageDio.Dio();
    var url = BaseUrl.baseUrl + '/collaborations';
    Map<String, dynamic> queryParams = {
      "email": email.toString(),
    };

    var response = await dio
        .post(
      url,
      queryParameters: queryParams,
    )
        .catchError((Response err) async {
      //print("Error $err");
      return [];
    });
    //var decodedData = json.decode(response.data);
    print('THE DATA: ${response.data}');

    poulateCollabAllTasks(response.data.length == 0 ? null : response.data);
    return response.data.length == 0 ? [] : response.data;
  }

  void swtichEditingMode({bool value}) {
    if (value == null) {
      isEditing.value = !isEditing.value;
    } else {
      isEditing.value = value;
    }
  }

  void addToDescription({String comment, int parent, int childkey}) {
    collabTaskList[parent]["sub-children"][childkey]["description"] = comment;
    generateList();

    // Send Updates to server
    sendCollaborationTaskToServer();
  }

  void recieveIncomingCollaborationDataEmittedByServer(List newData) {
    ///Handle the data when the server emmits the Event [get_a_taskroom_event]

    ///First of all check if user is not editting anything
    if (showInput.value == false &&
        showChildInput.value == false &&
        userIsEditingAnItemInAProject.value == false) {
      /// add the new data emitted from a socket by the server and rebuild the UI
      // First to collaborationTask list
      collabTaskList = newData;
      // Them to the bigger list one root below
      //collabAllTasks
      collabAllTasks[currentCollabRunningProjectId.value]["project-body"] =
          newData;
      print("New Data Recieved");
      generateList();
      update();
    }
  }

  Map<String, dynamic> returnSingleTaskItem() {
    var id = collabAllTasks.length > 0
        ? collabAllTasks[currentCollabRunningProjectId.value]["id"].toString()
        : "";

    var creator = collabAllTasks.length > 0
        ? collabAllTasks[currentCollabRunningProjectId.value]["creator"]
            .toString()
        : "";

    var projectName = collabAllTasks.length > 0
        ? collabAllTasks[currentCollabRunningProjectId.value]["project-name"]
            .toString()
        : "";

    var dateTime = collabAllTasks.length > 0
        ? collabAllTasks[currentCollabRunningProjectId.value]["date-time"]
            .toString()
        : "";

    var dateStart = collabAllTasks.length > 0
        ? collabAllTasks[currentCollabRunningProjectId.value]["date-start"]
            .toString()
        : "";

    var dateEnd = collabAllTasks.length > 0
        ? collabAllTasks[currentCollabRunningProjectId.value]["date-end"]
            .toString()
        : "";

    var people = collabAllTasks.length > 0
        ? collabAllTasks[currentCollabRunningProjectId.value]["people"]
        : "";

    var peopleEncoded = collabAllTasks.length > 0 ? people : "";

    var projectBody = collabAllTasks.length > 0
        ? collabAllTasks[currentCollabRunningProjectId.value]["project-body"]
        : "";

    var projectBodyEncoded = collabAllTasks.length > 0 ? projectBody : "";

    Map<String, dynamic> queryParams = {
      "id": id,
      'creator': creator,
      'project-name': projectName,
      'date-time': dateTime,
      'date-start': dateStart,
      'date-end': dateEnd,
      'people': peopleEncoded,
      'project-body': projectBodyEncoded,
      'done': false,
    };

    return queryParams;
  }

  // Send task with Acknowledgements
  void sendCollaborationTaskToServer() {
    taskState.setIsSaving(true);

    String id = returnSingleTaskItem()["id"].toString();
    String dateTime = returnSingleTaskItem()["date-time"].toString();
    String creator = returnSingleTaskItem()["creator"].toString();

    Map<String, dynamic> newTaskList = returnSingleTaskItem();

    taskState.socket.emitWithAck(
      'join_a_taskroom', newTaskList,
      // Ackknowledgement
      ack: (results) {
        taskState.setIsSaving(false);

        /// When the server acknowledges that it has recieved this data
        /// remove this unique details from the [MessagesQue] of item
        /// which are waiting to be deliverd
        taskState.addRemoveFromMessageQue(results, rm: true);
        //print("Messaging Que2 $userMessageQue");
      },
    );

    /// This socket request is sent add this inique details to the [MessageQue] list

    taskState.addRemoveFromMessageQue("$dateTime-$id-$creator");
    //print("Messaging Que1: $userMessageQue");
  }

  listenOnEvent() {
    /// This user recieves data from the server.The data is from a
    /// particular thask room which user has joined with ['join_a_taskroom']
    taskState.socket.on('get_a_taskroom_event', (data) {
      print("Data: ");

      var dataDecoded = json.decode(data);
      //print(dataDecoded);
      /// Check if the user is not currently editing
      /// if Editting dont do anything otherwise add the new data to the list
      recieveIncomingCollaborationDataEmittedByServer(
          dataDecoded != null && dataDecoded != []
              ? dataDecoded[0]["project-body"]
              : []);
    });
  }

  void joinTaskRoom() {
    String id =
        collabAllTasks[currentCollabRunningProjectId.value]["id"].toString();
    String creator = collabAllTasks[currentCollabRunningProjectId.value]
            ["creator"]
        .toString();
    String dateTime = collabAllTasks[currentCollabRunningProjectId.value]
            ["date-time"]
        .toString();
    String roomTojoin = "$id\_$creator\_$dateTime";

    Map<String, dynamic> data = {
      "room_id": roomTojoin,
    };
    taskState.socket.emit(
      'join_room',
      json.encode(data),
    );
  }
}
