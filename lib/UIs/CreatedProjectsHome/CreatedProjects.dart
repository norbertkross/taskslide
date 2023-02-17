import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskslide/UIs/CreatedProjectsHome/Add-To-Task.dart';
import 'package:taskslide/UIs/CreatedProjectsHome/editProjectTitle.dart';
import 'package:taskslide/state/state.dart';
import 'package:timeago/timeago.dart' as timeago;

class CreatedProjects extends StatefulWidget {
  @override
  _CreatedProjectsState createState() => _CreatedProjectsState();
}

class _CreatedProjectsState extends State<CreatedProjects> {

  double gridItemWidth = 200.0;
  int currentHover = -1;
  double smallDevice = 650.0;

  final taskState = Get.put(TaskState());

  String giveTime(int index){
    return timeago.format(DateTime.parse(taskState.allTasks[index]["date-time"]),
    //locale: "en_short",
    );
  }


dateTimeRangePicker(int index) async {
  DateTimeRange picked = await showDateRangePicker(
    context: context,
    firstDate: DateTime(DateTime.now().year - 2),
    lastDate: DateTime(DateTime.now().year + 10),
    initialDateRange: DateTimeRange(
      start: DateTime.now(),
      end:DateTime(
          DateTime.now().year, 
          DateTime.now().month, 
          DateTime.now().day+3),
      
    ),
  );

  if(picked != null){
  taskState.setDateRange(index,start: "${picked.start}",end: "${picked.end}");
  }
}  

  @override
  Widget build(BuildContext context) {
    Size mq = MediaQuery.of(context).size;
    return Scaffold(
      //backgroundColor: Color(0xffF4F5F7),
      body: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: mq.width < smallDevice ? (mq.width + 200) : 1800.0,
              child: ListView(
                children: [
                  
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            
        GetBuilder<TaskState>(builder: (builder)=>
          Wrap(
              children: [
            for(int projectsIndex=0; projectsIndex <= taskState.allTasks.length-1;projectsIndex++)
            // GetBuilder(builder: (builder)=>
                Padding(
                padding:  EdgeInsets.only(
                  top: 8.0,
                  left: currentHover == projectsIndex? 12.0:8.0,
                  bottom: 8.0,
                  right: 8.0,),
                child: MouseRegion(                          
                 onEnter: (_){
                   setState(() {
                      currentHover = projectsIndex;
                    });
                  },
                  onExit: (_){
                    setState(() {
                      currentHover = -1;
                    });
                  },
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: (){                                        
                    taskState.switchCurrentRunningProcess(projectsIndex);
                    taskState.switchPage(0);
                  },
                    child: Card(
                      shadowColor: currentHover == projectsIndex? Theme.of(context).primaryColor.withOpacity(.2): Colors.transparent,
                      elevation: 20.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      child: Container(
                        width: gridItemWidth,
                        child: Column(
                          children: [

                            SizedBox(
                              width: gridItemWidth,
                              child: Wrap(
                                alignment: WrapAlignment.start,
                                children: [

                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal:8.0,vertical: 4.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [

                                  SizedBox(
                                    width: gridItemWidth,
                                    child: Wrap(
                                      alignment: WrapAlignment.end,
                                      children: [
                                        GestureDetector(
                                          onTap: (){
                                        taskState.buildEditDialog(
                                          context,
                                          child: EditProjectTitle(
                                            index: projectsIndex,
                                            title: "${taskState.allTasks[projectsIndex]["project-name"]}",),);
                                          },
                                          child: Tooltip(
                                            message: "Edit title",
                                            child: MouseRegion(
                                              cursor: SystemMouseCursors.click,
                                              child: Icon(Icons.edit,
                                            size: 18.0,
                                            color:Theme.of(context).disabledColor.withOpacity(.2)),),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                        Text("${taskState.allTasks[projectsIndex]["project-name"]}",
                                        style: TextStyle(
                                          color: Theme.of(context).disabledColor.withOpacity(.6),
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w600,
                                        ),),

                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical:4.0),
                                           //${taskState.allTasks[projectsIndex]["project-body"].length}
                                          child: Text("${giveTime(projectsIndex)}",
                                          style: TextStyle(
                                            color: Theme.of(context).disabledColor.withOpacity(.2),
                                            fontSize: 13.0,
                                            fontWeight: FontWeight.w600,
                                          ),),
                                        ),
                                      ],
                                    ),
                                  ),

                                SizedBox(height: 120,),

                                  SizedBox(
                                    width: gridItemWidth,
                                    child: Wrap(
                                      alignment: WrapAlignment.end,
                                      children: [

                                        IconButton(
                                          hoverColor: Colors.transparent,
                                        tooltip: "Delete",
                                        icon: Icon(Icons.delete_outline,
                                        size: 18.0,
                                        color: Colors.red), 
                                        onPressed: (){
                                          taskState.buildEditDialog(context,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 16,),
                                            child: Card(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(8.0),
                                              ),
                                              child: Container(
                                                width: 200.0,
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 3),
                                                      child: Text("Do you want to delete this project?",
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                        color: Colors.red,
                                                      ),),
                                                    ),

                                                    SizedBox(height: 10),

                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      children: [
                                                    GestureDetector(
                                                      onTap: (){
                                                        taskState.allTasks.removeAt(projectsIndex);
                                                        taskState.generateList();
                                                        Navigator.pop(context);
                                                      },
                                                      child: MouseRegion(
                                                        cursor: SystemMouseCursors.click,
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(10),
                                                            color: Colors.red.withOpacity(.3),
                                                          ),
                                                          child: Padding(
                                                            padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 6),
                                                            child: Text("Yes",
                                                              textAlign: TextAlign.center,
                                                              style: TextStyle(
                                                                color: Colors.red,
                                                                fontWeight: FontWeight.bold,
                                                              ),),
                                                          ),
                                                        ),
                                                      ),
                                                    ), 
                                                    SizedBox(width: 30.0,),
                                                    GestureDetector(
                                                      onTap: (){
                                                        Navigator.pop(context);
                                                      },
                                                      child: MouseRegion(
                                                          cursor: SystemMouseCursors.click,
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(10),
                                                            color: Colors.green.withOpacity(.3),
                                                          ),
                                                          child: Padding(
                                                            padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 6),
                                                            child: Text("No",
                                                              textAlign: TextAlign.center,
                                                              style: TextStyle(
                                                                color: Colors.green,
                                                                fontWeight: FontWeight.bold,
                                                              ),),
                                                          ),
                                                        ),
                                                      ),
                                                    ),                                                       
                                                      ],
                                                    ),

                                                    SizedBox(height: 10),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ) );
                                        }),

                                        IconButton(
                                          hoverColor: Colors.transparent,
                                        tooltip: "People",
                                        icon: Icon(Icons.people_alt,
                                        size: 18.0,
                                        color:Theme.of(context).disabledColor.withOpacity(.2)), 
                                        onPressed: (){}),

                                        IconButton(
                                        hoverColor: Colors.transparent,
                                        tooltip: "Set date",
                                        icon: Icon(Icons.date_range_outlined,
                                        size: 18.0,
                                        color:Colors.green), 
                                        onPressed: (){dateTimeRangePicker(projectsIndex);}),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              height: 8,
                              width: gridItemWidth,
                              decoration: BoxDecoration(
                                color: taskState.currentRunningProjectId.value == projectsIndex ?Theme.of(context).primaryColor:Colors.transparent,
                                borderRadius: BorderRadius.vertical(
                                  bottom: Radius.circular(6.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

            InputAndAddListButton(),
            
              ],
            ),
                        ),
                    ],
                  ),

                ],),
                ),),      
    );
  }
}