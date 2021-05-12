import 'package:flutter/material.dart';

class WSRectSwitch extends StatefulWidget {
  final ValueChanged<bool> onChanged;
  final Color activeColor;
  final Color disableColor;
  final bool value;

  const WSRectSwitch({Key key, this.onChanged, this.activeColor, this.disableColor, this.value}) : super(key: key);
  
  @override
  _WSRectSwitchState createState() => _WSRectSwitchState();
}

class _WSRectSwitchState extends State<WSRectSwitch> {

  double biggerContainer = 45.0;
  double smallContainerHeight = 20.0;
  double smallContainerWidth = 35.0;
  double borderRadius = 5.0;
  bool setValue = false;

  setValueState(){
    setState(() {
      setValue = ! setValue;
      widget.onChanged?.call(setValue);
    });
  }

  

  @override
  void initState() { 
    super.initState();
    
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget.onChanged?.call(widget.value??false);
     });

  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: (_){setValueState();},
      onTap: setValueState,
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: Duration(
                milliseconds: 350,
              ),
              width: biggerContainer,
              height: 25,
              decoration: BoxDecoration(
                color: widget.value == true? (widget.activeColor?.withOpacity(.35)??Theme.of(context).accentColor.withOpacity(.35)) : (widget.disableColor??Theme.of(context).disabledColor.withOpacity(.25)),
                borderRadius: BorderRadius.circular(borderRadius)
              ),
              child:
                  Stack(
                    children: [
                      AnimatedPositioned(
                        left:widget.value == false || widget.value == null ? 0.0 : (biggerContainer-35),
                        top: 0.0,
                        bottom: 0.0,
                        right: widget.value == false || widget.value == null ? (biggerContainer-35): 0.0,                        
                        curve: Curves.easeIn,
                        duration: Duration(
                          milliseconds: 300,
                        ),
                        child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal:4.0,vertical: 3),
                              child: Card(
                                elevation: 8.0,
                                margin: EdgeInsets.all(0),
                                shape: RoundedRectangleBorder(
                                  borderRadius:  BorderRadius.circular(borderRadius),
                                ),
                                child: AnimatedContainer(
                                duration: Duration(
                                  milliseconds: 350,
                                ),                                  
                                width:smallContainerWidth,
                                height: smallContainerHeight,
                                decoration: BoxDecoration(
                                  color:widget.value != true? Theme.of(context).cardColor :  (widget.activeColor??Theme.of(context).accentColor),
                                  borderRadius: BorderRadius.circular(borderRadius)
                                ),                
                             ),
                          ),
                        ),
                      ),
                    ],
                  ),
            )
        ],),
      ),
    );
  }
}
