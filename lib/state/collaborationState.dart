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
import 'package:taskslide/state/simples.dart';
import 'package:taskslide/state/state.dart';
import 'package:uuid/uuid.dart';

import '../main.dart';

class ColllaborationState extends GetxController {
// DECLARATIONS

  List collabAllTasks = [].obs;

  List collabTaskList = [].obs;

  List<Widget> collabItems = []..obs;

  List collabChildrenItems = []..obs;

  var currentCollabRunningProjectId = 0.obs;

  var feelingLucky = false.obs;

  var showFrontInput = false.obs;

  var addingNewProjectToServerIndicator = false.obs;

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

  List searchableArray = []..obs;

  var isSearching = false.obs;

  var isOnline = false.obs;

  final taskState = Get.put(TaskState());

  @override
  void onInit() {
    listenOnEvent();
    getSYNC_MY_DATA();
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
                : "N/A",
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
    Uuid uuid = Uuid();

    var cardData =
        // Single Task Item
        {
      "id": "${uuid.v4()}", // collabTaskList.length,
      "color": "#0",
      "name": "$label",
      "sub-children": [],
      'done': false,
    };

    collabTaskList.add(cardData);
    generateList();
  }

  void addChildToParent(int maxN, {String header, String description}) {
    Uuid uuid = Uuid();

    // A Task Child Item
    var childData = {
      "id": uuid.v4(), //"${collabTaskList[maxN]["sub-children"].length}",
      "color": "#0",
      "state": "waiting",
      "name": "$header",
      "description": "$description",
      "people": [
        {
          "person-id": "",
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

  addNewProject({String name, String time, @required String userid}) {
    Uuid uuid = Uuid();

    List newItem = [
      {
        "creator": userid,
        "id": uuid.v4(), // 0,
        "project-name": "$name",
        "date-time": "$time",
        "date-start": "",
        "date-end": "",
        "people": [userid],
        "project-body": [],
        'done': false,
        'last_editted': DateTime.now().toIso8601String(),
        "access_type": "private",
      },
    ];

    var addMore = {
      "creator": userid,
      "id": uuid.v4(), // collabAllTasks.length,
      "project-name": "$name",
      "date-time": "$time",
      "date-start": "",
      "date-end": "",
      "people": [userid],
      "project-body": [],
      'done': false,
      'last_editted': DateTime.now().toIso8601String(),
      "access_type": "private",
    };

    if (collabAllTasks.length == 0) {
      collabAllTasks = newItem;
    } else {
      collabAllTasks.add(addMore);
    }
    update();
    newProjectCreated(collabAllTasks[collabAllTasks.length - 1]);
  }

  // send new project to server
  newProjectCreated(project) async {
    print("SENDING \n$project   ---> ");

    addingNewProjectToServerIndicator.value = true;

    packageDio.Dio dio = packageDio.Dio();
    var url = BaseUrl.baseUrl + '/add_new_project';
    Map<String, dynamic> body = project;

    await dio.post(url, data: body).then((value) {
      if (value.statusCode > 199 && value.statusCode < 206) {
        // updated succesfully
        addingNewProjectToServerIndicator.value = false;
        debugPrint(".........200");
        update();
      } else {
        // something else happened. could not add the data. remove locally added
        addingNewProjectToServerIndicator.value = false;
        collabAllTasks.removeWhere((element) => element['id'] == project['id']);
        debugPrint(".......NOT..200");

        update();
      }
    }).catchError((onError) {
      debugPrint("ON_ERROR......$onError");
    });
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

  searchForPattern(String pattern) {
    //  ^([a-zA-Z]+)$.*\b(?=[a-zA-Z]*w)(?=[a-zA-Z]*o)(?=[a-zA-Z]*r)(?=[a-zA-Z]*d)[a-zA-Z]+$

    isSearching.value = true;

    if (pattern.isEmpty) {
      isSearching.value = false;
      searchableArray = [];
      update();
    } else {
      searchableArray = [];

      for (int project = 0; project < (collabAllTasks.length); project++) {
        bool patternMatches = collabAllTasks[project]["project-name"]
            .toString()
            .toLowerCase()
            .contains(pattern.toLowerCase());

        if (patternMatches) {
          var taskToAdd = collabAllTasks[project];
          taskToAdd['task_real_index'] = project;
          searchableArray.add(taskToAdd);
        }
      }
      update();
    }
  }

  showInputToCreateTask(bool state) {
    showFrontInput.value = state;
  }

  void poulateCollabAllTasks(List incomingList) {
    print("INCOM LST: ${incomingList.length}");
    if (incomingList != null) {
          print("INCOM LST not null: ${incomingList.length}");

      collabAllTasks.clear();
      collabAllTasks = incomingList;
      collabTaskList =
          collabAllTasks[currentCollabRunningProjectId.value]["project-body"];
      generateList();
      // update();
                print("All tsk len: ${collabAllTasks.length}");

    }
          update();

  }

  /// Get all Tasks that the user is collaborating in AS a STREAM
  //Stream<List>
  Future getCollaborationsStream(
      {String email, @required BuildContext context}) async {
    bool syncMyData = await getSYNC_MY_DATA();
    bool userHasLoggenIn = await getLOGIN_STATUS();

    if (syncMyData != true) {
      if (userHasLoggenIn != true) {
        // if SYNCING is ON and the USER is LOG IN get online data
        packageDio.Dio dio = packageDio.Dio();
        var url = BaseUrl.baseUrl + '/collaborations';
        Map<String, dynamic> body = {
          "email": email.toString(),
        };

        var response = await dio
            .post(url,
                // queryParameters: queryParams,
                data: body)
            .catchError((Response err) async {
          return [];
        });

        // getAndSetTaskValues();
        // List onlineOfflineMerger = SimpleMethods.mergeProjectsAndUpdate(
        //     onlineProjects: response.data.length == 0 ? [] : response.data,
        //     locallProjects: collabAllTasks);

        // debugPrint("merger: ${onlineOfflineMerger.length}");

        // poulateCollabAllTasks(onlineOfflineMerger);
        // return response.data.length == 0 ? [] : response.data;

        poulateCollabAllTasks(response.data.length == 0 ? null : response.data);
        return response.data.length == 0 ? [] : response.data;
      } else {
        debugPrint("LOCAL 2");
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (builder) => MyApp()), (_) => false);
        // we can update tasks if the user is also not logged in, so just return locally saved data
        getAndSetTaskValues();
        return collabAllTasks;
      }
    } else {
      // If the user has turn syncing of just return any locally saved data available
      getAndSetTaskValues();
      return collabAllTasks;
    }
  }

  void swtichEditingMode({bool value}) {
    if (value == null) {
      isEditing.value = !isEditing.value;
    } else {
      isEditing.value = value;
    }
  }


  void getAndSetTaskValues({bool isInit}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var values = (prefs.getString(SimpleMethods.SAVED_TASKS) ?? jsonEncode([]));
    var castedToList = json.decode(values);
    collabAllTasks.clear();
    collabAllTasks = castedToList;
    // collabTaskList =
    //     collabAllTasks[currentCollabRunningProjectId.value]["project-body"];
    generateList();
    update();
  }

  Future<bool> getSYNC_MY_DATA() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool values = (prefs.getBool(SimpleMethods.SYNC_MY_DATA));
    isOnline.value = values;
    return values;
  }

  Future<bool> getLOGIN_STATUS() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool values = (prefs.getBool(SimpleMethods.LOGIN_STATUS));
    return values;
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

      generateList();
      update();
    }
  }

  // Send task with Acknowledgements
  void sendCollaborationTaskToServer() {
    taskState.setIsSaving(true);

    // Save locally
    SimpleMethods.storeValuesLocally(collabAllTasks);

    String id = SimpleMethods.returnSingleTaskItem(
            collabAllTasks, currentCollabRunningProjectId.value)["id"]
        .toString();
    String dateTime = SimpleMethods.returnSingleTaskItem(
            collabAllTasks, currentCollabRunningProjectId.value)["date-time"]
        .toString();
    String creator = SimpleMethods.returnSingleTaskItem(
            collabAllTasks, currentCollabRunningProjectId.value)["creator"]
        .toString();
    Map<String, dynamic> newTaskList = SimpleMethods.returnSingleTaskItem(
        collabAllTasks, currentCollabRunningProjectId.value);

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
      print("Data: $data ");

      var dataDecoded = data;
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
