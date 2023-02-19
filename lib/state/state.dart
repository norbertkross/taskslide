import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskslide/UIs/Collaborations/Collaborations.dart';
import 'package:taskslide/UIs/CreatedProjectsHome/CreatedProjects.dart';
import 'package:taskslide/UIs/CustomDialogBody/CustomBodyDialog.dart';
import 'package:taskslide/UIs/chat/ChatHomeScreen.dart';
import 'package:taskslide/UIs/home/calenderAndDetails.dart';
import 'package:taskslide/UIs/home/taskDragDrop.dart';
import 'package:taskslide/UIs/List-Items/Child-Cards-List.dart';
import 'package:taskslide/UIs/List-Items/Input-And-Button.dart';
import 'package:taskslide/UIs/List-Items/Input-Child-Items.dart';
import 'package:taskslide/UIs/List-Items/Main-List-Items.dart';
import 'dart:convert';

// Importing this with prefix to fix multiple packages error
import 'package:dio/dio.dart' as packageDio;

// SOCKET.IO client
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';
import 'package:taskslide/UIs/login-and-onboarding/loginHome.dart';
import 'package:taskslide/main.dart';
import 'package:taskslide/state/BaseUrl.dart';

class TaskState extends GetxController {
  // [
  //   []
  // ]

  @override
  void onInit() {
    connectAndListen();
  }

  // DECLARSRIONS

  List allTasks = [].obs;

  List taskList = [].obs;

  List<Widget> items = []..obs;

  List childrenItems = []..obs;

  var showInput = false.obs;

  var showFrontInput = false.obs;

  var showChildInput = false.obs;

  var currentInputIndex = "currentid".obs;


  var themeMode = false.obs;

  var offlineMode = false.obs;

  var currentRunningProjectId = 0.obs;

  var subChildrenPopUpIndex = -1
    ..obs;

  var childListCurrentTouchParentKey = -1
    ..obs;

  List<Widget> currentPage = [
    TaskDragDrop(),
    CalenderAndDetails(),
    ChatHomeScreen(),
    Collaborations(),
    CreatedProjects(),
  ];

  var currentHomePageIndex = 4.obs;

  var closeMediumBar = false.obs;

// User messaging que
  var userMessageQue = [].obs;

// Collaboration
  var messageQue = [].obs;

  var isSavingProject = false.obs;

  IO.Socket socket = IO.io(
      BaseUrl.baseUrl, IO.OptionBuilder().setTransports(['websocket']).build());

  /// METHODS

  /// Construct a color from a hex code string, of the format #RRGGBB.
  Color hexToColor(String code) {
    if (code.length > 2) {
      return Color(
          int.parse(code.substring(1, code.length), radix: 16) + 0xFF000000);
    } else {
      return Color(int.parse(code.substring(1, 2), radix: 16) + 0xFF000000);
    }
  }

  void setRedorder(int oldIndex, int newIndex) {
    if (oldIndex != items.length - 1 && newIndex != items.length - 1) {
      Widget row = items.removeAt(oldIndex);
      items.insert(newIndex, row);

      // // Reorder Main List
      var holder;

      holder = taskList[oldIndex];
      taskList[oldIndex] = taskList[newIndex];
      taskList[newIndex] = holder;
      generateList();
      update();
    }

    // Send Updates to server if the user has turned on online sync
    if (offlineMode.value == true) {
      sendTaskToServer();
    }
  }

  void addParentCard(String label) {
    var cardData =
        // Single Task Item
        {
      "id": "${taskList.length}",
      "color": "#0",
      "name": "$label",
      "sub-children": [],
      'done': false,
    };

    taskList.add(cardData);
    generateList();
  }

  void addChildToParent(int maxN, {String header, String description}) {
    // A Task Child Item
    var childData = {
      "id": "${taskList[maxN]["sub-children"].length}",
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

    taskList[maxN]["sub-children"].add(childData);
    generateList();
  }

  void generateList({bool isInit}) {
    List<Widget> children = [];

    if (childrenItems.length > 0) {
      childrenItems = [];
    }

    if (items != null) items = [];

    if (taskList != null)
      for (int n = 0; n <= taskList.length - 1; n++) {
        children = [];

        for (int sub = 0;
            sub <= taskList[n]["sub-children"].length - 1;
            sub++) {
          children.add(
            CardWidget(
              //key:UniqueKey(),
              key: ValueKey("$sub/k/$n"),
              header: taskList[n]["sub-children"][sub]["name"].toString(),
              childkey: sub.toString(),
              parentKey: taskList != null ? n.toString() : "0",
              state: taskList[n]["sub-children"][sub]["state"].toString(),
            ),
          );

          if (sub == taskList[n]["sub-children"].length - 1) {
            children.add(
                InputChildItems(key: UniqueKey(), thisParentId: n.toString()));
          }
        }

        // add inputfield Anyways if there are no items

        if (taskList[n]["sub-children"].length == 0) {
          children.add(
              InputChildItems(key: UniqueKey(), thisParentId: n.toString()));
        }

        childrenItems.insert(n, children);

        items.add(
          MainListItem(
            nPos: n,
            header:
                taskList != null ? taskList[n]["name"].toString() : "Aberor",
            mainKeys: n.toString(),
            key: UniqueKey(),
          ),
        );

        if (n == taskList.length - 1) {
          items.add(InputAndButton(
            key: UniqueKey(),
          ));
        }
      }

    // add Button Anyways if there are no items
    if (taskList.length == 0) {
      // print("Items Zero, adding Button");
      items.add(InputAndButton(
        key: UniqueKey(),
      ));
    }

    // I want the method to only run if its not
    // being called when the app is being Initialized
    if (isInit != true) {
      storeValuesLocally(taskList);
    } else {
      print("Was initializes...");
    }
  }

  void hasFinishedProject(
    int parentid,
  ) {
    if (taskList[parentid]['done'] == true) {
      taskList[parentid]['done'] = false;
    } else {
      taskList[parentid]['done'] = true;
    }
    update();
    // Send Updates to server if the user has turned on online sync
    if (offlineMode.value == true) {
      sendTaskToServer();
    }
  }

  void addToDescription({String comment, int parent, int childkey}) {
    taskList[parent]["sub-children"][childkey]["description"] = comment;
    generateList();

    // Send Updates to server if the user has turned on online sync
    if (offlineMode.value == true) {
      sendTaskToServer();
    }
  }

//void populateTasksList(){
//
// }

  void switchPage(int page) {
    currentHomePageIndex.value = page;
    update();
  }

  void storeValuesLocally(List mainlist) async {
    allTasks[currentRunningProjectId.value]["project-body"] = mainlist;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      var myToJson = jsonEncode(allTasks);
      await prefs.setString('main-list', myToJson);
    } catch (e) {}
  }

  void storeLocalValuesFromProjectHome() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var myToJson = jsonEncode(allTasks);
      await prefs.setString('main-list', myToJson);
      //print(myToJson) ;

    } catch (e) {
      print(e);
    }
  }

  void getAndSetTaskValues({bool isInit}) async {
    debugPrint("HRHHRHRH");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var values = (prefs.getString('main-list') ?? jsonEncode([]));
    var castedToList = json.decode(values);
    allTasks.clear();
    allTasks = castedToList;
    taskList = allTasks.length > 0
        ? allTasks[currentRunningProjectId.value]["project-body"]
        : [];
    generateList(isInit: isInit);
    update();
  }

  String processHeader(String text) {
    if (text.length < 30) {
      return text;
    } else {
      return text.substring(0, 27) + " ...";
    }
  }

  void parentReorder(_oldIndex, _newIndex, nPos) {
    Widget row = childrenItems[nPos].removeAt(_oldIndex);
    childrenItems[nPos].insert(_newIndex, row);
    update();
  }

  void reorderSubTaskList(int nthMain, {oldIndex, newIndex}) {
    var holder;

    holder = taskList[nthMain]["sub-children"][oldIndex];
    taskList[nthMain]["sub-children"][oldIndex] =
        taskList[nthMain]["sub-children"][newIndex];
    taskList[nthMain]["sub-children"][newIndex] = holder;

    generateList();
    update();

    // Send Updates to server if the user has turned on online sync
    if (offlineMode.value == true) {
      sendTaskToServer();
    }
  }

  void reorderTasklist(_oldIndex, _newIndex, nPos) {
    Widget row = childrenItems[nPos].removeAt(_oldIndex);
    childrenItems[nPos].insert(_newIndex, row);
    update();
  }

  void clickedParentAddNew(String mainKeys) {
    showChildInput.value = true;
    // The index which you want to show this input for
    currentInputIndex.value = "$mainKeys";
    generateList();
    //update();

    // Send Updates to server if the user has turned on online sync
    if (offlineMode.value == true) {
      sendTaskToServer();
    }
  }

  void callToAddChildToParent(int maxN, {String header, String description}) {
    showChildInput.value = false;
    addChildToParent(maxN, header: header, description: description);
    update();
    // Send Updates to server if the user has turned on online sync
    if (offlineMode.value == true) {
      sendTaskToServer();
    }
  }

  void callToAddParent(String input) {
    showInput.value = false;
    addParentCard(input);
    update();
    // Send Updates to server if the user has turned on online sync
    if (offlineMode.value == true) {
      sendTaskToServer();
    }
  }

  void callToCloseParentAddition() {
    showInput.value = false;
    generateList();
  }

  void addToParentButton() {
    showInput.value = true;
    generateList();
  }

  void childListClose() {
    currentInputIndex.value = "currentid";
    showChildInput.value = false;
    generateList();
  }

  void checkItem(int nth, int subnth) {
    if (taskList[nth]["sub-children"][subnth]["state"] == "done") {
      taskList[nth]["sub-children"][subnth]["state"] = "waiting";
    } else {
      taskList[nth]["sub-children"][subnth]["state"] = "done";
    }
    generateList();
    update();

    // Send Updates to server if the user has turned on online sync
    if (offlineMode.value == true) {
      sendTaskToServer();
    }
  }

  void editCardClicked(
    BuildContext context, {
    Widget child,
  }) {
    buildEditDialog(context, child: child);
  }

  void editCardUpdateClick(int index, {String name, String color}) {
    taskList[index]["name"] = name;
    taskList[index]["color"] = color;
    generateList();
    update();
  }

  void editProjectTitle(int index, String newTitle) {
    allTasks[index]["project-name"] = newTitle;
    generateList();
    update();
  }

  void setDateRange(int index, {String start, String end}) {
    allTasks[index]["date-start"] = "$start";
    allTasks[index]["date-end"] = "$end";
    generateList();
    update();
  }

  void deleteParentCardClick(int index) {
    taskList.removeAt(index);
    generateList();
    update();

    // Send Updates to server if the user has turned on online sync
    if (offlineMode.value == true) {
      sendTaskToServer();
    }
  }

  void editChildCardDetailsClick(int mainIndex, int subIndex,
      {String name, String color}) {
    taskList[mainIndex]["sub-children"][subIndex]["name"] = name;
    taskList[mainIndex]["sub-children"][subIndex]["color"] = color;
    generateList();
    update();

    // Send Updates to server if the user has turned on online sync
    if (offlineMode.value == true) {
      sendTaskToServer();
    }
  }

  void deleteChildCardClick(
    int mainIndex,
    int subIndex,
  ) {
    taskList[mainIndex]["sub-children"].removeAt(subIndex);
    generateList();
    update();

    // Send Updates to server if the user has turned on online sync
    if (offlineMode.value == true) {
      sendTaskToServer();
    }
  }

  void buildEditDialog(BuildContext context,
      {Widget child, String mainId, String subId}) {
    Navigator.of(context).push(
      PageRouteBuilder(
          opaque: false,
          pageBuilder: (pageBuilder, __, _) => CustomBodyDialog(
                child: child,
              )),
    );
  }

  setThemeMode() async {
    themeMode.value = !themeMode.value;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('theme', themeMode.value);
    } catch (e) {}
  }

  getThemeMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    themeMode.value = (prefs.getBool('theme') ?? false);
  }

  setOfflineMode(bool newbool) async {
    offlineMode.value = newbool;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('offlineMode', offlineMode.value);
    } catch (e) {}
  }

  getOfflineMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    offlineMode.value = (prefs.getBool('offlineMode') ?? false);
  }


  setUserEmailasID(String value, context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('user-ID', value);
    } catch (e) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (builder) => LoginEmailPassword()));
    }
  }

  Future<String> getuserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return (prefs.getString('user-ID') ?? "");
  }

  switchCurrentRunningProcess(int newid) {
    currentRunningProjectId.value = newid;
    taskList = allTasks[currentRunningProjectId.value]["project-body"];
    generateList();
    update();
  }

  closeTheMediumBar({bool value}) {
    closeMediumBar.value = value ?? !closeMediumBar.value;
    update();
  }

  showInputToCreateTask(bool state) {
    showFrontInput.value = state;
  }

  void setSubChildrenPopUpIndex(newint, parentkey) {
    subChildrenPopUpIndex = newint;
    childListCurrentTouchParentKey = parentkey;
    //generateList();
    update();
  }

  addNewProject(BuildContext context, {String name, String time}) async {
    String userId = await getuserID();
    if (userId.isNotEmpty) {
      List newItem = [
        {
          "id": 0,
          "creator": userId ?? "",
          "project-name": "$name",
          "date-time": "$time",
          "date-start": "",
          "date-end": "",
          "people": [userId],
          "project-body": [],
          'done': false,
          'last_editted': DateTime.now().toIso8601String()
        },
      ];

      var addMore = {
        "id": allTasks.length,
        "creator": userId ?? "",
        "project-name": "$name",
        "date-time": "$time",
        "date-start": "",
        "date-end": "",
        "people": [userId],
        "project-body": [],
        'done': false,
        'last_editted': DateTime.now().toIso8601String()
      };

      //print("Length of all files: ${allTasks.length}");

      if (allTasks.length == 0) {
        allTasks = newItem;
      } else {
        allTasks.add(addMore);
      }
      //print(allTasks);
      update();
    } else {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (builder) => MyApp()));
    }
  }

  Map<String, dynamic> returnSingleTaskItem() {
    var id = allTasks.length > 0
        ? allTasks[currentRunningProjectId.value]["id"].toString()
        : "";

    var creator = allTasks.length > 0
        ? allTasks[currentRunningProjectId.value]["creator"].toString()
        : "";

    var projectName = allTasks.length > 0
        ? allTasks[currentRunningProjectId.value]["project-name"].toString()
        : "";

    var dateTime = allTasks.length > 0
        ? allTasks[currentRunningProjectId.value]["date-time"].toString()
        : "";

    var dateStart = allTasks.length > 0
        ? allTasks[currentRunningProjectId.value]["date-start"].toString()
        : "";

    var dateEnd = allTasks.length > 0
        ? allTasks[currentRunningProjectId.value]["date-end"].toString()
        : "";

    var people = allTasks.length > 0
        ? allTasks[currentRunningProjectId.value]["people"]
        : "";

    var peopleEncoded = allTasks.length > 0 ? people : "";

    var projectBody = allTasks.length > 0
        ? allTasks[currentRunningProjectId.value]["project-body"]
        : "";

    var projectBodyEncoded = allTasks.length > 0 ? projectBody : "";

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

  /// HTTP REQUESTS

  /// Get All Tasks for this users email
  getAllMyTask({String email}) async {
    packageDio.Dio dio = packageDio.Dio();
    var url = BaseUrl.baseUrl + '/my_projects';
    Map<String, dynamic> body = {
      "email": email,
    };

    var response = await dio.post(
      url,
      // queryParameters: queryParams,
      data:body
    );
    var data = response.data;
    var check = data[0]["creator"];
    print(check.runtimeType);
    //print(data[0]["creator"].runtimeType);
  }

  /// Get all Tasks that the user is collaborating in
  getCollaborations({String email}) async {
    packageDio.Dio dio = packageDio.Dio();
    var url = BaseUrl.baseUrl + '/collaborations';
    Map<String, dynamic> body = {
      "email": email,
    };

    var response = await dio
        .post(
      url,
      // queryParameters: queryParams,
      data:body
    )
        .catchError((err) {
      print(err);
    });

    print(response.data);
  }

  /// Get All Tasks for this users email
  saveWholeProjectOnline({String email}) async {
    packageDio.Dio dio = packageDio.Dio();
    var url = BaseUrl.baseUrl + '/save-project';
    Map<String, dynamic> body = {
      "project": json.encode(allTasks),
    };

    var response = await dio.post(
      url,
      // queryParameters: queryParams,
      data:body
    );

    print(response.data);
  }

  // SocketIO
  void connectAndListen() {
    socket.onConnect((_) {
      print('...:::: connected ::::...');
    });

    ///When a single task event is recieved from server,
    ///data is added to the Tasklist Locally
    socket.on('server_sent_single_task', (data) {
      var dataDecoded = json.decode(data);
      print("server_sent_single_task");
      print(dataDecoded);
    });

    /// When the Socket has disconnected
    socket.onDisconnect((_) => print('disconnect'));
  }

  /// This would add a User to A collaboration Task room So that user can recieve
  /// all event Emitted by the socket to ['get_a_taskroom_event']
  void joinTaskRoomToUpdateAndSendData({
    Map<String, dynamic> data,
  }) {
    socket.emit(
      'join_a_taskroom',
      json.encode(data),
    );
  }

  /// Emit the event ['client_sent_task'] so that user listening on
  /// ['server_sent_single_task'] can recieve it.
  void emitSingleTask() {
    Map<String, dynamic> queryParams = returnSingleTaskItem();

    socket.emit(
      'client_sent_task',
      json.encode(queryParams),
    );
  }

  void clearMessageQue() {
    messageQue.clear();
  }

  // single CLIENT Send task with Acknowledgements
  void sendTaskToServer() {
    isSavingProject.value = true;

    String id = returnSingleTaskItem()["id"].toString();
    String dateTime = returnSingleTaskItem()["date-time"].toString();
    String creator = returnSingleTaskItem()["creator"].toString();

    Map<String, dynamic> newTaskList = returnSingleTaskItem();
    //newTaskList["ack"] = "$dateTime-$id-$creator";
    //print(newTaskList);

    socket.emitWithAck(
      'client_sent_task', newTaskList,
      // Ackknowledgement
      ack: (results) {
        isSavingProject.value = false;

        var timeStamp = results[0]['date-time'].toString();
        var rid = results[0]['id'].toString();
        var rcreator = results[0]['creator'].toString();
        String messageIdToRemoveFromQue = "$timeStamp-$rid-$rcreator";

        /// When the server acknowledges that it has recieved this data
        /// remove this unique details from the [MessagesQue] of item
        /// which are waiting to be deliverd
        userMessageQue
            .removeWhere((element) => element == messageIdToRemoveFromQue);
        //print("User2 MQ: $userMessageQue");

        // Update the data In the user localDatabase
        storeValuesLocally(
            results != null && results == [] && results.length > 0
                ? results[0]["project-body"]
                : []);
      },
    );

    /// This socket request is sent add this inique details to the [MessageQue] list
    userMessageQue.add("$dateTime-$id-$creator");
    print("User1 MQ: $userMessageQue");
  }

  void setIsSaving(bool state) {
    isSavingProject.value = state;
  }

  void addRemoveFromMessageQue(String value, {bool rm = false}) {
    /// Performs an addition by default
    /// performs a remove if rm == true
    if (rm == true) {
      // Remove
      userMessageQue.removeWhere((element) => element == value);
    } else {
      // Add to que
      userMessageQue.add(value);
    }
  }

  // /addNewTask

  /// Store Updates in a database
  //  sendUpdateData()async{

  //   packageDio.Dio dio = packageDio.Dio();
  //   var url = BaseUrl.baseUrl+'/addNewTask';
  //   Map<String,dynamic> queryParams = returnSingleTaskItem();

  //   var response = await dio.post(url,queryParameters: queryParams,);

  //   print(response.data);

  //  }
}
