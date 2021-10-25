import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:taskslide/UIs/home/body.dart';
import 'package:taskslide/state/state.dart';
void main() {
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    home:MyApp()));
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
    return Obx(()=>
      taskState.themeMode.value == true || taskState.themeMode.value == false? MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Taskslide',

        themeMode: taskState.themeMode.value == true? ThemeMode.dark : ThemeMode.light,
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Color(0xFF1a4ff7),
          primaryColorDark: Color(0xFF1a4ff7),
          ), 

        theme: ThemeData(
          primarySwatch: colorCustom,
         visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: 
        Body(),
        //TaskDragDrop(),
      ):Container(),
    );
  }
}
