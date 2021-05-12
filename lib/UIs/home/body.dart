import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:taskslide/UIs/home/App-Bar-Main.dart';
import 'package:taskslide/UIs/home/Secondary-App-bar.dart';
import 'package:taskslide/UIs/home/mediumBar.dart';
import 'package:taskslide/state/state.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {

  final taskState = Get.put(TaskState());
  double smallDevices = 650.0;
  bool showDialog = false;

  @override
  void initState() {
    super.initState();
    
  taskState.getOfflineMode();
  taskState.getThemeMode();
  taskState.getFeelingLuckyMode();

  WidgetsBinding.instance.addPostFrameCallback((timeStamp) { 
    setState(() {
       taskState.getAndSetTaskValues(isInit: true);
      });               
    });
  }  

  @override
  Widget build(BuildContext context) {
    Size mq = MediaQuery.of(context).size;
    return Scaffold(
      bottomNavigationBar: mq.width < smallDevices? 
      Card(
        elevation: 30.0,
        margin: EdgeInsets.all(0),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30 ), ),
        ),
        color: Theme.of(context).primaryColor,
        child: Container(
          decoration: BoxDecoration(                      
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical:2.0),
            child: mobileAppBar(),
          ),
        ),
      ):null,    
      body: Stack(
        children: [
          SizedBox(
              width: mq.width,
              height: mq.height,
              child: Row(
                //alignment: WrapAlignment.spaceBetween,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [              
                  Wrap(
                    children: [

                  // Main Side bar  
                  mq.width >= smallDevices?  AppBarMain() : Container(),

                // Second Medium Side bar
                 Obx(()=> taskState.currentHomePageIndex.value == 4 || taskState.closeMediumBar.value == true? Container() :  
                 mq.width > smallDevices? Card(
                  elevation: 30.0,
                  shadowColor: Theme.of(context).primaryColor,
                  margin: EdgeInsets.all(0.0),
                  child: Container(
                  width: 248.0,
                  height: mq.height,
                  color: Theme.of(context).cardColor,
                  child:MediumBar(),
                ),):Container(),),

                    ],
                  ), 


                //Body Of Tasks Lists
                //Obx(()=>
                   Container(
                    width: (mq.width - (mq.width > smallDevices?((taskState.currentHomePageIndex.value ==4 || taskState.closeMediumBar.value == true?0.0:250.0)+70.0+65.0): (0.0) )),
                    height: mq.height,
                    child: Obx(()=>taskState.currentPage[taskState.currentHomePageIndex.value]),                                      
                  ),
                //),

                // Third Small Side Bar           
                 SecondaryAppBar(), 
                ],
              ),
          ),

        ],
      ),
    );
  }


  Widget mobileAppBar(){
    return  Wrap(
      alignment: WrapAlignment.spaceAround,
          children: [
              Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0), 
              child: IconButton(
                tooltip: "Home",
                icon: Icon(Icons.category_rounded,color: Theme.of(context).canvasColor,), 
                onPressed:(){taskState.switchPage(0);}
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: IconButton(
                  tooltip: "Calender",
                  icon: Icon(Icons.date_range_outlined,color: Theme.of(context).canvasColor,), 
                onPressed:(){taskState.switchPage(1);}
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: IconButton(
                  tooltip: "Chat",
                  icon: Icon(Icons.mark_chat_read_rounded,color: Theme.of(context).canvasColor,), 
                onPressed:(){taskState.switchPage(2);}
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: IconButton(
                tooltip: "Colab",
                icon: Icon(Icons.account_tree_rounded,color: Theme.of(context).canvasColor,), 
                onPressed:(){taskState.switchPage(3);}
                ),
              ),
          ],
        );
  }

}