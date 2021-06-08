import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:taskslide/state/collaborationState.dart';
import 'package:taskslide/state/state.dart';

class CollaborationParentInputAndButton extends StatefulWidget {
  const CollaborationParentInputAndButton({Key key,}) : super(key: key);
  @override
  _CollaborationParentInputAndButtonState createState() => _CollaborationParentInputAndButtonState();
}

class _CollaborationParentInputAndButtonState extends State<CollaborationParentInputAndButton> {
final taskState = Get.put(TaskState());
final colllaborationState = Get.put(ColllaborationState());
  
final TextEditingController controller = TextEditingController();
String get input => controller.text; 

  @override
  Widget build(BuildContext context) {
    return Container(
      key: UniqueKey(),
      child: Obx(()=>
         Container(
          child: colllaborationState.showInput.value == true?
          Padding(
            padding: const EdgeInsets.only(top:8.0),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Card(
                  shadowColor: Colors.transparent,
                  elevation: 20.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Container(
                    width: 200.0,
                    height: 40.0,
                    child: TextField(
                      controller: controller,
                      cursorColor: Theme.of(context).primaryColor.withOpacity(.5),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "New list",
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).disabledColor.withOpacity(.3),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                      ),
                    ),
                  ),
                ),

                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: (){
                     if(input.trim().isNotEmpty){
                        colllaborationState.callToAddParent(input);
                        controller.clear();
                      }                                                  
                    },
                    child: Card(
                      color:Theme.of(context).brightness == Brightness.light? Theme.of(context).primaryColor : Theme.of(context).primaryColor.withOpacity(.5),
                      shadowColor: Colors.transparent,
                      elevation: 20.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Container(
                        width: 80.0,
                        height: 35.0,
                        child: Center(
                          child: Text("Create",
                            style: TextStyle(
                              color: Theme.of(context).canvasColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                GestureDetector(
                  onTap: (){
                    //setState(() {
                      // showInput = false;    
                      // generateList(taskList);              
                      // });
                      colllaborationState.callToCloseParentAddition();
                },
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Container(
                      height: 35.0,
                      width: 30.0,
                      child: Icon(Icons.close,color: Theme.of(context).disabledColor,),
                    ),
                  ),
                ),
              ],
            ),
          )
          :
          GestureDetector(
            onTap: (){
                colllaborationState.addToParentButton();                
            },
            child: Padding(
              padding: const EdgeInsets.only(top:10.0),
              child: Tooltip(
                message: "new list",
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Padding(
                    padding: const EdgeInsets.only(left:8.0),
                    child: Card(
                    shadowColor: Theme.of(context).primaryColor.withOpacity(.25),
                    //.size.width < 650.0?null:Colors.transparent,
                    elevation: MediaQuery.of(context).size.width < 650.0? 12.0:16.0,                            
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Container(
                          width: MediaQuery.of(context).size.width < 650.0? 60: 40.0,
                          height: MediaQuery.of(context).size.width < 650.0? 50.0: 80.0,
                        child: Obx(()=> Icon(
                            Icons.add,
                            color: taskState.themeMode.value == true?Theme.of(context).disabledColor: Colors.black.withOpacity(.4),
                            size: 20.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}