import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Offset> _points = <Offset>[];

  List<List<Offset>> allPoints = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: GestureDetector(
          onPanStart: (DragStartDetails dragUpdateDetails) {},
          onPanUpdate: (DragUpdateDetails details) {
            setState(() {
              RenderBox object = context.findRenderObject()! as RenderBox;
              Offset _localPosition =
                  object.globalToLocal(details.globalPosition);
              _points.add(_localPosition);
              //_points = List.from(_points)..add(_localPosition);

              //allPoints[allPoints.length]..add(_points); // = _points;
              // allPoints.insert(allPoints.length, _points);
              // allPoints = List.from(allPoints)
              //   ..insert(allPoints.length, _points);
            });
          },
          onPanEnd: (DragEndDetails details) {
            setState(() {
             allPoints.add(_points);
              _points = List.from(_points)..clear();
            });

            // print(allPoints);
          },
          child: CustomPaint(
            isComplex: true,
            painter: Signature(points: allPoints),
            size: Size.infinite,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.clear),
        onPressed: () {
          setState(() {
            allPoints.clear();
          });
        },
      ),
    );
  }
}

class Signature extends CustomPainter {
  final List points;

  void drawLatestLines(List newPoints,
      {required Canvas canvas, required Paint paint}) {
    for (int i = 0; i < newPoints.length - 1; i++) {
      if (newPoints[i] != null && newPoints[i + 1] != null) {
        canvas.drawLine(newPoints[i], newPoints[i + 1], paint);
        // canvas.save();
        // canvas.restore();
        
      }
    }
  }

  Signature({required this.points});
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.blue
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 10.0;

    for (int y = 0; y <= points.length - 1; y++) {
      for (int i = 0; i < points[y].length - 1; i++) {
        if (points[y][i] != null && points[y][i + 1] != null) {
          canvas.drawLine(points[y][i], points[y][i + 1], paint);
        }
      }
    }

    // drawLatestLines(points[points.length-1], canvas: canvas, paint: paint);
  }

  @override
  bool shouldRepaint(Signature oldDelegate) => true;
}
