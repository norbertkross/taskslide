import 'package:flutter/material.dart';

class CustomBodyDialog extends StatefulWidget {
  final Widget child;

  const CustomBodyDialog({Key key, this.child}) : super(key: key);
  @override
  _CustomBodyDialogState createState() => _CustomBodyDialogState();
}

class _CustomBodyDialogState extends State<CustomBodyDialog> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.black.withOpacity(.75),
            ),
            GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: Theme.of(context).primaryColor.withOpacity(.1),
              ),
            ),

            Column(
              children: [
                Center(child: widget.child??Container()),
              ],
            )
          ],
        ),
      ],
    );
  }
}