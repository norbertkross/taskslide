import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskslide/state/state.dart';

class AppBarMain extends StatefulWidget {
  @override
  _AppBarMainState createState() => _AppBarMainState();
}

class _AppBarMainState extends State<AppBarMain> {
  double smallDevices = 650.0;
  final taskState = Get.put(TaskState());


  Widget holderWidget(mq,{List<Widget> children}){
    return Container(
        width:70.0,
        height:mq.height ,
        color: Theme.of(context).primaryColor,
        child:ListView(
                  children: [
                  Obx(()=>
                    taskState.offlineMode.value == true? Column(
                        children: [
                           Padding(
                             padding: const EdgeInsets.all(8.0),
                             child: Container(
                               width: 55,
                               height: 55,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Theme.of(context).canvasColor.withOpacity(.20),
                                ),
                                child: Center(child: Text("A",style: TextStyle(
                                  color: Theme.of(context).canvasColor.withOpacity(.8),
                                  fontWeight: FontWeight.bold,
                                ),),),
                             ),
                           ),
                        ],
                      ):Container(),
                  ),

                  Column(
                    children: children,
                  ),

           ],
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    Size mq = MediaQuery.of(context).size;
    return Container(
      child:Padding(
                padding: const EdgeInsets.only(left:0.0),
                child: Card(
                elevation: 8.0,
                margin: EdgeInsets.all(0.0),
                child: Container(
                width:70.0,
                height: mq.height,
                color: Theme.of(context).primaryColor,
                child: holderWidget(mq,
                      children: [


                      Column(
                        children: [
                          Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0), 
                          child: IconButton(
                            tooltip: "Home",
                            icon: Icon(Icons.home,color: Theme.of(context).canvasColor,), 
                            onPressed:(){taskState.switchPage(4);taskState.closeTheMediumBar(value: true);}
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: IconButton(
                              tooltip: "Calender",
                              icon: Icon(Icons.date_range_outlined,color: Theme.of(context).canvasColor,), 
                            onPressed:(){taskState.switchPage(1);taskState.closeTheMediumBar(value: true);}
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: IconButton(
                              tooltip: "Chat",
                              icon: Icon(Icons.mark_chat_read_rounded,color: Theme.of(context).canvasColor,), 
                            onPressed:(){taskState.switchPage(2);taskState.closeTheMediumBar(value: true);}
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: IconButton(
                            tooltip: "Colab",
                            icon: Icon(Icons.account_tree_rounded,color: Theme.of(context).canvasColor,), 
                            onPressed:(){taskState.switchPage(3);taskState.closeTheMediumBar(value: true);}
                            ),
                          ),

                        ],
                      ),                        
                      ],
                   ),
                 ),
              ),),
    );
  }
}