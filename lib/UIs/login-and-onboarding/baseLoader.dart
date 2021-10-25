import 'package:flutter/material.dart';

class BaseLoader extends StatefulWidget {
  const BaseLoader({ Key key }) : super(key: key);

  @override
  _BaseLoaderState createState() => _BaseLoaderState();
}

class _BaseLoaderState extends State<BaseLoader> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(child: Container(
          width: 250,
          height: 250,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage("assets/appicon.png")),
        ),
        ),),
      ),
    );
  }
}