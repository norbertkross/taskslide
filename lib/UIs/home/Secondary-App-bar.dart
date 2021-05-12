import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:taskslide/UIs/Extras/offline-switch.dart';
import 'package:taskslide/state/state.dart';
class SecondaryAppBar extends StatefulWidget {
  @override
  _SecondaryAppBarState createState() => _SecondaryAppBarState();
}

class _SecondaryAppBarState extends State<SecondaryAppBar> {
  final taskState = Get.put(TaskState());
  double smallDevices = 650.0;
  @override
  Widget build(BuildContext context) {
    Size mq = MediaQuery.of(context).size;
    return Container(
      child: mq.width > smallDevices? Card(
              elevation: 20.0,
              margin: EdgeInsets.all(0.0),
              child: Container(
                width: 65.0,
                height: mq.height,
                color: Theme.of(context).cardColor,
                child: ListView(
                  children: [
                    Column(
                      children: [

                        SizedBox(
                        height: 15,
                         ),
                        //   child:
                          Tooltip(
                            message: "Online Sync",
                            child: MouseRegion(
                              cursor:SystemMouseCursors.click,
                              child: Obx(() =>
                                WSRectSwitch(
                                  activeColor: Theme.of(context).primaryColor,
                                  value: taskState.offlineMode.value,
                                  onChanged: (_){
                                    taskState.setOfflineMode(_);
                                  },
                                ),
                              ),
                            ),
                          ),                        

                      SizedBox(
                        height: 12,
                      ),
                      

                        IconButton(
                        tooltip: "People",
                        icon: Icon(
                          Icons.people,color: Theme.of(context).disabledColor,), 
                        onPressed: (){}
                        ),

                        SizedBox(height: 10,),

                        IconButton(
                        tooltip: "Theme",
                        icon: Icon(
                          Icons.brightness_6,color: Theme.of(context).disabledColor,), 
                        onPressed: (){
                          taskState.setThemeMode();
                        }
                        ),

                        SizedBox(height: 10,),

                        Tooltip(message: "I'm feeling lucky",
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: (){
                              taskState.setFeelingLuckyMode();
                            },
                            child: Container(
                              width: 50,
                              height: 50,
                              color: Theme.of(context).primaryColor.withOpacity(.001),
                              child: Stack(
                                children: [                                 
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20,left: 25),
                                    child: Container(
                                      width: 10,
                                      height: 10,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 25,left: 10),
                                    child: Container(
                                      width: 10,
                                      height: 10,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.yellow,
                                      ),
                                    ),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.only(top: 18,left: 18),
                                    child: Container(
                                      width: 6,
                                      height: 6,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xff1a4ff7),
                                      ),
                                    ),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.only(top: 12,left: 30),
                                    child: Container(
                                      width: 7,
                                      height: 7,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xfff78f1a),
                                      ),
                                    ),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.only(top: 8,left: 18),
                                    child: Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xFF0aab20),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        ),
                          //),                        
                      ],
                    ),
                  ],
                ),
              ),
            ):Container(),
    );
  }
}