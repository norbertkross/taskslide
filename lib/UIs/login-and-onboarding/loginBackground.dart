import 'package:flutter/material.dart';

class LoginBackround extends StatefulWidget {
  @override
  _LoginBackroundState createState() => _LoginBackroundState();
}

class _LoginBackroundState extends State<LoginBackround> {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: WaveClipper(),
      child: Column(
        children: <Widget>[
          Stack(
            children: [
              Container(
                color: Theme.of(context).primaryColor,
                height: MediaQuery.of(context).size.height * (50 / 100),
                width: MediaQuery.of(context).size.width * (100 / 100),
              ),
              Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .25,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Center(
                          child: Text(
                        "Login",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 34),
                      )),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

//clipper class
class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    path.lineTo(0.0, size.height - (size.height * (50 / 100)));
    //path.lineTo(size.width*(20/100), (size.height-(size.height*(50/100))));

    // {size.width/4 , (size.height-(size.height*(50/100)))-(size.height*(35/100))}
    var firstControlPoint = Offset(
        size.width / 4.5,
        (size.height - (size.height * (50 / 100))) -
            (size.height * (15 / 100)));
    // {size.width/2.5 , (size.height-(size.height*(50/100)))-(size.height*(20/100)) }
    var firstEndPoint = Offset(
        size.width / 1.6,
        (size.height - (size.height * (50 / 100))) -
            (size.height * (10 / 100)));
    // path
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    //  {size.width *(.75) , size.height-(size.height*(50/100)) }
    var secondControlPoint =
        Offset(size.width * (.85), size.height - (size.height * (57 / 100)));
    // {size.width , (size.height-(size.height*(50/100)))-(size.height*(35/100)) }
    var secondEndPoint = Offset(
        size.width,
        (size.height - (size.height * (50 / 100))) -
            (size.height * (15 / 100)));
    // path
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(
        size.width,
        (size.height - (size.height * (50 / 100))) -
            (size.height * (10 / 100)));
    path.lineTo(size.width, 0.0);

    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldCliper) => false;
}
