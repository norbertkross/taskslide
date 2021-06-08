import 'package:flutter/material.dart';

class ChatHomeScreen extends StatefulWidget {
  @override
  _ChatHomeScreenState createState() => _ChatHomeScreenState();
}

class _ChatHomeScreenState extends State<ChatHomeScreen> {
  @override
  Widget build(BuildContext context) {
    Size mq = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        child: Row(
          children: [
            Container(
              width: 300,
              height: mq.height,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(.05),
              ),
              child: Column(
                children: [
                      ListTile(
                        trailing: Icon(Icons.chat),
                        title: Text("",style: TextStyle(
                        color: Theme.of(context).disabledColor,
                      ),),
                      subtitle: Padding(
                        padding: const EdgeInsets.symmetric(vertical:16.0),
                        child: Text("Your Chatrooms",style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),),
                      ),
                    ),                  
                  Flexible(
                    child: ListView(
                      children: [
                        Column(
                          children: [
                            // Padding(
                            //   padding: const EdgeInsets.all(8.0),
                            //   child: Divider(),
                            // ),

                            SizedBox(height: 16,),


                          for (var i = 0; i <= 10; i++)
                            Column(
                              children: [
                                Card(
                                  elevation: 20,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6),),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                    child: ListTile(
                                      onTap: (){},
                                      contentPadding: EdgeInsets.symmetric(vertical: 0,horizontal: 8),                          
                                      leading: CircleAvatar(
                                        //backgroundColor: The,
                                        child: Center(child: Text("B"),),
                                      ),
                                      title: Text("Babilonian Asassin",style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).disabledColor.withOpacity(.4),
                                      ),),
                                      subtitle: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                                        child: Text("This is the last message",style: TextStyle(
                                          
                                          color: Theme.of(context).disabledColor.withOpacity(.3),
                                        )),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10,),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Flexible(
              child: Container(
                child: ListView(
                  children: [

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}