import 'package:flutter/material.dart';

class RequestErrorWidget extends StatelessWidget {
  final Function onRetry;
  const RequestErrorWidget({Key key, this.onRetry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size mq = MediaQuery.of(context).size;

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
                    "There was an error please\ncheck your network and\ntry again",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ],
            ),
            Wrap(alignment: WrapAlignment.center, children: [
              Padding(
                padding: const EdgeInsets.only(top: 14.0),
                child: Tooltip(
                  message: "Retry",
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        onRetry?.call();                       
                      },
                      child: Card(
                        elevation: 30,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        color: Theme.of(context).primaryColor,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 4),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Retry",
                                style: TextStyle(
                                  color: Theme.of(context).cardColor,
                                ),
                              ),
                              SizedBox(
                                width: 6,
                              ),
                              RotatedBox(
                                  quarterTurns: 3,
                                  child: Icon(
                                    Icons.refresh_rounded,
                                    color: Theme.of(context).cardColor,
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
    );
  }
}
