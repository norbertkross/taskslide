import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


// Left Message Bubble
class MessageLeft extends StatelessWidget {
  final String username;
  final String message;
  final String time;
  MessageLeft({key, this.username, this.message, this.time }) : super(key: key);

  var defaultRadius = 20.0;

  double chatItemWidth = 400.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left:8.0,right: 80,bottom: 12),
      child: Card(
        elevation: 20.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(defaultRadius),
            topLeft: Radius.circular(defaultRadius),
            ///bottomLeft: ,
            bottomRight: Radius.circular(defaultRadius),
          ),          
        ),
        child: Container(
          padding: EdgeInsets.all(6.0),
          width: chatItemWidth,
          decoration: BoxDecoration(
            //color: Colors.green.withOpacity(.7),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: chatItemWidth,
                child: Wrap(
                  alignment: WrapAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right:16.0,),
                      child: Text(username ?? "username",style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                        fontSize: 15,
                      ),),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 4,),
              Padding(
                padding: const EdgeInsets.only(left:12.0),
                child: Text(message ?? "Message on your screen",style: TextStyle(
                  fontSize: 15,
                  color: Theme.of(context).disabledColor
                )),
              ),

              SizedBox(
                width: chatItemWidth,
                child: Wrap(
                  alignment: WrapAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right:16.0,top:4),
                      child: Text(time?? "12:43 am",style: TextStyle(
                        // fontWeight: FontWeight.bold,
                        color: Theme.of(context).disabledColor,
                        fontSize: 13,
                      ),),
                    ),
                  ],
                ),
              ),      
            ],
          ),
          
        ),
      ),
    );
  }
}




// Right Message Bubble
class MessageRight extends StatelessWidget {
  final String message;
  final String time;
  MessageRight({key,this.message, this.time }) : super(key: key);

  var defaultRadius = 20.0;

  double chatItemWidth = 400.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right:8.0,left: 80,bottom: 12),
      child: Card(
        elevation: 20.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(defaultRadius),
            topLeft: Radius.circular(defaultRadius),
            bottomLeft: Radius.circular(defaultRadius),
            //bottomRight: Radius.circular(defaultRadius),
            //bottomRight: Radius.circular(defaultRadius),
          ),          
        ),
        child: Container(
          padding: EdgeInsets.all(6.0),
          width: chatItemWidth,
          decoration: BoxDecoration(
            //color: Colors.green.withOpacity(.7),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              SizedBox(height: 12,),
              Padding(
                padding: const EdgeInsets.only(left:12.0),
                child: Text(message ?? "Message on your screen",style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).disabledColor
                )),
              ),

              SizedBox(
                width: chatItemWidth,
                child: Wrap(
                  alignment: WrapAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left:16.0,top:4),
                      child: Text(time?? "12:43 am",style: TextStyle(
                        // fontWeight: FontWeight.bold,
                        color: Theme.of(context).disabledColor,
                        fontSize: 13,
                      ),),
                    ),
                  ],
                ),
              ),      
            ],
          ),
          
        ),
      ),
    );
  }
}