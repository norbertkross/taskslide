import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:taskslide/state/state.dart';

class EditProjectTitle extends StatefulWidget {
  final int index;
  final String title;

  const EditProjectTitle({Key key, this.index, this.title}) : super(key: key);

  @override
  _EditProjectTitleState createState() => _EditProjectTitleState();
}

class _EditProjectTitleState extends State<EditProjectTitle> {

  final taskState = Get.put(TaskState());

  TextEditingController _controller;

  @override
  void initState(){
    _controller = TextEditingController(text: "${widget.title}"); 
    super.initState();
  }  

  @override
  Widget build(BuildContext context) {
    return  Padding(
            padding: const EdgeInsets.symmetric(vertical: 16,),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
              ),
              child: Container(
                width: 200.0,
                child: Column(
                  children: [

                    SizedBox(height: 10),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 6),
                      child: Container(
                        height: 35,
                        decoration: BoxDecoration(
                          color: Theme.of(context).disabledColor.withOpacity(.1),
                          borderRadius: BorderRadius.circular(7.0),
                        ),
                        child: TextField(
                          controller: _controller,
                           decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                             hintText: "Title",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 10),

                    Wrap(
                      children: [
                    GestureDetector(
                      onTap: (){
                        if(_controller.text.toString().trim().isNotEmpty){
                          taskState.editProjectTitle(widget.index, _controller.text.toString());
                          Navigator.pop(context);
                        }else{
                          Navigator.pop(context);
                        }
                      },
                      child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.green.withOpacity(.3),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 6),
                            child: Text("Done",
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
          );
  }
}