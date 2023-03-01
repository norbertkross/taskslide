import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SimpleMethods {
  static final String SAVED_TASKS = "SAVED_TASKS";
  static final String LOGIN_STATUS = "LOGIN_STATUS";
  static final String SYNC_MY_DATA = "SYNC_MY_DATA";

  static Map<String, dynamic> returnSingleTaskItem(
      collabAllTasks, int collabIndex) {
    var id = collabAllTasks.length > 0
        ? collabAllTasks[collabIndex]["id"].toString()
        : "";

    var creator = collabAllTasks.length > 0
        ? collabAllTasks[collabIndex]["creator"].toString()
        : "";

    var projectName = collabAllTasks.length > 0
        ? collabAllTasks[collabIndex]["project-name"].toString()
        : "";

    var dateTime = collabAllTasks.length > 0
        ? collabAllTasks[collabIndex]["date-time"].toString()
        : "";

    var dateStart = collabAllTasks.length > 0
        ? collabAllTasks[collabIndex]["date-start"].toString()
        : "";

    var dateEnd = collabAllTasks.length > 0
        ? collabAllTasks[collabIndex]["date-end"].toString()
        : "";

    var people =
        collabAllTasks.length > 0 ? collabAllTasks[collabIndex]["people"] : "";

    var peopleEncoded = collabAllTasks.length > 0 ? people : "";

    var projectBody = collabAllTasks.length > 0
        ? collabAllTasks[collabIndex]["project-body"]
        : "";

    var accessType = collabAllTasks.length > 0
        ? collabAllTasks[collabIndex]["access_type"]
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
      'last_editted': DateTime.now().toIso8601String(),
      "access_type": accessType,
    };

    return queryParams;
  }

  static void storeValuesLocally(collabAllTasks) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      var myToJson = jsonEncode(collabAllTasks);
      await prefs.setString(SAVED_TASKS, myToJson);
    } catch (e) {}
  }

  static void setSYNC_MY_DATA(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      await prefs.setBool(SYNC_MY_DATA, value);
    } catch (e) {}
  }

  static void setLOGIN_STATUS(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      await prefs.setBool(LOGIN_STATUS, value);
    } catch (e) {}
  }

  // Combine online and local projects and remove duplicates
  static List mergeProjectsAndUpdate(
      {List onlineProjects, List locallProjects}) {
    debugPrint("L1 ${onlineProjects.length} L2 ${locallProjects.length}");
    List combinedProjects = [...onlineProjects, ...locallProjects];
    List<String> idsAlreadyVisited = [];
    Map<String, dynamic> timeForAlreadyVisitedIds = {};
    List upToDateProject = [];

    for (int i = 0; i < (combinedProjects.length); i++) {
      var thisItem = combinedProjects[i];

      // Duplicate item, so see which is latest
      if (idsAlreadyVisited.contains(thisItem['id'].toString())) {
        // get old visited item to compare with
        var visitedElement =
            timeForAlreadyVisitedIds[thisItem['id'].toString()];

        String visitedDate = visitedElement['last_editted'];

        String currentItemDate = thisItem['last_editted'];

        DateTime oldDate = DateTime.tryParse(visitedDate) ?? DateTime.now();
        DateTime newDate = DateTime.tryParse(currentItemDate) ?? DateTime.now();

        // check which item is the latest
        if (oldDate.isBefore(newDate) == true) {
          // old item was updated so use new
          upToDateProject.removeWhere((element) =>
              element['id'].toString() == thisItem['id'].toString());
          upToDateProject.add(thisItem);
        }
      } else {
        upToDateProject.add(thisItem);
        idsAlreadyVisited.add(thisItem['id'].toString());
        timeForAlreadyVisitedIds[thisItem['id'].toString()] = thisItem;
      }
    }

    debugPrint("DT: ${upToDateProject.length}");

    return upToDateProject ?? [];
  }
}
