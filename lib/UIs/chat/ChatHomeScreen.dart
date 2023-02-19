import 'package:async_loader/async_loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskslide/UIs/chat/components/components.dart';
import 'package:taskslide/state/chatstate.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatHomeScreen extends StatefulWidget {
  @override
  _ChatHomeScreenState createState() => _ChatHomeScreenState();
}

class _ChatHomeScreenState extends State<ChatHomeScreen> {
  final GlobalKey<AsyncLoaderState> asyncLoaderState =
      GlobalKey<AsyncLoaderState>();
  double smallDevices = 650.0;
  bool isHomeScreen = true;

  final chatState = Get.put(ChatState());

  String giveTime(String dateString) {
    return timeago.format(
      DateTime.parse(dateString),
      //locale: "en_short",
    );
  }

  Widget bodyWrapper(
      {List<Widget> children, Widget w1, Widget w2, bool isHomeScreen}) {
    if (MediaQuery.of(context).size.width <= smallDevices) {
      return isHomeScreen == true
          ? Stack(
              children: [w1, w2],
            )
          : Stack(
              children: [w1, Container()],
            );
    } else {
      return Row(
        children: children,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size mq = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: ()async{
        setState(() {
          isHomeScreen = true;
        });
        return false;
      },
      child: Scaffold(
        body: SizedBox(
          // width: mq.width,
          child: bodyWrapper(
            isHomeScreen: isHomeScreen,
            w1:
                // Messages Body
                Container(
              child: messageBody(),
            ),
            w2: homeScreen(),
            children: [
              SizedBox(
                width: 0.001,
              ),
    
              homeScreen(),
    
              // Messages Body
              Flexible(
                child: Container(
                  child: messageBody(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _room({room}) {
    return Column(
      children: [
        Card(
          elevation: 20,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              hoverColor: Colors.transparent,
              onTap: () {
                chatState.setParentItem(room);
                setState(() {
                  isHomeScreen = false;
                });
                String rid =
                    "${room["date-time"]}-${room["id"]}-${room["creator"]}";
                chatState.setCurrentRoom(roomId: "019833", list: room);
              },
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
              leading: CircleAvatar(
                //backgroundColor: The,
                child: Center(
                  child: Text(
                      "${room["project-name"].toString() != "" ? room["project-name"].toString().substring(0, 1).toUpperCase() : "N"}"),
                ),
              ),
              title: Text(
                "${room["project-name"]}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).disabledColor.withOpacity(.4),
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                    "${room["project-body"].length} Task(s) in this project",
                    style: TextStyle(
                      color: Theme.of(context).disabledColor.withOpacity(.3),
                    )),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget homeScreen() {
    Size mq = MediaQuery.of(context).size;
    return Container(
      color: Theme.of(context).canvasColor,
      child: Container(
        width: mq.width <= smallDevices ? mq.width : 300,
        height: mq.height,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(.05),
        ),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).viewPadding.top + 4.0,
            ),
            ListTile(
              trailing: Icon(Icons.chat),
              title: Text(
                "",
                style: TextStyle(
                  color: Theme.of(context).disabledColor,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  "Your Chatrooms",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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

                      SizedBox(
                        height: 16,
                      ),

                      AsyncLoader(
                          key: asyncLoaderState,
                          // Show error widget when there's  an error
                          renderError: ([error]) => Container(
                                child: SizedBox(
                                  width: mq.width,
                                  child: Column(
                                    children: [
                                      Wrap(
                                        alignment: WrapAlignment.center,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(top: 40),
                                            child: Text(
                                              "There was wn error please\ncheck your network and\ntry again",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Wrap(
                                          alignment: WrapAlignment.center,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 14.0),
                                              child: Tooltip(
                                                message: "Retry",
                                                child: MouseRegion(
                                                  cursor:
                                                      SystemMouseCursors.click,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      //  setState((){ });
                                                      asyncLoaderState
                                                          .currentState
                                                          .reloadState()
                                                          .whenComplete(() => print(
                                                              'finished reload'));
                                                    },
                                                    child: Card(
                                                      elevation: 30,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(16.0),
                                                      ),
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal:
                                                                    12.0,
                                                                vertical: 4),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Text(
                                                              "Retry",
                                                              style: TextStyle(
                                                                color: Theme.of(
                                                                        context)
                                                                    .cardColor,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 6,
                                                            ),
                                                            RotatedBox(
                                                                quarterTurns: 3,
                                                                child: Icon(
                                                                  Icons
                                                                      .refresh_rounded,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .cardColor,
                                                                  size: 22,
                                                                ))
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ]),
                                    ],
                                  ),
                                ),
                              ),

                          // Show loader whille data is loading
                          renderLoad: () => Container(
                                child: SizedBox(
                                  width: mq.width,
                                  child: Wrap(
                                    alignment: WrapAlignment.center,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(top: 40),
                                        child:  CupertinoActivityIndicator(
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                                radius: 12,
                                                              ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          initState: () async =>
                              await chatState.getAllMessageRooms(
                                  email: 'norbertaberor@gmail.com'),
                          renderSuccess: ({data}) {
                            if (data.length > 0) {
                              return Wrap(
                                children: [
                                  for (int room = 0;
                                      room <= data.length - 1;
                                      room++)
                                    _room(room: data[room]),
                                ],
                              );
                            } else if (data.length == 0) {
                              return Container(
                                child: SizedBox(
                                  width: mq.width,
                                  child: Column(
                                    children: [
                                      Wrap(
                                        alignment: WrapAlignment.center,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(top: 40),
                                            child: Text(
                                              "You're currently not part of any project yet",
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Wrap(
                                          alignment: WrapAlignment.center,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 14.0),
                                              child: Tooltip(
                                                message: "Retry",
                                                child: MouseRegion(
                                                  cursor:
                                                      SystemMouseCursors.click,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      //  setState((){ });
                                                      asyncLoaderState
                                                          .currentState
                                                          .reloadState()
                                                          .whenComplete(() => print(
                                                              'finished reload'));
                                                    },
                                                    child: Card(
                                                      elevation: 30,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(16.0),
                                                      ),
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal:
                                                                    12.0,
                                                                vertical: 4),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Text(
                                                              "Retry",
                                                              style: TextStyle(
                                                                color: Theme.of(
                                                                        context)
                                                                    .cardColor,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 6,
                                                            ),
                                                            RotatedBox(
                                                                quarterTurns: 3,
                                                                child: Icon(
                                                                  Icons
                                                                      .refresh_rounded,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .cardColor,
                                                                  size: 22,
                                                                ))
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ])
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              return Container(
                                child: SizedBox(
                                  width: mq.width < smallDevices
                                      ? (mq.width + 200)
                                      : 1800.0,
                                  child: Wrap(
                                    alignment: WrapAlignment.start,
                                    children: [
                                      Text(
                                        "There Was an error",
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                          }),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget messageBody() {
    Size mq = MediaQuery.of(context).size;

    return Column(
      children: [
        Flexible(
          child: ListView(
            children: [
              SizedBox(
                height: MediaQuery.of(context).viewPadding.top + 6.0,
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: SizedBox(
                    child: Row(
                      children: [
                       mq.width <= smallDevices?Container(
                          child: IconButton(
                          onPressed: (){
                          setState(() {
                              isHomeScreen = true;
                            });
                          }, 
                          icon: Icon(Icons.chevron_left_rounded,color: Theme.of(context).disabledColor,)),
                        ): Container(width: 25,height: 25,),

                        Flexible(
                          child: Center(
                            child: Obx(
                              () => Text(
                                chatState.parentListItem != null &&
                                        chatState.parentListItem.length != 0 &&
                                        chatState.parentListItem != []
                                    ? chatState.parentListItem[0]["project-name"]
                                        .toString()
                                    : chatState.isLoadingChats.value == false
                                        ? ""
                                        : "loading...",
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor.withOpacity(.8),
                                  //color: Theme.of(context).canvasColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ),

                        Container(width: 25,height: 25,),
                      ],
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                  //color: Theme.of(context).primaryColor.withOpacity(.8),
                  color: Theme.of(context).canvasColor,
                ),
              ),
              SizedBox(
                height: 60,
              ),
              GetBuilder<ChatState>(builder: (builder) {
                print(chatState.messages);

                return Column(
                  children: [
                    if (chatState.messages != null && chatState.messages != [])
                      for (int j = 0; j <= chatState.messages.length - 1; j++)
                        Column(
                          children: [
                            if (chatState.messages[j]["senderid"].toString() !=
                                "norbertaberor@gmail.com")
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(width: mq.width),
                                  MessageLeft(
                                    username: chatState.messages[j]["username"]
                                        .toString(),
                                    message: chatState.messages[j]["message"]
                                        .toString(),
                                    time: chatState.messages[j]["datetime"]
                                                .toString() !=
                                            "null"
                                        ? giveTime(chatState.messages[j]
                                                ["datetime"]
                                            .toString())
                                        : giveTime("2020-07-06T20:39:31.292Z"),
                                  ),
                                ],
                              )
                            else
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  SizedBox(width: mq.width),
                                  MessageRight(
                                    message: chatState.messages[j]["message"]
                                        .toString(),
                                    time: chatState.messages[j]["datetime"]
                                                .toString() !=
                                            "null"
                                        ? giveTime(chatState.messages[j]
                                                ["datetime"]
                                            .toString())
                                        : giveTime("2020-07-06T20:39:31.292Z"),
                                  ),
                                ],
                              ),
                          ],
                        )
                    else
                      Container()
                  ],
                );
              }),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Container(
            width: mq.width,
            height: 60.0,
            //color: Colors.green,
            child: Row(
              children: [
                SizedBox(
                  width: mq.width <= smallDevices ? 2.0 : 8.0,
                ),
                Flexible(
                  child: Card(
                    elevation: 20,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Container(
                      height: 70.0,
                      child: TextField(
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 8),
                            hintText: "  Type something ...",
                            border: InputBorder.none),
                      ),
                    ),
                  ),
                ),
                Card(
                    elevation: 20,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Container(
                      width: 70,
                      child: Transform.rotate(
                        angle: .8,
                        child: Center(
                          child: IconButton(
                              onPressed: () {
                                print("Sending Message... Done!");
                              },
                              icon: Icon(
                                Icons.navigation_rounded,
                                color: Theme.of(context).primaryColor,
                              )),
                        ),
                      ),
                    )),
                SizedBox(
                  width: mq.width <= smallDevices ? 8.0 : 16.0,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
