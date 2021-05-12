import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskslide/UIs/Extras/calendeer-task.dart';
import 'package:taskslide/state/state.dart';

class CalenderAndDetails extends StatefulWidget {
  @override
  _CalenderAndDetailsState createState() => _CalenderAndDetailsState();
}

class _CalenderAndDetailsState extends State<CalenderAndDetails> {
  List header = ["All","Ended","Recent"];
    double smallDevice = 650.0;

  final taskState  = Get.put(TaskState());

  @override
  Widget build(BuildContext context) {
    Size mq = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Projects Overview"),
      ),
      body:Column(        
        children: [
         SizedBox(height: 1,),
          Flexible(
            child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: mq.width < smallDevice ? (mq.width + 200) : 1800.0,
                    child: NotificationListener<OverscrollIndicatorNotification>(
                    onNotification: (__){
                    __.disallowGlow();
                    return false;
                    },
                    child: ListView(
              children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10,),
                        SizedBox(
                          width: mq.width,
                          child: Wrap(
                            alignment: WrapAlignment.start,
                            children: [
                              
                              for (int i = 0; i <= taskState.allTasks.length-1; i++)
                              CalenderTaskItem(
                                index: i,
                              ),
                            ],
                          )),
                      ],
                    ),
              ],
            ),
             ),),),
          ),
        ],
      ),
    );
  }
}