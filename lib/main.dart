import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:taskslide/UIs/home/body.dart';
import 'package:taskslide/UIs/login-and-onboarding/loginHome.dart';
import 'package:taskslide/state/state.dart';

import 'UIs/home/taskDragDrop.dart';

void main() {
  runApp(GetMaterialApp(debugShowCheckedModeBanner: false, home: MyApp()));
}

class MyApp extends StatelessWidget {
  static Map<int, Color> color = {
    50: Color.fromRGBO(26, 79, 247, .1),
    100: Color.fromRGBO(26, 79, 247, .2),
    200: Color.fromRGBO(26, 79, 247, .3),
    300: Color.fromRGBO(26, 79, 247, .4),
    400: Color.fromRGBO(26, 79, 247, .5),
    500: Color.fromRGBO(26, 79, 247, .6),
    600: Color.fromRGBO(26, 79, 247, .7),
    700: Color.fromRGBO(26, 79, 247, .8),
    800: Color.fromRGBO(26, 79, 247, .9),
    900: Color.fromRGBO(26, 79, 247, 1),
  };

  final MaterialColor colorCustom = MaterialColor(0xFF1a4ff7, color);

  final taskState = Get.put(TaskState());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => taskState.themeMode.value == true ||
              taskState.themeMode.value == false
          ? MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Taskslide',

              themeMode: taskState.themeMode.value == true
                  ? ThemeMode.dark
                  : ThemeMode.light,
              darkTheme: ThemeData(
                brightness: Brightness.dark,
                primaryColor: Color(0xFF1a4ff7),
                primaryColorDark: Color(0xFF1a4ff7),
              ),

              theme: ThemeData(
                primarySwatch: colorCustom,
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              home: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: 0.0,
                    horizontal: MediaQuery.of(context).size.width >= 650
                        ? MediaQuery.of(context).size.width <= 1100
                            ? MediaQuery.of(context).size.width * .15
                            : MediaQuery.of(context).size.width * .35
                        : 0.0),
                // child: LoginEmailPassword(),
                child: LoginEmailPassword(),
                // child: TaskDragDrop(),
              ),

            //  home: Body(),
              //TaskDragDrop(),
            )
          : Container(),
    );
  }
}

// clipboard-list
// home
// list-checks
// users
// user
// pencil
// calendar-range
// trash-2
// moon
// sun