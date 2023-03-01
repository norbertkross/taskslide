import 'package:flutter/material.dart';

class LoadingErrorState extends StatelessWidget {
 final double smallDevice = 650.0;

  @override
  Widget build(BuildContext context) {
    Size mq = MediaQuery.of(context).size;

    return Container(
      child: SizedBox(
        width: mq.width < smallDevice ? (mq.width + 200) : 1800.0,
        child: Wrap(
          alignment: WrapAlignment.start,
          children: [
            Text(
              "There Was an error",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
