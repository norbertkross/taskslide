import 'package:flutter/material.dart';

class EditComments extends StatefulWidget {
  @override
  _EditCommentsState createState() => _EditCommentsState();
}

class _EditCommentsState extends State<EditComments> {
  @override
  Widget build(BuildContext context) {
    return Column(
    children: [
      Padding(
        padding: const EdgeInsets.only(top:12.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          margin: EdgeInsets.all(0.0),
          child: Container(
            width: 280.0,
            child: Column(
              children: [
                SizedBox(height: 8.0,),

                
                // Textfield for name
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    // height: 35.0,
                    decoration: BoxDecoration(
                      color:Theme.of(context).disabledColor.withOpacity(.06),
                      borderRadius: BorderRadius.circular(8.0,),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom:12.0,left: 4.0),
                      child: TextField(
                        maxLines: null,
                        decoration: InputDecoration(
                          border: InputBorder.none,                                     
                        ),
                      ),
                    ),),
                ),

                // SAVE
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Wrap(
                    alignment: WrapAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: SizedBox(
                          width: 60.0,
                          child: Container(
                            height: 30.0,
                            decoration: BoxDecoration(
                              color:Theme.of(context).primaryColor.withOpacity(.4),
                              borderRadius: BorderRadius.circular(6.0,),
                            ),
                            child: Center(
                              child: Text("Update",style: TextStyle(
                                color: Theme.of(context).cardColor,
                                fontWeight: FontWeight.bold,
                              ),),
                            ),
                            ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: SizedBox(
                          width: 30.0,
                          child: Container(
                            height: 30.0,
                            decoration: BoxDecoration(
                              color:Theme.of(context).primaryColor.withOpacity(.4),
                              borderRadius: BorderRadius.circular(6.0,),
                            ),
                            child: Center(
                              child: Icon(Icons.delete_outline_rounded,color: Theme.of(context).cardColor,),
                            ),
                            ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: SizedBox(
                          width: 30.0,
                          child: Container(
                            height: 30.0,
                            decoration: BoxDecoration(
                              color:Theme.of(context).primaryColor.withOpacity(.4),
                              borderRadius: BorderRadius.circular(6.0,),
                            ),
                            child: Center(
                              child: Icon(Icons.close,color: Theme.of(context).cardColor,),
                            ),
                            ),
                        ),
                      ),

                      SizedBox(width: 8.0,),
                    ],
                  ),
                ),

                


                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
  }
}