import 'package:flutter/material.dart';

import 'clock.dart';
import 'game-time.dart';

class TimeSelectionWidget extends StatefulWidget {
  static const routeName = '/time-selection';

  TimeSelectionWidget({Key key}) : super(key: key);

  _TimeSelectionWidgetState createState() => _TimeSelectionWidgetState();
}

class _TimeSelectionWidgetState extends State<TimeSelectionWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: clockSelectionScreen(),
    );
  }

  Widget clockSelectionScreen() {
    return Container(
      color: Colors.grey[300],
      child: Wrap(
        direction: Axis.horizontal,
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: <Widget>[
          timerOption("1 Hour", GameTime.Hour),
          timerOption("20 Minute", GameTime.TwentyMinute),
          timerOption("10 Minute", GameTime.TenMinute),
          timerOption("5 Minute", GameTime.FiveMinute),
          timerOption("3 Minute", GameTime.ThreeMinute),
          timerOption("1 Minute", GameTime.OneMinute),
          timerOption("30 Second", GameTime.ThirtySecond)
        ],
      ),
    );
  }

  MaterialButton timerOption(String timerText, GameTime timerOption) {
    return RaisedButton(
      onPressed: () {
        int durationInSeconds = 0;
        switch (timerOption) {
          case GameTime.ThirtySecond:
            durationInSeconds = 30;
            break;
          case GameTime.OneMinute:
            durationInSeconds = 60;
            break;
          case GameTime.ThreeMinute:
            durationInSeconds = 180;
            break;
          case GameTime.FiveMinute:
            durationInSeconds = 300;
            break;
          case GameTime.TenMinute:
            durationInSeconds = 600;
            break;
          case GameTime.TwentyMinute:
            durationInSeconds = 1200;
            break;
          case GameTime.Hour:
            durationInSeconds = 3600;
            break;
          default:
        }

        Navigator.pushNamed(context, ClockWidget.routeName,
            arguments: durationInSeconds);
      },
      child: Text(
        timerText,
        style: TextStyle(
          fontSize: 30,
          backgroundColor: Colors.blue,
        ),
      ),
    );
  }
}
